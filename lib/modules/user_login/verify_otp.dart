import 'dart:async';

import 'package:box_cricket/base_widgets/base_button.dart';
import 'package:box_cricket/base_widgets/base_text_field.dart';
import 'package:box_cricket/constants/asset_constants.dart';
import 'package:box_cricket/constants/color_constants.dart';
import 'package:box_cricket/modules/user_login/logic/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../constants/route_constants.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen(
      {Key? key,
      required this.verificationId,
      this.resendToken,
      required this.phoneNumber})
      : super(key: key);

  final String verificationId;
  final String phoneNumber;
  final int? resendToken;

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late TextEditingController _controller;

  int? _resendTime;
  int? _totalResendTime;
  Timer? _timer;

  late UserAuthCubit _userAuthCubit;
  int? _resendToken;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int currentTime = (_totalResendTime ?? 0) - timer.tick;

      if(mounted) {
        setState(() {
          _resendTime = currentTime;
        });
      }

      if (currentTime == 0) {
        _timer?.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _userAuthCubit = UserAuthCubit();
    _totalResendTime = 60;
    _startTimer();
    _resendToken = widget.resendToken;
  }

  @override
  void dispose() {
    _userAuthCubit.close();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer(
        bloc: _userAuthCubit,
        listener: (context, state) {
          if (state is OtpVerified) {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteConstants.homePage, (route) => false);
          } else if (state is OtpFailed) {
            _startTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is OtpSent) {
            _resendToken = state.resendToken;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("OTP sent"),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
            _startTimer();
          }
        },
        builder: (context, state) {
          if (state is OtpLoading) {
            return Center(
              child: Lottie.asset(AssetConstants.otpLoading, height: 200),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Lottie.asset(
                        AssetConstants.otpVerification,
                        height: 200,
                        repeat: false,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _otpSent(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: BaseTextField(
                                maxLen: 6,
                                labelText: "Enter otp here",
                                keyboardType: TextInputType.number,
                                controller: _controller,
                              ),
                            ),
                            BlocBuilder(
                              bloc: _userAuthCubit,
                              builder: (context, state) {
                                return BaseButton(
                                    width: double.infinity,
                                    onTap: () {
                                      _userAuthCubit.verifyOtp(
                                          verificationId: widget.verificationId,
                                          code: _controller.text);
                                    },
                                    text: "Verify");
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: _resendTime == 0
                                        ? () {
                                            _userAuthCubit.sendPhoneOtp(
                                              widget.phoneNumber,
                                              resendToken: _resendToken,
                                            );
                                          }
                                        : null,
                                    child: Text(
                                      "Resend OTP",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: _resendTime == 0
                                            ? ColorConstants.primaryColor
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _resendTime == 0
                                        ? ""
                                        : "in $_resendTime seconds",
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _otpSent() {
    return RichText(
      text: TextSpan(
          text: "We have sent you an OTP on ",
          style: const TextStyle(fontSize: 15, color: Colors.black),
          children: [
            TextSpan(
              text: "+1${widget.phoneNumber}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ]),
    );
  }
}
