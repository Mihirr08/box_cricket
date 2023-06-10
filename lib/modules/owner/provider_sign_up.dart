import 'dart:io';

import 'package:box_cricket/base_widgets/base_button.dart';
import 'package:box_cricket/base_widgets/base_snackbar.dart';
import 'package:box_cricket/base_widgets/base_text_field.dart';
import 'package:box_cricket/constants/asset_constants.dart';
import 'package:box_cricket/constants/color_constants.dart';
import 'package:box_cricket/constants/validations.dart';
import 'package:box_cricket/modules/cricket_box/box_register.dart';
import 'package:box_cricket/modules/owner/logic/image_cubit.dart';
import 'package:box_cricket/modules/user_login/logic/user_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class ProviderSignUp extends StatefulWidget {
  const ProviderSignUp({Key? key}) : super(key: key);

  @override
  _ProviderSignUpState createState() => _ProviderSignUpState();
}

class _ProviderSignUpState extends State<ProviderSignUp> {
  late ImageCubit _providerCubit;

  late List<XFile> _fileImages;

  late TextEditingController _ownerNameController;
  late TextEditingController _gmailController;
  late TextEditingController _otpController;
  late TextEditingController _phoneNumberController;

  late UserAuthCubit _authCubit;

  bool _isVerifying = false;

  String? _verificationId;

  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _providerCubit = ImageCubit();
    _fileImages = <XFile>[];
    _gmailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _ownerNameController = TextEditingController();
    _otpController = TextEditingController();
    _authCubit = UserAuthCubit();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    _providerCubit.close();
    _gmailController.dispose();
    _phoneNumberController.dispose();
    _ownerNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Form(
              key: _formKey,
              child: BlocConsumer(
                bloc: _authCubit,
                listener: (context, state) {
                  print("State is $state");
                  if (state is OtpSent) {
                    _verificationId = state.verificationId;
                    ScaffoldMessenger.of(context).showSnackBar(baseSnackBar(
                        text: "OTP sent to +91${_phoneNumberController.text}"));
                    setState(() {
                      _isVerifying = true;
                    });
                  } else if (state is OtpFailed) {
                    print("State error is ${state.error}");
                    ScaffoldMessenger.of(context)
                        .showSnackBar(baseSnackBar(text: state.error));
                  }
                },
                builder: (context, state) {
                  if (state is OtpLoading) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sending OTP......",style: TextStyle(fontSize: 18),),
                      Lottie.asset(AssetConstants.otpLoading, height: 200),
                    ],
                  );
                  }
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Column(
                            children: [
                              Expanded(
                                  child: Image.asset(
                                      AssetConstants.checkListImage)),
                              const Center(
                                child: Text(
                                  "Owner Registration",
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          decoration: const BoxDecoration(
                              // color: ColorConstants.primaryColor,
                              borderRadius: BorderRadius.only(
                            topRight: Radius.circular(18),
                            topLeft: Radius.circular(18),
                          )),
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(children: [
                                _getTextField(
                                    isEnabled: !_isVerifying,
                                    validator: Validations().username,
                                    hintText: "Owner Name",
                                    controller: _ownerNameController,
                                    leadingIcon: Icon(
                                      Icons.person,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                _getTextField(
                                    validator: Validations().gmail,
                                    isEnabled: !_isVerifying,
                                    controller: _gmailController,
                                    hintText: "Gmail",
                                    leadingIcon: Icon(
                                      Icons.mail,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                StatefulBuilder(builder: (context, sst) {
                                  return Stack(
                                    children: [
                                      _getTextField(
                                        maxLen: 10,
                                        onChange: (_) {
                                          sst(() {});
                                        },
                                        keyboardType: TextInputType.number,
                                        isEnabled: !_isVerifying,
                                        hintText: "Phone Number",
                                        validator:
                                            Validations().phoneNumberValidation,
                                        controller: _phoneNumberController,
                                        leadingIcon: Icon(
                                          Icons.phone,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        top: 14,
                                        child: TextButton(
                                          onPressed: _phoneNumberController
                                                  .text.isEmpty
                                              ? () {
                                                  _formKey.currentState!
                                                      .validate();
                                                }
                                              : () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    print(
                                                        "Verify is $_isVerifying");
                                                    if (!_isVerifying) {
                                                      _otpController.clear();
                                                      if (_phoneNumberController
                                                          .text.isNotEmpty) {
                                                        _authCubit.sendPhoneOtp(
                                                            _phoneNumberController
                                                                .text);
                                                      }
                                                    } else {
                                                      _isVerifying = false;
                                                    }
                                                    setState(() {});
                                                  }
                                                },
                                          child: Text(
                                            !_isVerifying ? "Verify" : "Edit",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: ColorConstants
                                                    .primaryColor),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                              ]),
                              if (_isVerifying)
                                BaseTextField(
                                  isEnabled: state is! OtpVerified,
                                  controller: _otpController,
                                  maxLen: 6,
                                  keyboardType: TextInputType.number,
                                  hintText: "Enter otp here",
                                  suffixIcon: TextButton(
                                      onPressed: () {
                                        if (_otpController.text.length == 6) {
                                          _authCubit.verifyOtp(
                                              verificationId:
                                                  _verificationId ?? "",
                                              code: _otpController.text);
                                        }
                                      },
                                      child: (state is OtpVerified)
                                          ? const Icon(
                                              Icons.verified,
                                              color:
                                                  ColorConstants.primaryColor,
                                            )
                                          : const Text("Verify otp")),
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18.0),
                                child: BaseButton(
                                    color:
                                        ((state is OtpVerified) && _isVerifying)
                                            ? ColorConstants.primaryColor
                                            : Colors.grey,
                                    onTap: ((state is OtpVerified) &&
                                            _isVerifying)
                                        ? () {}
                                        : () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Please verify phone number to continue"),
                                              backgroundColor:
                                                  ColorConstants.primaryColor,
                                            ));
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const BoxRegister()));
                                          },
                                    text: "Next",
                                    width: double.infinity),
                              )
                            ],
                          ),
                        ))
                      ]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _chooseImageFromDialog() {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Choose image from:",
                            style: TextStyle(fontSize: 22)),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BaseButton(
                              onTap: () {
                                _providerCubit.pickImage();
                              },
                              text: "Gallery"),
                        ),
                        BaseButton(
                            onTap: () {
                              _providerCubit.cameraImage();
                            },
                            text: "Camera"),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _getTextField(
      {required String hintText,
      bool? isEnabled,
      Widget? leadingIcon,
      required TextEditingController controller,
      String? Function(String?)? validator,
      TextInputType? keyboardType,
      void Function(String)? onChange,
      int? maxLen,
      Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: BaseTextField(
        controller: controller,
        maxLen: maxLen,
        onChange: onChange,
        keyboardType: keyboardType,
        validator: validator,
        isEnabled: isEnabled,
        hintText: hintText,
        prefixIcon: leadingIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class AddImageWidget extends StatelessWidget {
  const AddImageWidget({Key? key, required this.onTap}) : super(key: key);
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.add_a_photo, color: Colors.white, size: 30),
      ),
    );
  }
}
