// ignore_for_file: use_build_context_synchronously

import 'package:finfresh_test/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  final LocalAuthentication auth = LocalAuthentication();
  bool isAuthenticated = false;
  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    if (canAuthenticateWithBiometrics) {
      try {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to show Bank balance',
          options: const AuthenticationOptions(biometricOnly: false),
        );
        if (didAuthenticate) {
          loginCheck(context);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('FinFest'),
      ),
    );
  }

  loginCheck(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }
}
