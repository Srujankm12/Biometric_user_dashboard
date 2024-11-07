import 'package:application/core/custom_widgets/custom_text_field.dart';
import 'package:application/core/themes/colors.dart';
import 'package:application/feature/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // Controllers To Read The Data From The User
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          Navigator.pushReplacementNamed(context, "/home");
        }
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SizedBox(
              width: 500,
              height: 550,
              child: Card(
                surfaceTintColor: AppColors.whiteColor,
                color: AppColors.whiteColor,
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 40, bottom: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 180,
                      ),
                      Text(
                        "Login",
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
                      ),
                      CustomTextField(
                        prefixIcon: Icons.person,
                        hintText: "Username",
                        controller: _usernameController,
                        isPasswordField: false,
                        isObscure: false,
                      ),
                      CustomTextField(
                        prefixIcon: Icons.lock,
                        hintText: "Password",
                        controller: _passwordController,
                        isPasswordField: true,
                        isObscure: true,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context).add(
                              AuthLoginEvent(
                                username: _usernameController.text,
                                password: _passwordController.text,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: state is AuthLoadingState
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeCap: StrokeCap.round,
                                )
                              : Text(
                                  "Login",
                                  style: GoogleFonts.nunito(
                                    color: AppColors.whiteColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
