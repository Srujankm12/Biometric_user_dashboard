import 'package:application/core/custom_widgets/custom_dropdown.dart';
import 'package:application/core/themes/colors.dart';
import 'package:application/feature/register/bloc/register_bloc.dart';
import 'package:application/feature/register/widgets/fingerprint_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application/core/custom_widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  String dropDownValue = "Hello"; // Ensure this matches one of the item values

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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.fingerprint,
                      size: 100,
                    ),
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
                    CustomDropDownMenu(
                      data: [
                        "hello",
                        "hii",
                      ],
                      onPressed: (){

                      },
                    ),
                    CustomDropDownMenu(
                      data: [
                        "hello",
                        "hii",
                      ],
                      onPressed: (){

                      },
                    ),
                    CustomDropDownMenu(
                      data: [
                        "COM3",
                        "COM4",
                      ],
                      onPressed: (){
                        
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<RegisterBloc>(context).add(
                            RegisterStudentEvent(studentName: "", studentUSN: "", studentDepartment: "", studentUnitId: "", unitID: "")
                          );
                          setState(() {
                            CustomFingerprintDialog.dialog(context);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          "Take Fingerprint",
                          style: GoogleFonts.nunito(
                            color: AppColors.whiteColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
