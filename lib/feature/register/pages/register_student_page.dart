import 'package:application/core/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(
          "Register Student",
          style: GoogleFonts.nunito(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey.shade900,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 500,
            height: 600,
            child: Card(
              elevation: 8,
              color: Colors.white,
              child: Column(
                children: [
                  CustomTextField(
                    prefixIcon: Icons.person,
                    hintText: "Name",
                    isObscure: false,
                    controller: _nameController,
                    isPasswordField: false,
                  ),
                  CustomTextField(
                    prefixIcon: Icons.numbers,
                    hintText: "USN",
                    isObscure: false,
                    controller: _nameController,
                    isPasswordField: false,
                  ),
                  CustomTextField(
                    prefixIcon: Icons.book,
                    hintText: "Department",
                    isObscure: false,
                    controller: _nameController,
                    isPasswordField: false,
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
