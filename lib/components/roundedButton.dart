import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String title;
  final Function() onPress;
  const RoundedButton({
    super.key,
    required this.color,
    required this.title,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(10.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.09,
          child: Text(
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            title,
          ),
        ),
      ),
    );
  }
}
