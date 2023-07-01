import 'dart:developer';

import 'package:box_cricket/base_widgets/base_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/asset_constants.dart';
import '../../constants/color_constants.dart';

class BoxSlotModel {
  List<String> slotList;
  List<String> selectedSlotList;

  BoxSlotModel({required this.slotList, required this.selectedSlotList});
}

class BoxDetailScreen extends StatefulWidget {
  const BoxDetailScreen({Key? key, required this.indicatorIndex})
      : super(key: key);
  final int indicatorIndex;

  @override
  _BoxDetailScreenState createState() => _BoxDetailScreenState();
}

class _BoxDetailScreenState extends State<BoxDetailScreen> {
  late final PageController _pageController;

  late int _indicatorIndex;

  // late List<String> _timings;
  late List<String> _selectedTimings;

  String? _selectedDate;

  late Map<String, BoxSlotModel> _slotsMap;

  bool _turnsUp = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.indicatorIndex);
    _indicatorIndex = widget.indicatorIndex;
    // _timings = [];
    _selectedTimings = [];

    DateTime date = DateTime(2022, 12, 1, 24, 00);
    log("Hour is ${date.hour}");

    // while (date.hour >= 0) {
    //   print("Hour is ${date.hour}");
    //   _timings.add(date.toIso8601String());
    //
    //   date = date.add(const Duration(minutes: 30));
    //   print("Hour after is ${date.hour}");
    //   if (date.hour == 0 && date.minute == 0) {
    //     break;
    //   }
    // }
    // // _selectedTimings.addAll(_timings);
    // log("list is $_timings ${_timings.length}");
    _setMap();
  }

  void _setMap() {
    DateTime dateTimeNow = DateTime.now();

    _slotsMap = {};
    for (int i = 0; i < 7; i++) {
      DateTime currentDate =
          DateTime.parse(dateTimeNow.add(Duration(days: i)).toIso8601String());

      DateTime date = DateTime(
          currentDate.year, currentDate.month, currentDate.day, 24, 00);
      List<String> timings = [];
      log("Hour is ${date.hour}");

      while (date.hour >= 0) {
        print("Hour is ${date.hour}");
        timings.add(date.subtract(const Duration(days: 1)).toIso8601String());

        date = date.add(const Duration(minutes: 30));
        print("Hour after is ${date.hour}");
        if (date.hour == 0 && date.minute == 0) {
          break;
        }
      }

      _slotsMap[currentDate.toIso8601String()] =
          BoxSlotModel(slotList: timings.toList(), selectedSlotList: []);
    }
    _selectedDate = _slotsMap.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Box Booking"),
          elevation: 0,
          leading: Navigator.canPop(context)
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios))
              : null),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                    leading: const SizedBox(),
                    toolbarHeight: 200,
                    stretch: true,
                    collapsedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      background: PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              _indicatorIndex = index;
                            });
                          },
                          controller: _pageController,
                          itemCount: 3,
                          itemBuilder: (context, pageViewIndex) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                _getImage(pageViewIndex),
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            );
                          }),
                    )),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0, top: 2, right: 4),
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorConstants.primaryColor),
                                color: index == _indicatorIndex
                                    ? ColorConstants.primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_slotsMap.keys.length, (index) {
                      return _getDateCard(index);
                    }),
                  ),
                )),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: Container(
                      color: Colors.grey,
                      height: 1,
                    ),
                  ),
                ),
                SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                        childCount:
                            (_slotsMap[_selectedDate]?.slotList)?.length ?? 0,
                        (context, index) {
                      return _getSlotCard(_slotsMap[_selectedDate]
                              ?.slotList[index]
                              .toString() ??
                          "");
                    }),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                    )),
                if (_selectedTimings.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 68),
                  )
              ],
            ),
          ),
          AnimatedPositioned(
            curve: Curves.bounceInOut,
            duration: const Duration(milliseconds: 300),
            bottom: (_selectedTimings.isNotEmpty) ? 0 : -100,
            // bottom: 0,
            left: 0,
            right: 0,
            // alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _turnsUp = !_turnsUp;
                });
              },
              child: AnimatedContainer(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 200),
                height: _turnsUp
                    ? 80
                    : (_selectedTimings.length >= 4
                        ? 500
                        : (80 + (_selectedTimings.length * 100))),
                decoration: BoxDecoration(
                  // boxShadow:   [
                  //   BoxShadow(
                  //     color: Colors.black,
                  //     blurRadius: 1000,
                  //    blurStyle: BlurStyle.outer
                  //   )
                  // ],
                  border: Border.all(color: ColorConstants.primaryColor),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    // if (!_turnsUp)
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       TextButton(
                    //         onPressed: () {},
                    //         child: const Text("Close"),
                    //       ),
                    //       TextButton(
                    //         onPressed: () {},
                    //         child: const Text("Clear All"),
                    //       ),
                    //     ],
                    //   ),
                    Expanded(
                        child: ListView(children: [
                      ...List.generate(_selectedTimings.length, (index) {
                        return _slotItemWidget(index);
                      }),
                    ])),
                    // if(_turnsUp)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.calendar_month_outlined, size: 28),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${_selectedTimings.length} Slot${_selectedTimings.length == 1 ? "" : "s"} selected",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: AnimatedRotation(
                                    duration: const Duration(milliseconds: 300),
                                    turns: _turnsUp ? 0.0 : 0.5,
                                    curve: Curves.decelerate,
                                    child: Image.asset(
                                      AssetConstants.arrowUp,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BaseButton(
                              width: 150,
                              radius: 18,
                              onTap: () {},
                              text: "Next",
                              trailingIcon: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Image.asset(
                                  AssetConstants.arrowRight,
                                  width: 10,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _slotItemWidget(int index) {
    int slotTime =
        DateTime.parse(_selectedTimings[index]).millisecondsSinceEpoch;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(slotTime);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black,
            )),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(
                        text:
                            "${DateFormat("hh:mm a").format(date)} - ${DateFormat("hh:mm a").format(
                          date.add(
                            const Duration(minutes: 30),
                          ),
                        )}",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                        children: [
                      TextSpan(
                          text: DateFormat(" (dd/MMM)").format(date),
                          style: const TextStyle(fontSize: 16))
                    ])),
                const Row(
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      size: 18,
                    ),
                    Text("200", style: TextStyle(fontSize: 18)),
                  ],
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimings.removeAt(index);
                });
              },
              child: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDateCard(int index) {
    bool isSelected = _selectedDate == _slotsMap.keys.elementAt(index);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDate = _slotsMap.keys.elementAt(index);
            print(_slotsMap);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorConstants.primaryColor,
            ),
            color: isSelected ? ColorConstants.primaryColor : null,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 80,
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                    text: DateFormat("dd").format(
                        DateTime.parse(_slotsMap.keys.elementAt(index))),
                    style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : ColorConstants.primaryColor,
                        fontSize: 18),
                    children: [
                      TextSpan(
                          text: DateFormat(" (MMM)").format(
                              DateTime.parse(_slotsMap.keys.elementAt(index))),
                          style: const TextStyle(fontSize: 12)),
                    ]),
              ),
              Text(
                DateFormat("EEE")
                    .format(DateTime.parse(_slotsMap.keys.elementAt(index))),
                style: TextStyle(
                    color:
                        isSelected ? Colors.white : ColorConstants.primaryColor,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSlotCard(String time) {
    DateTime date = DateTime.parse(time);
    bool isSelected = _selectedTimings.contains(time);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: InkWell(
          onTap: () {
            if (_selectedTimings.contains(time)) {
              print("Removed is $time");
              _selectedTimings.remove(time);
            } else {
              if (_selectedTimings.isEmpty) {
                _turnsUp = true;
              }
              print("Added is $time");
              _selectedTimings.add(time);
            }
            setState(() {});
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 165,
            // height: 40,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorConstants.primaryColor),
              color:
                  isSelected ? ColorConstants.primaryColor : Colors.transparent,
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "${DateFormat("hh:mm a").format(date)} - ${DateFormat("hh:mm a").format(
                      date.add(
                        const Duration(minutes: 30),
                      ),
                    )}",
                    style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : ColorConstants.primaryColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.currency_rupee_outlined,
                        size: 20,
                        color: !isSelected
                            ? ColorConstants.primaryColor
                            : Colors.white,
                      ),
                      Text(
                        "200",
                        style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : ColorConstants.primaryColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getImage(int index) {
    switch (index) {
      case 0:
        return AssetConstants.boxOneImage;
      case 1:
        return AssetConstants.boxTwoImage;
      case 2:
        return AssetConstants.boxThreeImage;
      default:
        return AssetConstants.boxOneImage;
    }
  }
}
