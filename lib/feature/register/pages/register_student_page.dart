import 'package:application/core/custom_widgets/custom_dropdown.dart';
import 'package:application/core/themes/colors.dart';
import 'package:application/feature/register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application/core/custom_widgets/custom_text_field.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  
  // Controllers related to specific widget
  late final AnimationController _controller;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usnController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  String unitId = "Select the unit";
  String studentUnitId = "Select any Number";
  String ports = "Select the Register Port";
  String header = "";

  // Initial function to execuite before build
  @override
  void initState() {
    BlocProvider.of<RegisterBloc>(context).add(FetchMachinesEvent());
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _branchController.dispose();
    _usnController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.err),
            ),
          );
          if (state.errTyp == 4) {
            BlocProvider.of<RegisterBloc>(context).add(FetchComPortsEvent());
          }
        } else if (state is RegisterAcknowledgmentState) {
          if (state.fingerprintstatus == 3) {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    title: Text(
                      "Fingerprint taken successfully",
                      style: GoogleFonts.varelaRound(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    content: LottieBuilder.asset(
                      "assets/success.json",
                      width: 20,
                      controller: _controller,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/register");
                        },
                        child:const Text(
                          "Done",
                        ),
                      ),
                    ],
                  );
                });
          }
          setState(() {
            _controller.value = state.fingerprintstatus;
            header = state.message;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: Text(
            "Register Student",
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
                child: BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    if (state is RegisterLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    }
                    return Padding(
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
                            controller: _usnController,
                            isPasswordField: false,
                          ),
                          CustomTextField(
                            prefixIcon: Icons.book,
                            hintText: "Department",
                            isObscure: false,
                            controller: _branchController,
                            isPasswordField: false,
                          ),
                          BlocBuilder<RegisterBloc, RegisterState>(
                            builder: (context, state) {
                              if (state is FetchMachinesSuccessState) {
                                return CustomDropDownMenu(
                                  data: state.data,
                                  onChanged: (p0) {
                                    unitId = p0!;
                                    BlocProvider.of<RegisterBloc>(context).add(
                                      FetchStudentUnitIdEvent(unitID: unitId),
                                    );
                                  },
                                );
                              }
                              return Container(
                                width: 500,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade200,
                                ),
                                child: Center(
                                  child: Text(
                                    unitId,
                                    style: GoogleFonts.nunito(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
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
                                    BlocProvider.of<RegisterBloc>(context).add(
                                      FetchComPortsEvent(),
                                    );
                                  },
                                );
                              }
                              return Container(
                                width: 500,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade200,
                                ),
                                child: Center(
                                  child: Text(
                                    studentUnitId,
                                    style: GoogleFonts.nunito(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          BlocBuilder<RegisterBloc, RegisterState>(
                            builder: (context, state) {
                              if (state is FetchAllPortsSuccessState) {
                                return CustomDropDownMenu(
                                  data: state.data,
                                  onChanged: (p0) {
                                    ports = p0!;
                                    BlocProvider.of<RegisterBloc>(context).add(
                                      ComPortSelectEvent(
                                        studentName: _nameController.text,
                                        studentUsn: _usnController.text,
                                        studentBranch: _branchController.text,
                                      ),
                                    );
                                  },
                                );
                              }
                              return Container(
                                width: 500,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade200,
                                ),
                                child: Center(
                                  child: Text(
                                    ports,
                                    style: GoogleFonts.nunito(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          BlocBuilder<RegisterBloc, RegisterState>(
                            builder: (context, state) {
                              if (state is ComPortSelectedState) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              surfaceTintColor: Colors.white,
                                              title: Text(
                                                header,
                                                style: GoogleFonts.varelaRound(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22),
                                              ),
                                              content: LottieBuilder.asset(
                                                "assets/Animation.json",
                                                width: 20,
                                                controller: _controller,
                                              ),
                                            );
                                          });
                                      BlocProvider.of<RegisterBloc>(context)
                                          .add(
                                        RegisterStudentEvent(
                                          studentName: _nameController.text,
                                          studentUSN: _usnController.text,
                                          studentDepartment:
                                              _branchController.text,
                                          studentUnitId: studentUnitId,
                                          unitID: unitId,
                                          fingerprint: "",
                                          port: ports,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
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
                                );
                              }
                              return Container(
                                width: double.infinity,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade500,
                                ),
                                child: Center(
                                  child: Text(
                                    "Take Fingerprint",
                                    style: GoogleFonts.nunito(
                                      color: Colors.grey.shade100,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
