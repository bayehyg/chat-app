import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget body;

  const CustomBackground({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/portrait-dark.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          body,
        ],
      ),
    );
  }
}
