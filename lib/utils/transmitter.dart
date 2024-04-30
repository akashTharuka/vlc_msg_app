import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:torch_light/torch_light.dart';


class Transmitter {

  static String startString = '01111110';
  static String endString = '01100000';

  static bool startTransmission () {

    // transmit(startString);
    return true;
  }
  
  static void transmit(String binaryString, Function(double) onProgressUpdate) async {
    for (int i = 0; i < binaryString.length; i++) {
      if (binaryString[i] == '1') {
        await TorchLight.enableTorch();
      } 
      else {
        await TorchLight.disableTorch();
      }

      // await Future.delayed(const Duration(milliseconds: 200)); 

      double progress = (i + 1) / binaryString.length;
      onProgressUpdate(progress);
    }
    
    await TorchLight.disableTorch(); 
  }

  static bool endTransmission () {

    // transmit(endString);
    return true;
  }
}