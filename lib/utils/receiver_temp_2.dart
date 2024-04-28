import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:vlc_msg_app/utils/transmitter.dart';

class ReceiveMessagePage extends StatefulWidget {
  @override
  _ReceiveMessagePageState createState() => _ReceiveMessagePageState();
}

class _ReceiveMessagePageState extends State<ReceiveMessagePage> {
  late Future<List<CameraDescription>> _camerasFuture;

  @override
  void initState() {
    super.initState();
    _camerasFuture = availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<CameraDescription>>(
          future: _camerasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    // App Logo and Welcome Text
                    SizedBox(
                      height: 80,
                      child: Image.asset('assets/images/BareLogo.png'),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 15.0), // specify the top margin
                      child: Text(
                        'Receive Message',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // Camera Preview
                    Container(
                      height: MediaQuery.of(context).size.height *
                          0.52, // adjust this to fit your needs
                      width: MediaQuery.of(context).size.width *
                          0.9, // adjust this to fit your needs
                      child: CameraPreviewWidget(
                        camera: snapshot.data!.first,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Text Field
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      margin: EdgeInsets.only(
                          top: 15, bottom: 20,left: 20, right: 20), // Adjust margins as needed
                      decoration: BoxDecoration(
                        color: Color.fromARGB(227, 255, 255,
                            255), // Background color of the text box
                        borderRadius: BorderRadius.circular(
                            10.0), // Border radius of the text box
                      ),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 15.0
                        ),
                        maxLines:
                            null, // Set the number of lines for the text box
                        decoration: InputDecoration(
                          hintText:
                              'View your message here...', // Placeholder text
                          hintStyle: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                              color:
                                  const Color.fromARGB(222, 158, 158, 158)), // Style for the placeholder text
                          border: InputBorder
                              .none, // Remove the default underline border
                          contentPadding:
                              EdgeInsets.all(10.0), // Padding inside the text box
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
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

      _startReceiving();

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

      print("Received binary: $_receivedBinary");

      if (_isFlashlightOn(_convertToGrayscale(image))) {

        if (!_transmissionActive) {

          // If the transmission is not active, check for the start signal
          _receivedBinary += '1';

          // if (_receivedBinary.endsWith(Transmitter.startString)) {

          //   _transmissionActive = true; // Transmission starts
          //   _receivedBinary = "";
          // }
        } 
        else {
          _receivedBinary += '1';
        }
      } 
      else {

        _receivedBinary += '0';

        if (_transmissionActive && _receivedBinary.endsWith(Transmitter.endString)) {

          _stopReceiving();
          return;
        }
      }
    });
  }

  void _stopReceiving() {

    if (!_isReceiving) return;

    _cameraController.stopImageStream();

    setState(() {
      _isReceiving = false;
      _transmissionActive = false;
    });

    // Remove start and end strings, if present
    var receivedBinaryWithoutMarkers = _receivedBinary.replaceAll(Transmitter.startString, '');
    receivedBinaryWithoutMarkers = receivedBinaryWithoutMarkers.replaceAll(Transmitter.endString, '');

    print("Received binary: $_receivedBinary");

    dispose(); // Stop the camera
  }

  img.Image _convertToGrayscale(CameraImage cameraImage) {

    // Convert CameraImage to a usable format (like YUV to RGB)
    final img.Image image = img.Image.fromBytes(
      width: cameraImage.width,
      height: cameraImage.height,
      bytes: cameraImage.planes[0].bytes.buffer,
      format: img.Format.uint8 // You might need to adjust the format
    );

    // Convert the image to grayscale
    return img.grayscale(image);
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
          
          if (++bright_pixel_count > total_pixel_count * PIXEL_COUNT_RATIO_THRESHOLD) {
            return true; // Flashlight detected
          }
        }
      }
    }
    
    return false; // Flashlight not detected
  }

  @override
  Widget build(BuildContext context) {

    if (!_cameraController.value.isInitialized) {
      return Container();
    }
    
    return AspectRatio(
      aspectRatio: _cameraController.value.aspectRatio,
      child: CameraPreview(_cameraController),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
