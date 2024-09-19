import "package:application/core/custom_widgets/custom_text_field.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class CustomUpdateDialog {
  static void showCustomDialog(
      BuildContext context,
      VoidCallback onPressed,
      TextEditingController namecontroller,
      TextEditingController usncontroller,
      TextEditingController branchcontroller) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: SizedBox(
              width: 350,
              child: Text(
                "Update Student",
                style: GoogleFonts.varelaRound(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            content: SizedBox(
              width: 180,
              height: 170,
              child: Column(
                children: [
                  CustomTextField(
                    prefixIcon: Icons.person,
                    hintText: "Student Name",
                    isObscure: false,
                    controller: namecontroller,
                    isPasswordField: false,
                  ),
                  const SizedBox(height: 10,),
                  CustomTextField(
                    prefixIcon: Icons.numbers,
                    hintText: "Student USN",
                    isObscure: false,
                    controller: usncontroller,
                    isPasswordField: false,
                  ),
                  const SizedBox(height: 10,),
                  CustomTextField(
                    prefixIcon: Icons.book,
                    hintText: "Branch",
                    isObscure: false,
                    controller: branchcontroller,
                    isPasswordField: false,
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Update",
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.nunito(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }
}
