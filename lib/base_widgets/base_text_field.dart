import 'package:box_cricket/constants/textstyle_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseTextField extends StatelessWidget {
  const BaseTextField(
      {Key? key,
      this.isOutlined = true,
      this.hintText,
      this.labelText,
      this.hintStyle,
      this.labelStyle,
      this.prefixIcon,
      this.suffixIcon,
      this.keyboardType,
      this.validator,
      this.inputFormatters,
      this.maxLen,
      this.icon,
      required this.controller,
      this.contentPadding,
      this.outlineRadius,
      this.borderColor,
      this.isEnabled,
      this.onChange,
      this.minLines,
      this.maxLines})
      : super(key: key);

  final bool isOutlined;
  final String? hintText;
  final String? labelText;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final Widget? prefixIcon;
  final Widget? icon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLen;
  final int? minLines;
  final int? maxLines;
  final TextEditingController controller;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? outlineRadius;
  final Color? borderColor;
  final bool? isEnabled;
  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      controller: controller,
      minLines: minLines,
      maxLines: maxLines ?? 1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      style: (isEnabled == false)
          ? TextStyleConstants.disableTextFieldStyle
          : TextStyleConstants.textFieldStyle,
      keyboardType: keyboardType,
      cursorColor: Theme.of(context).primaryColor,
      maxLength: maxLen,
      inputFormatters: inputFormatters,
      enabled: isEnabled,
      decoration: InputDecoration(
          counterText: "",
          contentPadding: contentPadding,
          border: (isOutlined)
              ? _outlinedInputBorder(
                  color: borderColor,
                  context: context,
                )
              : _underLinedInputBorder(
                  color: borderColor,
                  context: context,
                ),
          hintText: hintText,
          labelText: labelText,
          icon: icon,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintStyle: (isEnabled == false && labelStyle != null)
              ? hintStyle!.copyWith(color: Colors.grey)
              : hintStyle,
          labelStyle: (isEnabled == false && hintStyle != null)
              ? labelStyle!.copyWith(color: Colors.grey)
              : labelStyle,
          focusedBorder: _getCurrentBorder(context),
          enabledBorder: _getCurrentBorder(context)),
    );
  }

  InputBorder _getCurrentBorder(BuildContext context) {
    return (isOutlined)
        ? _outlinedInputBorder(context: context, color: borderColor)
        : _underLinedInputBorder(context: context, color: borderColor);
  }

  InputBorder _outlinedInputBorder(
      {Color? color, required BuildContext context}) {
    return OutlineInputBorder(
        borderRadius: outlineRadius ??
            const BorderRadius.all(
              Radius.circular(20),
            ),
        borderSide: BorderSide(color: color ?? Theme.of(context).primaryColor));
  }

  InputBorder _underLinedInputBorder(
      {Color? color, required BuildContext context}) {
    return UnderlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(color: color ?? Theme.of(context).primaryColor));
  }
}
