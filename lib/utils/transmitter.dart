import 'package:torch_light/torch_light.dart';


class Transmitter {
  
  static void transmit(String binaryString) async {

    for (int i = 0; i < binaryString.length; i++) {

      if (binaryString[i] == '1') {
        await TorchLight.enableTorch();
      } 
      else {
        await TorchLight.disableTorch();
      }

      await Future.delayed(const Duration(milliseconds: 200)); 
    }
    
    await TorchLight.disableTorch(); 
  }
}