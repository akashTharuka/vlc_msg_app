import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      FutureBuilder<List<CameraDescription>>(
        future: _camerasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  appBar(context),
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
    ]);
    // );
  }
}

class CameraPreviewWidget extends StatefulWidget {
  final CameraDescription camera;

  const CameraPreviewWidget({
    super.key,
    required this.camera,
  });

  @override
  _CameraPreviewWidgetState createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: CameraPreview(_controller),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
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
