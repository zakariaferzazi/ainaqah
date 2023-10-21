import 'package:flutter/material.dart';
import '/../models/WalkModel.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../DashBoardScreen.dart';

class ChristmasWalkThroughScreen extends StatefulWidget {
  static String tag = '/HalloweenWalkThroughScreen';

  @override
  ChristmasWalkThroughScreenState createState() => ChristmasWalkThroughScreenState();
}

class ChristmasWalkThroughScreenState extends State<ChristmasWalkThroughScreen> {
  var pageController = PageController();
  int position = 0;
  List<WalkModel> mWalkList = getChristmasWalkData();

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
            Container(
              height: context.height() * 0.7,
              width: context.width(),
              child: PageView.builder(
                controller: pageController,
                itemCount: mWalkList.length,
                itemBuilder: (context, i) {
                  return SizedBox(

                      child: Image.asset(mWalkList[i].image!, fit: BoxFit.fill,
                        )).paddingOnly(top: 100,left: 16,right:16 );
                },
                onPageChanged: (value) {
                  setState(() => position = value);
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                24.height,
                Text(mWalkList[position].title!, style: boldTextStyle(size: 24)),
                16.height,
                Text(mWalkList[position].desc!, style: primaryTextStyle(), textAlign: TextAlign.center),
                32.height,
                DotIndicator(
                  pageController: pageController,
                  pages: mWalkList,
                  indicatorColor: mChristmasColor,
                ),
                16.height,
                AnimatedCrossFade(
                  duration: Duration(milliseconds: 300),
                  firstChild: AppButton(
                    height: 20,
                    padding: EdgeInsets.all(8),
                    text: "Get Started",
                    textStyle: boldTextStyle(color: white),
                    color: mChristmasColor,
                    shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    onTap: () {
                      DashBoardScreen().launch(context, isNewTask: true);
                    },
                  ),
                  firstCurve: Curves.easeIn,
                  secondCurve: Curves.easeOut,
                  crossFadeState: position == (mWalkList.length - 1) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  secondChild: SizedBox(),
                ),
                AnimatedCrossFade(
                    firstChild: AppButton(
                      height: 20,
                      padding: EdgeInsets.all(8),
                      text: "Skip",
                      textStyle: boldTextStyle(color: white),
                      color: mChristmasColor,
                      shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      onTap: () {
                        DashBoardScreen().launch(context, isNewTask: true);
                      },
                    ),
                    secondChild: SizedBox(),
                    duration: Duration(milliseconds: 300),
                    firstCurve: Curves.easeIn,
                    secondCurve: Curves.easeOut,
                    crossFadeState: position == (mWalkList.length - 1) ? CrossFadeState.showSecond : CrossFadeState.showFirst),
              ],
            ).paddingOnly(bottom: 70, right: 16, left: 16),
          ],
        ),
      ),
    );
  }
}
