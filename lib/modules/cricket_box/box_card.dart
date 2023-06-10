import 'package:box_cricket/base_widgets/base_hero_widget.dart';
import 'package:box_cricket/constants/color_constants.dart';
import 'package:box_cricket/constants/route_constants.dart';
import 'package:box_cricket/modules/cricket_box/box_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_constants.dart';

class BoxCard extends StatefulWidget {
  const BoxCard({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<BoxCard> createState() => _BoxCardState();
}

class _BoxCardState extends State<BoxCard> {
  late final PageController _pageController;

  late int _indicatorIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _indicatorIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RouteConstants.boxDetailScreen,
              arguments: {
                "indicatorIndex": _indicatorIndex,
              });
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: ColorConstants.primaryColor,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        PageView.builder(
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
                        Positioned(
                          bottom: 2,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  3,
                                  (index) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AnimatedContainer(
                                          decoration: BoxDecoration(
                                              color: (_indicatorIndex == index)
                                                  ? ColorConstants.primaryColor
                                                  : null,
                                              border: Border.all(
                                                color:
                                                    (_indicatorIndex == index)
                                                        ? ColorConstants
                                                            .primaryColor
                                                        : Colors.white,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      (_indicatorIndex == index)
                                                          ? 5
                                                          : 2)),
                                          duration:
                                              const Duration(milliseconds: 300),
                                          height: 10,
                                          width: 10,
                                        ),
                                      )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$500/hr",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Nikol, Ahmedabad",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                )
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Book now",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 70,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black45,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.all(4),
                child: Text(
                  "Dashing Box Cricket",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
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
