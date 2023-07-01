import 'package:box_cricket/constants/color_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseBottomNavBar extends StatefulWidget {
  const BaseBottomNavBar({Key? key}) : super(key: key);

  @override
  _BaseBottomNavBarState createState() => _BaseBottomNavBarState();
}

class _BaseBottomNavBarState extends State<BaseBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          color: ColorConstants.primaryColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          border: Border.all(color: ColorConstants.primaryColor)),
      child: Row(
        children: [
          Expanded(
              child: SizedBox(
            height: 80,
            child: InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.book_online_outlined,
                )),
          )),
          Expanded(
              child: SizedBox(
            // height: 80,
            child: InkWell(
                onTap: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings,
                    ),
                    Text("Settings"),
                  ],
                )),
          )),
        ],
      ),
    );
  }
}
