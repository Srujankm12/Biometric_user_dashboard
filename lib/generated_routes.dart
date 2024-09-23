import 'package:application/feature/details/bloc/details_bloc.dart';
import 'package:application/feature/download/pages/download_page.dart';
import 'package:application/feature/logs/bloc/logs_bloc.dart';
import 'package:application/feature/logs/pages/logs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application/feature/auth/bloc/auth_bloc.dart';
import 'package:application/feature/details/pages/details_page.dart';
import 'package:application/feature/home/bloc/home_bloc.dart';
import 'package:application/feature/home/pages/home_page.dart';
import 'package:application/feature/auth/pages/login_page.dart';
import 'package:application/feature/register/bloc/register_bloc.dart';
import 'package:application/feature/register/pages/register_student_page.dart';

class Routes {
  static Route? onGenerate(RouteSettings settings) {
    // Extract arguments if needed
    final args = settings.arguments;

    switch (settings.name) {
      case "/login":
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthBloc(),
            child: const LoginPage(),
          ),
        );
      case "/home":
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => HomeBloc(),
            child: const HomePage(),
          ),
        );
      case "/register":
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => RegisterBloc(),
            child: const RegisterPage(),
          ),
        );
      case "/details":
        // Check if arguments are passed
        if (args is DetailsArguments) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => DetailsBloc(),
              child: StudentDetails(data: args.unitId), // Pass arguments to the page
            ),
          );
        }
        case "/logs":
        // Check if arguments are passed
        if (args is LogsArguments) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => LogsBloc(),
              child: LogsPage(data: args.studentId , studentName: args.studentName , usn: args.studentUsn,), // Pass arguments to the page
            ),
          );
        }

        case "/download":
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
            create: (context) => AuthBloc(),
            child: const DownloadPage(),
          ),
        );
        // Handle invalid or missing arguments
    }
    return null;
  }
}