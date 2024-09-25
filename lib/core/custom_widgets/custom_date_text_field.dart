import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final IconData prefixIcon;
  final String hintText;
  final VoidCallback onTap;
  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.onTap,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: widget.onTap,
      controller: widget.controller,
      style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
      obscureText: false,
      cursorColor: Colors.grey,
      cursorHeight: 15,
      cursorOpacityAnimates: true,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.prefixIcon,
          color: Colors.grey,
        ),
        hintText: widget.hintText,
        hintStyle:
            const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        hoverColor: Colors.transparent,
        filled: true,
        fillColor: Colors.grey.shade100,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: Colors.grey.shade100, style: BorderStyle.none)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: Colors.grey.shade100, style: BorderStyle.none)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: Colors.grey.shade100, style: BorderStyle.none)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.grey.shade100, style: BorderStyle.none),
        ),
      ),
    );
  }
}
