import 'package:box_cricket/modules/cricket_box/box_register.dart';
import 'package:box_cricket/modules/home/home_page.dart';
import 'package:box_cricket/modules/user_login/login_page.dart';
import 'package:box_cricket/modules/owner/provider_sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/OwnerRegistrationModel.dart';
import '../modules/cricket_box/box_detail_screen.dart';

class RouteConstants {
  static const loginPage = "/";
  static const providerSignUpPage = "/providerSignUp";
  static const register = "register";
  static const homePage = "/homePage";
  static const boxDetailScreen = "/boxDetailScreen";
  static const boxRegistration = "/BoxRegister";

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Widget page = const SizedBox();
    switch (settings.name) {
      case loginPage:
        page = const LoginPage(
          isRegister: false,
        );
        break;
      case providerSignUpPage:
        page = const ProviderSignUp();
        break;
      case register:
        page = const LoginPage(
          isRegister: true,
        );
        break;
      case homePage:
        page = const HomePage();
        break;
      case boxDetailScreen:
        Map<String, dynamic> detailMap =
            settings.arguments as Map<String, dynamic>;
        page = BoxDetailScreen(
          indicatorIndex: detailMap["indicatorIndex"],
        );
        break;
      case boxRegistration:
        OwnerRegistrationModel model =
            settings.arguments as OwnerRegistrationModel;
        page = BoxRegister(
          ownerRegistrationModel: model,
        );
        break;
    }
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
