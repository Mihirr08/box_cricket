import 'package:box_cricket/base_widgets/base_hero_widget.dart';
import 'package:box_cricket/base_widgets/revenue_chart.dart';
import 'package:box_cricket/constants/color_constants.dart';
import 'package:box_cricket/constants/textstyle_constants.dart';
import 'package:box_cricket/modules/qr_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../base_widgets/base_button.dart';

class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({Key? key}) : super(key: key);

  @override
  _OwnerHomePageState createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  late bool _showNav;

  late ScrollController _scrollController;

  bool _tilt = true;

  @override
  void initState() {
    super.initState();
    _showNav = true;
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset == 0 && !_tilt) {
        setState(() {
          _tilt = true;
        });
      } else if (_tilt) {
        setState(() {
          _tilt = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              print("Direction ${notification.direction}");
              if (notification.direction == ScrollDirection.reverse) {
                setState(() {
                  _showNav = false;
                });
              } else {
                setState(() {
                  _showNav = true;
                });
              }
              return true;
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 18.0),
                        child: Text("Good Morning,",
                            style: TextStyle(fontSize: 18)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text("Mihir Patel",
                            style: TextStyleConstants.label20),
                      ),
                    ],
                  ),
                  expandedHeight: 90,
                  stretch: true,
                  collapsedHeight: 80,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [StretchMode.blurBackground],
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            ColorConstants.primaryColor.withOpacity(0.4),
                          ],
                          end: Alignment.topCenter,
                          begin: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: AnimatedRotation(
                      turns: _tilt ? 0.01 : 0.00,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: ColorConstants.primaryColor,
                                  spreadRadius: 0.1,
                                  blurRadius: 10,
                                  offset: Offset(1, 10)),
                            ],
                            borderRadius: BorderRadius.circular(12)),
                        // height: 200,
                        child: const Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Revenue",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Icon(Icons.arrow_forward_ios)
                                  ]),
                            ),
                            SizedBox(height: 150, child: RevenueChart()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // SliverToBoxAdapter(
                //     child: Padding(
                //   padding: const EdgeInsets.all(18.0),
                //   child: Transform.rotate(
                //     angle: -0.05,
                //     child: Container(
                //       decoration: BoxDecoration(
                //           color: Colors.white,
                //           boxShadow: const [
                //             BoxShadow(
                //                 color: ColorConstants.primaryColor,
                //                 spreadRadius: 0.1,
                //                 blurRadius: 10,
                //                 offset: Offset(1, 10)),
                //           ],
                //           borderRadius: BorderRadius.circular(12)),
                //       // height: 200,
                //       child: const Column(
                //         children: [
                //           Padding(
                //             padding: EdgeInsets.all(18.0),
                //             child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   Text(
                //                     "Revenue",
                //                     style: TextStyle(fontSize: 20),
                //                   ),
                //                   Icon(Icons.arrow_forward_ios)
                //                 ]),
                //           ),
                //           SizedBox(height: 150, child: RevenueChart()),
                //         ],
                //       ),
                //     ),
                //   ),
                // )),

                SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverList.builder(
                    itemBuilder: (context, index) {
                      return _todayBookings();
                    },
                    itemCount: 10,
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 80,
                  ),
                ),

                // SliverFillRemaining(
                //   hasScrollBody: false,
                //   child: Column(
                //     children: [
                //
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _showNav ? 0 : -100,
            left: 0,
            right: 0,
            // alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, //ColorConstants.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  border: Border.all(color: ColorConstants.primaryColor)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BottomNavigationBar(
                  elevation: 0,
                  selectedItemColor: ColorConstants.primaryColor,
                  backgroundColor: Colors.white, //ColorConstants.primaryColor,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined, size: 30),
                        label: "Home"),
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.settings_outlined,
                          size: 30,
                        ),
                        label: "Settings"),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: Card(
                shape: const CircleBorder(),
                elevation: 8,
                shadowColor: ColorConstants.primaryColor,
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(
                //         color: ColorConstants.primaryColor)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QrCodeScanner(),
                      ),
                    ).then((value) {
                      if (value != null) {
                        _showStatusDialog(value, context: context);
                      }
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: BaseHeroWidget(
                      tag: "qr_scan",
                      child: Icon(
                        Icons.qr_code_scanner,
                        size: 30,
                      ),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  Future<void> _showStatusDialog(String value,
      {required BuildContext context}) {
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.verified,
                      size: 80,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    "Booker's Name: $value",
                    style: TextStyleConstants.label,
                  ),
                  const Text(
                    "Slot Time: 12:00 PM - 1:00 PM",
                    style: TextStyleConstants.label,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
                    child: BaseButton(
                      text: "OKAY",
                      onTap: () {
                        Navigator.pop(dialogContext);
                      },
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _todayBookings() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white38,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black)),
        child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Time: 12:00 PM : 1:00 PM",
                    style: TextStyleConstants.label,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text("Booked by: Mihir Patel",
                    style: TextStyleConstants.value),
              )
            ]),
      ),
    );
  }
}
