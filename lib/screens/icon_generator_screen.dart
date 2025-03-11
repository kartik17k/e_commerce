import 'package:flutter/material.dart';
import '../widgets/app_icon_generator.dart';

class IconGeneratorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AppIconGenerator(),
      ),
    );
  }
}
