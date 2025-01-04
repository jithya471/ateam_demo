import 'package:ateam_demo/app/utils/colors.dart';
import 'package:ateam_demo/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.2,
      decoration: BoxDecoration(
        color: Appcolors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Appcolors.lightGrey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Row(
            children: [
              Container(
                width: Get.width * 0.15,
                height: Get.height * 0.1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Appcolors.whitecolor,
                ),
                child: Icon(
                  Icons.person,
                  color: Appcolors.primaryColor,
                  size: 50,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: horizontalPadding),
                child: RichText(
                  text: TextSpan(
                    text: 'Robert Doe\n',
                    style: TextStyle(
                      color: Appcolors.whitecolor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: 'robertdoe@gmail.com',
                        style: TextStyle(
                          color: Appcolors.whitecolor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
