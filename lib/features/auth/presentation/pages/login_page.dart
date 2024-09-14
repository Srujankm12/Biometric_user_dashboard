import 'package:application/core/common/custom_text_field.dart';
import 'package:application/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
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
  }
}
