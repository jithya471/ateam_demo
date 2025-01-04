import 'package:ateam_demo/app/utils/colors.dart';
import 'package:ateam_demo/app/utils/styles.dart';
import 'package:flutter/material.dart';

class TextFields extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onSubmitted;

  const TextFields({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.onSubmitted,
  });

  @override
  State<TextFields> createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: TextFormField(
            style: style(14, FontWeight.w400, Appcolors.blackcolor),
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            onFieldSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              fillColor: Appcolors.whitecolor,
              filled: true,
              isDense: true,
              contentPadding:
                  const EdgeInsets.only(top: 18.0, right: 10.0, left: 10.0),
              hintText: widget.hintText,
              hintStyle: style(14.0, FontWeight.w400, Appcolors.lightGrey),
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Appcolors.textfieldBorder, width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Appcolors.textfieldBorder,
                  width: 1.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Appcolors.textfieldBorder,
                  width: 1.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
