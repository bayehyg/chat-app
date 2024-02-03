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
                  image: AssetImage('images/background.jpg'),
                  fit: BoxFit.cover,
              ),
            ),
          ),
          body,
        ],
      ),
    );
  }
}