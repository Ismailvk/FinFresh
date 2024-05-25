// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:finfresh_test/controller/bloc/todo_bloc.dart';
import 'package:finfresh_test/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isOnline = false;
  StreamSubscription? isOnlineConnected;

  @override
  void initState() {
    super.initState();
    isOnlineConnected = InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isOnline = true;
          });
          dataCheck(context);
          break;
        case InternetStatus.disconnected:
          setState(() {
            isOnline = false;
          });
          dataCheck(context);
          break;
        default:
          setState(() {
            isOnline = false;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is DataFetchSuccessState) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false);
          }
        },
        child: const Text('FinFest'),
      )),
    );
  }

  dataCheck(BuildContext context) {
    if (isOnline) {
      context.read<TodoBloc>().add(FetchDataSuccessEvent());
    } else {
      print('You are offline');
    }
  }
}
