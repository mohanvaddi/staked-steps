import 'package:flutter/material.dart';
import 'package:staked_steps/Login.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Web3ModalTheme(
        isDarkMode: false,
        themeData: Web3ModalThemeData(
          lightColors: Web3ModalColors.lightMode.copyWith(
            accent100: (Colors.green[300])!,
            background125: (Colors.green[100])!,
            foreground100: Colors.black,
            background100: (Colors.black),
            inverse100: Colors.black54,
          ),
          darkColors: Web3ModalColors.darkMode.copyWith(
            accent100: (Colors.green[300])!,
            background125: (Colors.black87),
            foreground100: (Colors.green[400])!,
            background100: (Colors.green[400])!,
            inverse100: Colors.black54,
          ),
        ),
        child: MaterialApp(
          title: 'Staked Steps',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          // home: const Home(title: 'Staked Steps'),
          home: const Login(title: 'Staked Steps'),
        ));
  }
}
