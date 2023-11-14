import 'package:flutter/material.dart';
import '/../main.dart';
import '/../screen/DashBoardScreen.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';

class WalkThroughScreen extends StatefulWidget {
  static String tag = '/WalkThroughScreen';

  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  List<Widget> pages = [];
  var selectedIndex = 0;

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  init() async {
    pages = [
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(walk_Img1,
                    height: context.height() * 0.4, fit: BoxFit.contain)
                .paddingAll(24),
            20.height,
            Text('Welcome to Ainaqah', style: boldTextStyle(size: 24))
                .paddingOnly(top: 16, left: 16),
            Text('Shopping is my all-time favorite thing to do! Tish Cyrus. ',
                    textAlign: TextAlign.center,
                    style: secondaryTextStyle(size: 16))
                .paddingOnly(right: 24, left: 16, top: 8)
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(walk_Img2,
                    height: context.height() * 0.4, fit: BoxFit.contain)
                .paddingAll(24),
            20.height,
            Text('Checkout', style: boldTextStyle(size: 24))
                .paddingOnly(top: 16, left: 16),
            Text('Win or lose, we go shopping after the election. Imelda Marcos.',
                    textAlign: TextAlign.center,
                    style: secondaryTextStyle(size: 16))
                .paddingOnly(right: 24, left: 16, top: 8)
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(walk_Img3,
                    height: context.height() * 0.4, fit: BoxFit.contain)
                .paddingAll(24),
            20.height,
            Text('Get Your Order', style: boldTextStyle(size: 24))
                .paddingOnly(top: 16, left: 16),
            Text('I always say shopping is cheaper than a psychiatrist. ',
                    textAlign: TextAlign.center,
                    style: secondaryTextStyle(size: 16))
                .paddingOnly(right: 24, left: 16, top: 8)
          ],
        ),
      )
    ];
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    init();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          child: Stack(
            children: [
              PageView(
                  children: pages,
                  controller: _pageController,
                  onPageChanged: (index) {
                    selectedIndex = index;
                    setState(() {});
                  }),
              AnimatedPositioned(
                  duration: Duration(seconds: 1),
                  bottom: 70,
                  left: 0,
                  right: 0,
                  child: DotIndicator(
                      pages: pages,
                      indicatorColor: primaryColor,
                      pageController: _pageController)),
              Positioned(
                  child: AnimatedCrossFade(
                      firstChild: Container(
                              child: Text('Get Started',
                                  style: boldTextStyle(color: white)),
                              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                              decoration: BoxDecoration(
                                  color: primaryColor, borderRadius: radius(8)))
                          .onTap(() {
                        DashBoardScreen().launch(context, isNewTask: true);
                      }),
                      secondChild: SizedBox(),
                      duration: Duration(milliseconds: 300),
                      firstCurve: Curves.easeIn,
                      secondCurve: Curves.easeOut,
                      crossFadeState: selectedIndex == (pages.length - 1)
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond),
                  bottom: 20,
                  right: 20),
              Positioned(
                  child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          child: Text('Skip',
                              style: boldTextStyle(color: primaryColor)),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8))
                      .onTap(() {
                    DashBoardScreen().launch(context, isNewTask: true);
                  }),
                  right: 8,
                  top: 8)
            ],
          ),
        ),
      ),
    );
  }
}
