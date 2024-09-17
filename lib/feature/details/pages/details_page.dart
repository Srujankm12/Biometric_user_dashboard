import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class StudentDetails extends StatefulWidget {
  final String data;
  const StudentDetails({super.key , required this.data});

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(
          "Student Details",
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
        padding: const EdgeInsets.all(40),
        margin: const EdgeInsets.only(top: 2),
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
      ),
    );
  }
}