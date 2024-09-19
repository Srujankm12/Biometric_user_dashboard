import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";


class CustomDeleteDialog{
  static void showCustomDialog(BuildContext context , VoidCallback onPressed){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text("Delete Student" , style: GoogleFonts.varelaRound(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 22,),),
          content:const Text("Are you sure do you want to delete student.",),
          actions: [
            ElevatedButton(onPressed: onPressed,style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ), child: Text("Delete",style: GoogleFonts.nunito(color: Colors.white , fontWeight: FontWeight.bold),),),
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            },style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              side:const BorderSide(
                color: Colors.black
              ),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ), child: Text("Cancel",style: GoogleFonts.nunito(color: Colors.black , fontWeight: FontWeight.bold),),),
          ],
        );
    });
  }
}