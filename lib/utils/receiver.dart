import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class ReceiverScreen extends StatefulWidget {

  const ReceiverScreen({super.key});
  
  @override
  _ReceiverScreenState createState() => _ReceiverScreenState();
}

class _ReceiverScreenState extends State<ReceiverScreen> {

  late List<CameraDescription> cameras;
  late CameraController controller;
  bool isProcessing = false;

  @override
  void initState() async {

    super.initState();

    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {

      if (!mounted) {
        return;
      }

      controller.startImageStream((CameraImage image) {

        if (!isProcessing) {
          processImage(image);
        }
      });

      setState(() {});
    });
  }

  @override
  void dispose() {

    controller.dispose();
    super.dispose();
  }

  Future<void> processImage(CameraImage image) async {

    setState(() {
      isProcessing = true;
    });

    // Analyze brightness to detect binary signals
    int brightnessThreshold = 128;
    String binaryString = '';

    for (int i = 0; i < image.width; i += 10) {

      int pixelIndex = i * image.planes[0].bytesPerRow;
      int brightness = image.planes[0].bytes[pixelIndex];
      binaryString += (brightness > brightnessThreshold) ? '1' : '0';
    }

    print('Received Binary: $binaryString');

    setState(() {
      isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    if (!controller.value.isInitialized) {
      return Container();
    }
    // return Scaffold(
    //   body: Center(
    //     child: CameraPreview(controller),
    //   ),
    // );
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }
}


