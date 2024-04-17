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
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive Message'),
      ),
      body: FutureBuilder<List<CameraDescription>>(
        future: _camerasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // App Logo and Welcome Text
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Image.asset('assets/BareLogo.png'),
                  ),
                  const Text(
                    'Welcome to the VLC Message App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Camera Preview
                  Container(
                    height: 300, // adjust this to fit your needs
                    width: double.infinity,
                    child: CameraPreviewWidget(
                      camera: snapshot.data!.first,
                    ),
                  ),
                  // Text Field
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your message',
                        border: OutlineInputBorder(),
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