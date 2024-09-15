import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final IconData prefixIcon;
  final String hintText;
  bool isObscure;
  final bool isPasswordField;
  final TextEditingController controller;
  CustomTextField({super.key , required this.prefixIcon , required this.hintText ,required this.isObscure  , required this.controller , required this.isPasswordField});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style:GoogleFonts.nunito(
        fontWeight: FontWeight.w600
      ),
      obscureText: widget.isObscure,
      cursorColor: Colors.grey,
      cursorHeight: 15,
      cursorOpacityAnimates: true,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.prefixIcon,
          color: Colors.grey,
        ),
        hintText: widget.hintText,
        suffixIconColor: Colors.grey,
        suffixIcon:widget.isPasswordField ? IconButton(onPressed: (){
          setState(() {
            widget.isObscure = !widget.isObscure;
          });
        }, icon:const Icon(Icons.remove_red_eye_rounded)): null,
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
