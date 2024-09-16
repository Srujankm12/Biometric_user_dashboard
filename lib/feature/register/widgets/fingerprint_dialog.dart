import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


class CustomFingerprintDialog{
  static void dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text("Please Keep Your Finger On The Sensor" , style: GoogleFonts.varelaRound(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 22),),
          content: LottieBuilder.asset("assets/Animation.json" , width: 20,),
        );
      }
    );
  }
}