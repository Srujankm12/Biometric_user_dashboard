import 'package:application/core/themes/themes.dart';
import 'package:application/generated_routes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentsDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentsDirectory.path);
  final box = await Hive.openBox('authtoken');
  runApp(MyApp(token: box.get('token')));
  await box.close();
}


class MyApp extends StatelessWidget {
  final dynamic token;
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.onGenerate,
      initialRoute: (token != null) ? "/home" : "/login",
      theme: AppTheme.appTheme,
      title: "Vsense Biometrics",
    );
  }
}