import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  final String title;

  final String subTitle;
  final String hdrImg;

  const FormHeaderWidget(
      {super.key,
      required this.size,
      required this.hdrImg,
      required this.title,
      required this.subTitle,
      this.tCrossAxissAligment,
      this.tMainAxisAlignment,
      this.imgHeightFraction});

  final Size size;
  final CrossAxisAlignment? tCrossAxissAligment;
  final MainAxisAlignment? tMainAxisAlignment;
  final double? imgHeightFraction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: tCrossAxissAligment == null
          ? CrossAxisAlignment.center
          : tCrossAxissAligment!,
      mainAxisAlignment: tMainAxisAlignment == null
          ? MainAxisAlignment.start
          : tMainAxisAlignment!,
      children: [
        Icon(
          CupertinoIcons.person_crop_circle_fill_badge_checkmark,
          color: Colors.white,
          size: imgHeightFraction == null
              ? size.height * 0.2
              : size.height * imgHeightFraction!,
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          subTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
