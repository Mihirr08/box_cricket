import 'package:box_cricket/constants/color_constants.dart';
import 'package:flutter/material.dart';

SnackBar baseSnackBar({required String text, Color? color}) {
  return SnackBar(
    content: Text(text),
    behavior: SnackBarBehavior.floating,
    backgroundColor: color ?? ColorConstants.primaryColor,
  );
}
