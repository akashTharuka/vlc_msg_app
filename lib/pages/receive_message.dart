import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vlc_msg_app/db/db_helper.dart';
import 'package:vlc_msg_app/models/user.dart';
import 'package:vlc_msg_app/utils/encoder.dart';
import 'package:vlc_msg_app/utils/rsa.dart';
import 'package:vlc_msg_app/utils/transmitter.dart';
import 'package:vlc_msg_app/pages/message_history.dart';

class ReceiveMessagePage extends StatefulWidget {
  @override
  _ReceiveMessagePageState createState() => _ReceiveMessagePageState();
}

class _ReceiveMessagePageState extends State<ReceiveMessagePage> {
  late Future<List<CameraDescription>> _camerasFuture;
  String _currentUserPrivateKey = '';

  @override
  void initState() {
    super.initState();
    _camerasFuture = availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar(context),
        body: FutureBuilder<List<CameraDescription>>(
          future: _camerasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                      child: Image.asset('assets/images/BareLogo.png'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Camera Preview
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.52, // adjust this to fit your needs
                      width: MediaQuery.of(context).size.width *
                          0.9, // adjust this to fit your needs
                      child: CameraPreviewWidget(
                        camera: snapshot.data!.first,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    // Text Field
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      margin: const EdgeInsets.only(
                          top: 15, bottom: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(227, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Material(
                        type: MaterialType.transparency,
                        child: TextField(
                          style: TextStyle(fontSize: 15.0),
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'View your message here...',
                            hintStyle: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(222, 158, 158, 158)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    ]);
  }
}

class CameraPreviewWidget extends StatefulWidget {
  final CameraDescription camera;

  const CameraPreviewWidget({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  _CameraPreviewWidgetState createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late CameraController _cameraController;
  bool _isReceiving = false;
  String _receivedBinary = "";
  bool _transmissionActive = false;
  double FLASHLIGHT_THRESHOLD = 0.8;
  double PIXEL_COUNT_RATIO_THRESHOLD = 0.1;
  final List<CameraImage> _images = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.low,
      enableAudio: false,
    );

    await _cameraController.initialize().then((_) {
      if (!_cameraController.value.isInitialized) {
        return;
      }

      setState(() {});
    });
  }

  void _startReceiving() {
    if (_isReceiving) return;

    setState(() {
      _isReceiving = true;
      _receivedBinary = "";
      _transmissionActive = false; // Initially, the transmission isn't active
    });

    _cameraController.startImageStream((image) async {
      _images.add(image);
    });
  }

  void _stopReceiving() async {

    _cameraController.stopImageStream();

    setState(() {
      _isReceiving = false;
      _transmissionActive = false;
    });

    for (CameraImage image in _images) {
      if (_isFlashlightOn(_convertToGrayscale(image))) {
        if (!_transmissionActive) {
          // If the transmission is not active, check for the start signal
          _receivedBinary += '1';

          if (_receivedBinary.endsWith(Transmitter.startString)) {
            _transmissionActive = true; // Transmission starts
            _receivedBinary = "";
          }
        } else {
          _receivedBinary += '1';
        }
      } else {
        _receivedBinary += '0';
      }
    }

    DatabaseHelper dbHelper = DatabaseHelper();
    User user = await dbHelper.getUser();

    final String encryptedMsg = await RSAUtils.encryptRSA('hello world!', user.publicKey);
    final String encodedMsg = Encoder.encodeToBinary(encryptedMsg);

    String decodedMsg = Encoder.decodeFromBinary(encodedMsg);
    print("Decoded message: $decodedMsg");
    String originalMsg = await RSAUtils.decryptRSA(decodedMsg, user.privateKey);
    print("Original message: $originalMsg");

    // Remove start and end strings, if present
    // var receivedBinaryWithoutMarkers = _receivedBinary.replaceAll(Transmitter.startString, '');
    // receivedBinaryWithoutMarkers = receivedBinaryWithoutMarkers.replaceAll(Transmitter.endString, '');

    print("Received binary: $_receivedBinary");
    identifyPattern(_receivedBinary);
  }

  void identifyPattern(String binaryString) {
    var result = '';
    var currVal = '1';
    var count = 1;
    int threshold = 14;

    String startSequence = '01111110';
    String endSequence = '01100000';

    bool transmissionStarted = false;

    for (int i = 1; i < binaryString.length; i++) {
      if (binaryString[i] == binaryString[i - 1]) {
        count++;
      } else {
        if (count <= threshold) {
          result += currVal;
          count = 1;
        }
        else {
          currVal = currVal == '1' ? '0' : '1';
          result += currVal;
          count = 1;
        }
      }

      // Check for the start and end sequences
      if (!transmissionStarted && result.endsWith(startSequence)) {
        transmissionStarted = true;
        result = '';
      } else if (transmissionStarted && result.endsWith(endSequence)) {
        transmissionStarted = false;
        print("Identified pattern: $result");
        result = '';
      }
    }

    print("Identified pattern: $result");
  }

  img.Image _convertToGrayscale(CameraImage cameraImage) {

    // Convert CameraImage to a usable format (like YUV to RGB)
    final img.Image image = _convertYUV420toImage(cameraImage);

    // Convert the image to grayscale
    return img.grayscale(image);
  }

  img.Image _convertYUV420toImage(CameraImage cameraImage) {

    // Get image dimensions
    final width = cameraImage.width;
    final height = cameraImage.height;

    // Extract the Y, U, V planes
    final yPlane = cameraImage.planes[0].bytes;
    final uPlane = cameraImage.planes[1].bytes;
    final vPlane = cameraImage.planes[2].bytes;

    // Create a new image with the desired dimensions
    final img.Image image = img.Image(width: width, height: height);

    // Define offsets for U and V planes
    final uPixelStride = cameraImage.planes[1].bytesPerPixel ?? 8;
    final vPixelStride = cameraImage.planes[2].bytesPerPixel ?? 8;

    final uRowStride = cameraImage.planes[1].bytesPerRow;
    final vRowStride = cameraImage.planes[2].bytesPerRow;

    // Convert YUV to RGB
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        
        // Get the Y, U, V values for this pixel
        final yVal = yPlane[y * cameraImage.planes[0].bytesPerRow + x];

        // Calculate indices for U and V values
        final uIndex = (y ~/ 2) * uRowStride + (x ~/ 2) * uPixelStride;
        final vIndex = (y ~/ 2) * vRowStride + (x ~/ 2) * vPixelStride;

        final uVal = uPlane[uIndex] - 128;
        final vVal = vPlane[vIndex] - 128;

        // Convert YUV to RGB
        final r = yVal + (1.370705 * vVal).round();
        final g = yVal - (0.337633 * uVal + 0.698001 * vVal).round();
        final b = yVal + (1.732446 * uVal).round();

        // Clamp RGB values to be within 0-255 range
        final red = r.clamp(0, 255);
        final green = g.clamp(0, 255);
        final blue = b.clamp(0, 255);

        img.Color color = img.ColorInt8.rgb(red, green, blue);

        // Set pixel in the image
        image.setPixel(x, y, color);
      }
    }

    return image;
  }

  bool _isFlashlightOn(img.Image grayscaleImage) {
    
    int bright_pixel_count = 0;
    int total_pixel_count = grayscaleImage.width * grayscaleImage.height;

    // Loop through all pixels to check their intensity
    for (int y = 0; y < grayscaleImage.height; y++) {
      for (int x = 0; x < grayscaleImage.width; x++) {
        // Get the pixel value (0 to 255 for grayscale)
        num pixel = grayscaleImage.getPixel(x, y).luminance;

        // Normalize the intensity to 0-1
        double intensity = pixel / 255.0;

        // Check if the intensity exceeds the threshold
        if (intensity > FLASHLIGHT_THRESHOLD) {
          if (++bright_pixel_count >
              total_pixel_count * PIXEL_COUNT_RATIO_THRESHOLD) {
            return true; // Flashlight detected
          }
        }
      }
    }

    return false; // Flashlight not detected
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }
    return Column(
      children: [
        AspectRatio(
          aspectRatio: _cameraController.value.aspectRatio,
          child: CameraPreview(_cameraController),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            start(context),
            const SizedBox(width: 10),
            stop(context),
          ],
        ),
      ],
    );
  }

  Container start(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Colors.white.withOpacity(0.9)),
          foregroundColor:
              MaterialStateProperty.all(Colors.black.withOpacity(0.55)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
        ),
        onPressed: () {
          _startReceiving();
        },
        child: Text(
          'Start',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Container stop(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Colors.white.withOpacity(0.9)),
          foregroundColor:
              MaterialStateProperty.all(Colors.black.withOpacity(0.55)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
        ),
        onPressed: () {
          _stopReceiving();
        },
        child: Text(
          'Stop',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // here too
      elevation: 0, // and here
      title: Text(
        'Receive Message',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_left),
        // onPressed: () {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => const HomeScreen()),
        //   );
        // },
        onPressed: () {
          Navigator.pop(context);
        },
        color: Theme.of(context).colorScheme.background,
      ),
    );
  }
}
