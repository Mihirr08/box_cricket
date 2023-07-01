import 'package:box_cricket/base_widgets/base_button.dart';
import 'package:box_cricket/constants/asset_constants.dart';
import 'package:box_cricket/constants/route_constants.dart';
import 'package:box_cricket/modules/user_login/logic/user_cubit.dart';
import 'package:box_cricket/modules/user_login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../base_widgets/base_text_field.dart';
import '../../constants/validations.dart';

class ProviderSignIn extends StatefulWidget {
  const ProviderSignIn({Key? key}) : super(key: key);

  @override
  _ProviderSignInState createState() => _ProviderSignInState();
}

class _ProviderSignInState extends State<ProviderSignIn> {
  late TextEditingController _controller;

  late GlobalKey<FormState> _formKey;

  late UserAuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _authCubit = UserAuthCubit();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: BlocBuilder(
                  bloc: _authCubit,
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            AssetConstants.signIn,
                          ),
                        ),
                        _phoneTextField(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: BaseButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _authCubit.isOwnerRegistered(_controller.text);
                              }
                            },
                            text: "Login",
                            width: double.infinity,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Text("Forgot Password"))
                          ],
                        ),
                        CreateAccountButton(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteConstants.providerSignUpPage);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          )
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
}
