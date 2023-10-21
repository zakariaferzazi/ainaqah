import 'package:flutter/material.dart';
import '/../screen/HomeScreen/HomeScreen1.dart';
import '/../screen/HomeScreen/HomeScreen2.dart';
import '/../screen/HomeScreen/HomeScreen3.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class MyHomeScreen extends StatefulWidget {
  @override
  MyHomeScreenState createState() => MyHomeScreenState();
}

class MyHomeScreenState extends State<MyHomeScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {

    if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: 1) == 1) {
      return HomeScreen1();
    } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: 1) == 2) {
      return HomeScreen2();
    } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: 1) == 3) {
      return HomeScreen3();
    } else {
      return HomeScreen1();
    }
  }
}
