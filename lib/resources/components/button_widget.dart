import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  void Function()? onPress;
  final String title;
  ButtonWidget({super.key, required this.title, this.onPress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
