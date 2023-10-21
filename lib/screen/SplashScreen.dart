import 'package:flutter/material.dart';
import '/../main.dart';
import '/../screen/DashBoardScreen.dart';
import '/../screen/ProductDetail/ProductDetailScreen1.dart';
import '/../utils/Colors.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';

import 'WalkThroughScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(isHalloween ? mChristmasColor : primaryColor!, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.dark);
    await Future.delayed(Duration(seconds: 2));

    String productId = await getProductIdFromNative();
    print(productId);

    if (productId.isNotEmpty) {
      ProductDetailScreen1(mProId: productId.toInt()).launch(context);
    } else {
      checkFirstSeen();
    }
  }

  Future checkFirstSeen() async {
    bool _seen = (getBoolAsync('seen'));
    if (_seen) {
      DashBoardScreen().launch(context, isNewTask: true);
    } else {
      await setValue('seen', true);
      WalkThroughScreen().launch(context, isNewTask: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(splash, width: width * 0.65, height: 200, fit: BoxFit.cover),
          Text(AppName, style: boldTextStyle(color: Theme.of(context).textTheme.titleSmall!.color, size: 26)),
        ],
      ).center(),
    );
  }
}
