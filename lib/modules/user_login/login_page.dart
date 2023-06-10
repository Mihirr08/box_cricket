import 'package:box_cricket/authentication/google_button.dart';
import 'package:box_cricket/base_widgets/base_button.dart';
import 'package:box_cricket/base_widgets/base_hero_widget.dart';
import 'package:box_cricket/base_widgets/base_text_field.dart';
import 'package:box_cricket/constants/asset_constants.dart';
import 'package:box_cricket/constants/route_constants.dart';
import 'package:box_cricket/constants/validations.dart';
import 'package:box_cricket/modules/user_login/logic/user_cubit.dart';
import 'package:box_cricket/modules/user_login/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.isRegister}) : super(key: key);
  final bool isRegister;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late UserAuthCubit _authCubit;

  late TextEditingController _controller;
  late TextEditingController _nameController;
  late GlobalKey<FormState> _formKey;
  bool _isGoogle = false;

  @override
  void initState() {
    super.initState();
    _authCubit = UserAuthCubit();
    _controller = TextEditingController();
    _nameController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    _authCubit.close();
    _controller.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const ScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            fillOverscroll: false,
            child: BlocConsumer(
              bloc: _authCubit,
              listener: (context, state) {
                if (state is UserSignedIn) {
                  if (state.user != null) {
                    print("User is ${state.user?.displayName}");
                    Navigator.pushNamedAndRemoveUntil(
                        context, RouteConstants.homePage, (route) => false);
                  }
                } else if (state is OtpSent) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return VerifyOtpScreen(
                      phoneNumber: _controller.text,
                      verificationId: state.verificationId,
                      resendToken: state.resendToken,
                    );
                  }));
                } else if (state is UserSignInFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.error,
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is UserSigningIn) {
                  return Center(
                    child:
                        Lottie.asset(AssetConstants.googleLoading, height: 100),
                  );
                } else if (state is OtpLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!widget.isRegister) const SizedBox(height: 50),
                          if (widget.isRegister &&
                              Navigator.of(context).canPop())
                            Padding(
                              padding: const EdgeInsets.only(top: 45.0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "< Sign-in",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 22.0),
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: BaseHeroWidget(
                                  tag: "logoImage",
                                  child: Image.asset(
                                    AssetConstants.pngLogoImage,
                                  ),
                                )),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BaseHeroWidget(
                                tag: 'googleButton',
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: GoogleButton(
                                      onTap: () {
                                        _isGoogle = true;
                                        _authCubit.googleSignIn();
                                      },
                                      width: double.infinity,
                                      text: "Continue with google"),
                                ),
                              ),
                              const OrWidget(),
                              _phoneTextField(),
                              if (widget.isRegister) _userNameField(),
                              _getLoginButton(),
                            ],
                          ),
                          if (!widget.isRegister)
                            CreateAccountButton(onTap: () {
                              Navigator.pushNamed(
                                  context, RouteConstants.register);
                            }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _phoneTextField() {
    return BaseTextField(
      controller: _controller,
      maxLen: 10,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("^[0-9]+"))],
      labelText: "Phone Number",
      keyboardType: TextInputType.number,
      validator: Validations().phoneNumberValidation,
    );
  }

  Widget _userNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: BaseTextField(
        controller: _nameController,
        labelText: "What should we call you?",
        validator: Validations().username,
      ),
    );
  }

  Widget _getLoginButton() {
    return BaseHeroWidget(
      tag: "loginButton",
      child: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: BaseButton(
            onTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                _authCubit.sendPhoneOtp(_controller.text);
              }
            },
            width: double.infinity,
            text: widget.isRegister ? "Register" : "Login"),
      ),
    );
  }
}

class OrWidget extends StatelessWidget {
  const OrWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "OR",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({Key? key, required this.onTap}) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(fontSize: 16),
        ),
        TextButton(
            onPressed: onTap,
            child: const Text(
              'Let\'s Create one',
              style: TextStyle(fontSize: 16),
            )),
      ],
    );
  }
}
