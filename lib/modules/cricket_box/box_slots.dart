import 'dart:math';

import 'package:box_cricket/base_widgets/base_button.dart';
import 'package:box_cricket/base_widgets/base_snackbar.dart';
import 'package:box_cricket/base_widgets/base_text_field.dart';
import 'package:box_cricket/constants/color_constants.dart';
import 'package:box_cricket/models/BookingSlots.dart';
import 'package:box_cricket/modules/owner/logic/owner_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../models/OwnerRegistrationModel.dart';

class BoxSlots extends StatefulWidget {
  const BoxSlots({Key? key, required this.ownerRegistrationModel})
      : super(key: key);
  final OwnerRegistrationModel ownerRegistrationModel;

  @override
  _BoxSlotsState createState() => _BoxSlotsState();
}

class _BoxSlotsState extends State<BoxSlots> {
  late List<BookingSlots> _timings;
  late List<BookingSlots> _selectedTimings;
  late TextEditingController _lateNightController;
  late TextEditingController _morningController;
  late TextEditingController _afternoonController;
  late TextEditingController _nightController;
  late OwnerRegistrationModel _ownerRegistrationModel;
  late OwnerCubit _cubit;
  late GlobalKey<FormState> _formKey;

  @override
  void dispose() {
    _cubit.close();
    _nightController.dispose();
    _lateNightController.dispose();
    _morningController.dispose();
    _afternoonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timings = [];
    _selectedTimings = [];
    _lateNightController = TextEditingController();
    _morningController = TextEditingController();
    _afternoonController = TextEditingController();
    _nightController = TextEditingController();
    _ownerRegistrationModel = widget.ownerRegistrationModel;
    _formKey = GlobalKey<FormState>();
    print("Init state called");

    DateTime now = DateTime.now();
    DateTime _date = DateTime(now.year, now.month, now.day, 24, 00);

    int index = 0;
    while (_date.hour >= 0) {
      print("Hour is ${_date.hour}");

      _timings.add(BookingSlots(
        startTime: _date.toUtc().toIso8601String(),
        endTime:
            _date.add(const Duration(minutes: 30)).toUtc().toIso8601String(),
        selected: true,
        pricing: "",
        period: _getPeriod(index),
        id: index,
      ));

      _date = _date.add(const Duration(minutes: 30));
      print("Hour after is ${_date.hour}");
      if (_date.hour == 0 && _date.minute == 0) {
        break;
      }
      index++;
    }

    _selectedTimings.addAll(_timings);
    _cubit = OwnerCubit();
  }

  String _getPeriod(int i) {
    if (i < 12) {
      return "lateNight";
    } else if (i < 24) {
      return "morning";
    } else if (i < 36) {
      return "afternoon";
    } else {
      return "night";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: _cubit,
        listener: (context, state) {
          if (state is OwnerFailed) {
            ScaffoldMessenger.of(context)
                .showSnackBar(baseSnackBar(text: state.error));
          }
        },
        child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, innerBoxScrolled) {
              return [
                SliverAppBar(
                  actions: [
                    TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _ownerRegistrationModel.bookingSlots =
                                _selectedTimings.map((element) {
                              String period = element.period ?? "";
                              if (period == "lateNight") {
                                element.pricing = _lateNightController.text;
                              } else if (period == "morning") {
                                element.pricing = _morningController.text;
                              } else if (period == "afternoon") {
                                element.pricing = _afternoonController.text;
                              } else {
                                element.pricing = _nightController.text;
                              }
                              return element;
                            }).toList();

                            _cubit.register(_ownerRegistrationModel);
                          }
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        )),
                  ],
                  foregroundColor: Colors.white,
                  pinned: true,
                  backgroundColor: ColorConstants.primaryColor,
                  expandedHeight: 150,
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
                                "Please deselect the slots for which you are not available.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ));
                  }),
                ),
              ];
            },
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _getText("Late Night", "12AM - 6AM",
                        controller: _lateNightController),
                    _getSlotsGrid(0, "lateNight"),
                    _getDivider(),
                    _getText("Morning", "6AM - 12PM",
                        controller: _morningController),
                    _getSlotsGrid(12, "morning"),
                    _getDivider(),
                    _getText("Afternoon", "12PM - 6PM",
                        controller: _afternoonController),
                    _getSlotsGrid(24, "afternoon"),
                    _getDivider(),
                    _getText("Night", "6PM - 12AM",
                        controller: _nightController),
                    _getSlotsGrid(36, "night"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BaseButton(onTap: () {}, text: "Register"),
                    ),
                  ],
                ),
              ),
            )),
      ),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Price cannot be empty";
                }
                return null;
              },
              // isOutlined: false,
              controller: controller,
              maxLen: 4,
              contentPadding: EdgeInsets.zero,
              labelText: "Price per hour",
              prefixIcon: const Icon(Icons.currency_rupee,
                  color: ColorConstants.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSlotsGrid(int add, String period) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(
        12,
        (index) => _getSlotCard(_timings[index + add]),
      ),
    );
  }

  Widget __transitionBuilder(
      Widget widget, Animation<double> animation, bool showFrontSide) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(showFrontSide) != widget?.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  Widget _getSlotCard(BookingSlots slot) {
    DateTime date = DateTime.parse(slot.startTime ?? "").toLocal();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: InkWell(splashColor: Colors.transparent,
          onTap: () {
            // if (_selectedTimings.contains(time)) {
            //   _selectedTimings.remove(time);
            // } else {
            //   _selectedTimings.add(time);
            // }
            slot.selected = !(slot.selected ?? false);
            print("Slot to json is ${slot.toJson()}");
            setState(() {});
          },
          child: AnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              switchInCurve: Curves.easeInToLinear,
              switchOutCurve: Curves.linearToEaseOut,
              duration: const Duration(
                milliseconds: 300,
              ),
              child: (slot.selected ?? false)
                  ? _getCard(ColorConstants.primaryColor, date, "Available",
                      ValueKey("${slot.id}front"))
                  : _getCard(Colors.grey, date, "Not Available",
                      ValueKey("${slot.id}rear"))
              // Container(
              //   width: 165,
              //   // height: 40,
              //   padding: const EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8),
              //     color: // _selectedTimings.contains(time)
              //         (slot.selected ?? false)
              //             ? ColorConstants.primaryColor
              //             : Colors.grey,
              //   ),
              //   child: Center(
              //     child: Column(
              //       children: [
              //         Text(
              //           "${DateFormat("hh:mm").format(date)} - ${DateFormat("hh:mm").format(
              //             date.add(
              //               const Duration(minutes: 30),
              //             ),
              //           )}",
              //           style: const TextStyle(color: Colors.white),
              //         ),
              //         Text(
              //           "${!(slot.selected ?? false) ? "Not" : ""} Available",
              //           style: const TextStyle(color: Colors.white),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              ),
        ),
      ),
    );
  }

  Widget _getCard(Color color, DateTime date, String text, ValueKey key) {
    return Container(
      key: key,
      width: 165,
      // height: 40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
        // (slot.selected ?? false)
        //     ? ColorConstants.primaryColor
        //     : Colors.grey,
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
              text,
              // "${!(slot.selected ?? false) ? "Not" : ""} Available",
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
