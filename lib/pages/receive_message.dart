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
