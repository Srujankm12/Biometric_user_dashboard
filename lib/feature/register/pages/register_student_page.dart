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
  String unitId = "";
  String studentUnitId = "";
  String ports = "";
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
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        if (state is FetchMachinesSuccessState) {
                          return CustomDropDownMenu(
                            data: state.data,
                            onChanged: (p0) {
                              unitId = p0!;
                            },
                          );
                        }
                        return Container(
                          width: 400,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200,
                          ),
                          child: Text(unitId),
                        );
                      },
                    ),
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        if (state is FetchStudentUnitIdSuccessState) {
                          return CustomDropDownMenu(
                            data: state.data,
                            onChanged: (p0) {
                              studentUnitId = p0!;
                            },
                          );
                        }
                        return Container(
                          width: 400,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200,
                          ),
                          child: Text(unitId),
                        );
                      },
                    ),
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        if(state is FetchAllPortsSuccessState){
                          return CustomDropDownMenu(
                          data: state.data,
                          onChanged: (p0) {
                            ports = p0!;
                          },
                        );
                        }
                        return Container(
                          width: 400,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200,
                          ),
                          child: Text(unitId),
                        );
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
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
