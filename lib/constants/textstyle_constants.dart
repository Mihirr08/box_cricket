import 'package:box_cricket/constants/color_constants.dart';
import 'package:flutter/material.dart';

class TextStyleConstants {
  static const textFieldStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  static const disableTextFieldStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  static const textFieldLabelStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF646464),
  );

  static const label =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);

  static const label20 =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);
  static const value =
      TextStyle(fontSize: 16, color: Colors.black);

  static const buttonTextWhite = TextStyle(fontSize: 18, color: Colors.white);
  static const buttonTextPrimary =
      TextStyle(fontSize: 18, color: ColorConstants.primaryColor);
}
