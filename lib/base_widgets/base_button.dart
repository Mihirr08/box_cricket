import 'package:box_cricket/constants/color_constants.dart';
import 'package:box_cricket/constants/textstyle_constants.dart';
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  const BaseButton(
      {Key? key,
      this.height,
      this.width,
      this.icon,
      required this.onTap,
      required this.text,
      this.color,
      this.isOutlined, this.radius, this.trailingIcon})
      : super(key: key);
  final double? height;
  final double? width;
  final Widget? icon;
  final Function() onTap;
  final String text;
  final Color? color;
  final bool? isOutlined;
  final double? radius;
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius ?? 20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: (isOutlined == true)
                ? null
                : color ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(radius ?? 20),
            border: Border.all(color: ColorConstants.primaryColor)),
        // height: height ?? 80,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) icon!,
                Text(
                  text,
                  style: (isOutlined == true)
                      ? TextStyleConstants.buttonTextPrimary
                      : TextStyleConstants.buttonTextWhite,
                ),
                if (trailingIcon != null) trailingIcon!,
              ]),
        ),
      ),
    );
  }
}
