import 'package:ateam_demo/app/utils/colors.dart';
import 'package:ateam_demo/app/utils/constants.dart';
import 'package:ateam_demo/app/utils/styles.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  const Button({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Appcolors.whitecolor,
          boxShadow: [
            BoxShadow(
              color: Appcolors.lightGrey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: verticalPadding, horizontal: horizontalPadding),
          child: Text(
            text,
            style: style(16, FontWeight.w600, Appcolors.primaryColor),
          ),
        ),
      ),
    );
  }
}
