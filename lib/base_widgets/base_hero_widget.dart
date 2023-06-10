import 'package:flutter/material.dart';

class BaseHeroWidget extends StatelessWidget {
  const BaseHeroWidget({Key? key, required this.tag, required this.child})
      : super(key: key);

  final String tag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,transitionOnUserGestures: true,
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
