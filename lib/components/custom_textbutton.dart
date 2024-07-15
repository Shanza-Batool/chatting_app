import 'package:flutter/material.dart';

class CustomTextbutton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;

  const CustomTextbutton(
      {super.key,
        required this.width,
        required this.text,
        required this.height,
        required this.backgroundColor,
        required this.foregroundColor,
        required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor),
          child: Text(text,style:const TextStyle(fontSize: 18),),
        ));
  }
}
