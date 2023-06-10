import 'package:box_cricket/constants/asset_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton(
      {Key? key, required this.onTap, this.width, required this.text})
      : super(key: key);

  final Function() onTap;
  final double? width;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: width,
        // padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              AssetConstants.googleLottieImage,
              height: 60,
              repeat: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                text,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
