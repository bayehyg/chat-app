import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget body;

  CustomBackground({required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/background1.avif'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
              ),
            ),
          ),
          body,
        ],
      ),
    );
  }
}