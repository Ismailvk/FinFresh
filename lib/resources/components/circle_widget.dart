import 'dart:io';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CircleWidget extends StatelessWidget {
  String imagePath;
  CircleWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
