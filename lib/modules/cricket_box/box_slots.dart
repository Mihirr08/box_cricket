import 'dart:developer';

import 'package:box_cricket/base_widgets/base_text_field.dart';
import 'package:box_cricket/constants/color_constants.dart';
import 'package:box_cricket/modules/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoxSlots extends StatefulWidget {
  const BoxSlots({Key? key}) : super(key: key);

  @override
  _BoxSlotsState createState() => _BoxSlotsState();
}

class _BoxSlotsState extends State<BoxSlots> {
  late List<int> _timings;
  late List<int> _selectedTimings;
  late TextEditingController _lateNightController;
  late TextEditingController _morningController;
  late TextEditingController _afternoonController;
  late TextEditingController _nightController;

  @override
  void initState() {
    super.initState();
    _timings = [];
    _selectedTimings = [];
    _lateNightController = TextEditingController();
    _morningController = TextEditingController();
    _afternoonController = TextEditingController();
    _nightController = TextEditingController();

    print("Init state called");

    DateTime _date = DateTime(2022, 12, 1, 24, 00);
    log("Hour is ${_date.hour}");

    while (_date.hour >= 0) {
      print("Hour is ${_date.hour}");
      _timings.add(_date.millisecondsSinceEpoch);

      _date = _date.add(const Duration(minutes: 30));
      print("Hour after is ${_date.hour}");
      if (_date.hour == 0 && _date.minute == 0) {
        break;
      }
    }
    _selectedTimings.addAll(_timings);
    log("list is $_timings ${_timings.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, innerBoxScrolled) {
            return [
              SliverAppBar(
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      )),
                ],
                foregroundColor: Colors.white,
                pinned: true,
                backgroundColor: ColorConstants.primaryColor,
                expandedHeight: 130,
                // bottom: AppBar(title: Text("Configure box")),
                title: const Text("Configure Your Box"),
                flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                  return FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorConstants.primaryColor,
                              ColorConstants.primaryColor,
                              Colors.white,
                            ],
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                          ),
                        ),
                      ),
                      centerTitle: true,
                      title: constraints.maxHeight < 150
                          ? const SizedBox()
                          : const Text(
                              "Configure your box's pricing and timing",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ));
                }),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _getText("Late Night", "12AM - 6AM",
                    controller: _lateNightController),
                _getSlotsGrid(0),
                _getDivider(),
                _getText("Morning", "6AM - 12PM",
                    controller: _morningController),
                _getSlotsGrid(12),
                _getDivider(),
                _getText("Afternoon", "12PM - 6PM",
                    controller: _afternoonController),
                _getSlotsGrid(24),
                _getDivider(),
                _getText("Night", "6PM - 12AM", controller: _nightController),
                _getSlotsGrid(36),
              ],
            ),
          )),
    );
  }

  Widget _getDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
      child: Container(
        decoration: const BoxDecoration(color: Colors.grey),
        height: 1,
      ),
    );
  }

  Widget _getText(String text, String priceTime,
      {required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: RichText(
              text: TextSpan(
                  text: "$text ",
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  children: [
                    TextSpan(
                      text: "($priceTime)",
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    )
                  ]),
            ),
          ),
          Expanded(
            flex: 5,
            child: BaseTextField(
              keyboardType: TextInputType.number,
              // isOutlined: false,
              controller: controller,
              maxLen: 4,
              contentPadding: EdgeInsets.zero,
              labelText: "Price for slot",
              prefixIcon: const Icon(Icons.currency_rupee,
                  color: ColorConstants.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSlotsGrid(int add) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(
        12,
        (index) => _getSlotCard(_timings[index + add]),
      ),
    );
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 2.6),
      itemBuilder: (context, index) {
        return _getSlotCard(_timings[index + add]);
      },
      itemCount: 6, //_timings.length,
    );
  }

  Widget _getSlotCard(int time) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: InkWell(
          onTap: () {
            if (_selectedTimings.contains(time)) {
              _selectedTimings.remove(time);
            } else {
              _selectedTimings.add(time);
            }
            setState(() {});
          },
          child: Container(
            width: 165,
            // height: 40,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _selectedTimings.contains(time)
                  ? ColorConstants.primaryColor
                  : Colors.grey,
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "${DateFormat("hh:mm").format(date)} - ${DateFormat("hh:mm").format(
                      date.add(
                        const Duration(minutes: 30),
                      ),
                    )}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "${!_selectedTimings.contains(time) ? "Not" : ""} Available",
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
