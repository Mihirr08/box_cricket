import 'package:box_cricket/base_widgets/base_text_field.dart';
import 'package:box_cricket/constants/asset_constants.dart';
import 'package:box_cricket/constants/color_constants.dart';
import 'package:box_cricket/modules/cricket_box/box_card.dart';
import 'package:box_cricket/modules/qr_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        toolbarHeight: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: Colors.white,
      drawer: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            border: Border.all(color: ColorConstants.primaryColor),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Stack(
                        children: [
                          SizedBox(
                              height: 100,
                              width: 100,
                              child:
                              // Container(
                              //   decoration: BoxDecoration(
                              //       color: Colors.white.withOpacity(0.7),
                              //       borderRadius: BorderRadius.circular(30)),
                              //   child: const Icon(Icons.person_outline_rounded, size: 50),
                              // )
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.asset(
                                  fit: BoxFit.cover,
                                  AssetConstants.profileImage,
                                ),
                              ),
                              ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: ColorConstants.primaryColor
                                      .withOpacity(0.7)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.edit_outlined,
                                    size: 15, color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        // width: double.infinity,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("My Bookings",
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                            // Lottie.asset(AssetConstants.bookingLottie,
                            //     height: 50, width: 50,fit: BoxFit.contain),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        // width: double.infinity,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Settings",
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => {},
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  leading: const SizedBox.shrink(),
                  collapsedHeight: 120,
                  pinned: true,
                  stretch: true,
                  elevation: 0,
                  flexibleSpace: Stack(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                AssetImage(AssetConstants.cricketHeaderImage),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: BaseTextField(
                              borderColor: Colors.black,
                              prefixIcon: Lottie.asset(
                                  AssetConstants.searchLottie,
                                  width: 12),
                              // hintStyle: TextStyle(color: Colors.white),
                              contentPadding: const EdgeInsets.all(8),
                              outlineRadius: BorderRadius.circular(10),
                              controller: TextEditingController(),
                              hintText: "Search Box",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  expandedHeight: 250,
                  backgroundColor: Colors.transparent,
                ),
                SliverList.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 8.0),
                        child: BoxCard(index: index),
                      );
                    },
                    itemCount: 10),
              ],
              // Padding(
              //   padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              //   child: ListView.builder(
              //       physics: const BouncingScrollPhysics(),
              //       itemBuilder: (context, index) {
              //         return const BoxCard();
              //       },
              //       itemCount: 10),
              // ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Builder(builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: ColorConstants.primaryColor.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: const Icon(
                      Icons.person_2,
                      size: 25,
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget _getFilter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorConstants.primaryColor,
            style: BorderStyle.solid,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Search Nearby", style: TextStyle(fontSize: 14)),
        ),
      ),
    );
  }
}
