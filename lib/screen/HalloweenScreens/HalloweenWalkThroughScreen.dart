import 'package:flutter/material.dart';
import '/../models/WalkModel.dart';
import '/../utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../DashBoardScreen.dart';

class HalloweenWalkThroughScreen extends StatefulWidget {
  static String tag = '/HalloweenWalkThroughScreen';

  @override
  HalloweenWalkThroughScreenState createState() => HalloweenWalkThroughScreenState();
}

class HalloweenWalkThroughScreenState extends State<HalloweenWalkThroughScreen> {
  var pageController = PageController();
  int position = 0;
  List<WalkModel> mWalkList = getWalkData();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: context.width(),
                  height: context.height(),
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: mWalkList.length,
                    itemBuilder: (context, i) {
                      return Stack(
                        children: [
                          Image.asset(mWalkList[i].image!, height: context.height(), fit: BoxFit.cover),
                          Container(height: context.height(), color: black.withOpacity(0.4)),
                        ],
                      );
                    },
                    onPageChanged: (value) {
                      setState(() => position = value);
                    },
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 40,
                  child: Text('Skip', style: primaryTextStyle(color: white)).onTap(() async {
                    DashBoardScreen().launch(context, isNewTask: true);
                  }),
                ),
                Positioned(
                  right: 16,
                  left: 16,
                  bottom: 16,
                  child: AppButton(
                    width: context.width(),
                    onTap: () async {
                      DashBoardScreen().launch(context, isNewTask: true);
                    },
                    color: white,
                    textColor: primaryColor,
                    text: "Get Started",
                  ),
                ).visible(position == (mWalkList.length - 1)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(mWalkList[position].title!, style: boldTextStyle(size: 24, color: white)),
                    16.height,
                    Text(mWalkList[position].desc!, style: primaryTextStyle(color: white.withOpacity(0.5)), textAlign: TextAlign.center),
                    32.height,
                    DotIndicator(
                      pageController: pageController,
                      pages: mWalkList,
                      indicatorColor: white,
                      unselectedIndicatorColor: white.withOpacity(0.5),
                    ),
                    16.height,
                  ],
                ).paddingOnly(bottom: 70, right: 16, left: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
