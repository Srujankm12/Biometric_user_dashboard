import 'package:application/core/custom_widgets/custom_dropdown.dart';
import 'package:application/core/custom_widgets/custom_text_field.dart';
import 'package:application/feature/register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usnController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();

  String unitId = "";
  String studentUnitId = "";
  String port = "";

  @override
  void initState() {
    BlocProvider.of<RegisterBloc>(context).add(
      FetchFingerprintMachinesEvent(),
    );
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 20,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _nameController.dispose();
    _usnController.dispose();
    _branchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is VerifyDetailsFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
            ),
          );
          BlocProvider.of<RegisterBloc>(context).add(
            FetchFingerprintMachinePortEvent(),
          );
        }
        if (state is RegisterStudentAccnoledgementState) {
          setState(() {
            _controller.value = state.animationValue;
          });
        }
        if (state is VerifyDetailsSuccessState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return BlocProvider(
                create: (context) => RegisterBloc(),
                child: BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        state is RegisterStudentAccnoledgementState
                            ? state.message
                            : "Loading...",
                      ),
                      content: state is RegisterStudentAccnoledgementState
                          ? state.status == 0
                              ? Lottie.asset(
                                  "assets/Animation.json",
                                  controller: _controller,
                                )
                              : state.status == 1
                                  ? Lottie.asset("assets/success.json")
                                  : state.status == 2
                                      ? Lottie.asset("assets/failure.json")
                                      : null
                          : null,
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            
                          },
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.nunito(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.grey.shade900,
          title: Text(
            "Register Student",
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: SizedBox(
            width: 500,
            height: 600,
            child: Card(
              color: Colors.white,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    if (state is RegisterLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeCap: StrokeCap.round,
                        ),
                      );
                    } else if (state is RegisterStudentFailureState ||
                        state is FetchFingerprintMachineFailureState ||
                        state is FetchStudentUnitIdFailureState ||
                        state is FetchFingerprintMachinePortFailureState) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              size: 60,
                            ),
                            Text(
                              state is RegisterStudentFailureState
                                  ? state.errorMessage
                                  : state is FetchFingerprintMachineFailureState
                                      ? state.errorMessage
                                      : state is FetchStudentUnitIdFailureState
                                          ? state.errorMessage
                                          : state is FetchFingerprintMachinePortFailureState
                                              ? state.errorMessage
                                              : "Something went wrong...",
                              style: GoogleFonts.nunito(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<RegisterBloc>(context).add(
                                  FetchFingerprintMachinesEvent(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              child: Text(
                                "Retry",
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(
                          Icons.fingerprint_rounded,
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
                          prefixIcon: Icons.abc,
                          hintText: "USN",
                          isObscure: false,
                          controller: _usnController,
                          isPasswordField: false,
                        ),
                        CustomTextField(
                          prefixIcon: Icons.apartment,
                          hintText: "Department",
                          isObscure: false,
                          controller: _branchController,
                          isPasswordField: false,
                        ),
                        BlocBuilder<RegisterBloc, RegisterState>(
                          builder: (context, state) {
                            if (state is FetchFingerprintMachineSuccessState) {
                              return CustomDropDownMenu(
                                data: state.data,
                                onChanged: (selected0) {
                                  unitId = selected0!;
                                  BlocProvider.of<RegisterBloc>(context).add(
                                    FetchStudentUnitIdEvent(
                                      unitId: unitId,
                                    ),
                                  );
                                },
                              );
                            }
                            return _containerText(unitId);
                          },
                        ),
                        BlocBuilder<RegisterBloc, RegisterState>(
                          builder: (context, state) {
                            if (state is FetchStudentUnitIdSuccessState) {
                              return CustomDropDownMenu(
                                data: state.data,
                                onChanged: (selected1) {
                                  studentUnitId = selected1!;
                                  BlocProvider.of<RegisterBloc>(context).add(
                                    FetchFingerprintMachinePortEvent(),
                                  );
                                },
                              );
                            }
                            return _containerText(studentUnitId);
                          },
                        ),
                        BlocBuilder<RegisterBloc, RegisterState>(
                          builder: (context, state) {
                            if (state
                                is FetchFingerprintMachinePortSuccessState) {
                              return CustomDropDownMenu(
                                data: state.data,
                                onChanged: (selected2) {
                                  port = selected2!;
                                  BlocProvider.of<RegisterBloc>(context).add(
                                    VerifyDetailsEvent(
                                      port: port,
                                      studentDepartment: _branchController.text,
                                      studentName: _nameController.text,
                                      studentUSN: _usnController.text,
                                      studentUnitId: studentUnitId,
                                      unitID: unitId,
                                    ),
                                  );
                                },
                              );
                            }
                            return _containerText(port);
                          },
                        ),
                      ],
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

  Widget _containerText(String text) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.nunito(
            color: Colors.grey.shade700,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
