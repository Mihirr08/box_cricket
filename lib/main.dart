import 'package:box_cricket/constants/color_constants.dart';
import 'package:box_cricket/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'modules/owner/provider_sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Error is ${e.toString()}");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteConstants().onGenerateRoute,
      home: const ProviderSignUp(),
      // home: const BoxDetailScreen(indicatorIndex: 1, heroTag: ""),
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: "Pangolin",
          primaryColor: ColorConstants.primaryColor),
    );
  }
}
