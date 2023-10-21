import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '/../AppLocalizations.dart';
import '/../main.dart';
import '/../utils/Colors.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class DashBoardScreen extends StatefulWidget {
  static String tag = '/DashBoardScreen1';

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  bool mIsLoggedIn = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  init() async {
    setStatusBarColor(primaryColor!);
    setState(() {
      mIsLoggedIn = getBoolAsync(IS_LOGGED_IN);
    });
    setValue(CARTCOUNT, appStore.count);
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult notification) async {
      if (notification.notification.additionalData!.containsKey('ID')) {
        String? notId = notification.notification.additionalData!["ID"];

        if (notId.validate().isNotEmpty) {
          // String heroTag = '$notId${currentTimeStamp()}';
        }
      }
    });

    window.onPlatformBrightnessChanged = () {
      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
        appStore.setDarkMode(aIsDarkMode: MediaQuery.of(context).platformBrightness == Brightness.light);
      }
    };
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    window.onPlatformBrightnessChanged = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Observer(
      builder: (context) => Scaffold(
        body: appStore.dashboardScreeList[appStore.index],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: isHalloween ? mChristmasColor : context.cardColor,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          elevation: 1,
          currentIndex: appStore.index,
          unselectedItemColor: isHalloween ? white.withOpacity(0.6) : Theme.of(context).textTheme.titleMedium!.color,
          unselectedLabelStyle: TextStyle(color: isHalloween ? white : Theme.of(context).textTheme.titleMedium!.color),
          selectedItemColor: isHalloween ? white : primaryColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Ionicons.ios_home_outline, color: isHalloween ? white.withOpacity(0.6) : Theme.of(context).textTheme.titleMedium!.color),
                activeIcon: Icon(Ionicons.ios_home, color: isHalloween ? white : primaryColor),
                label: appLocalization.translate("lbl_home")),
            BottomNavigationBarItem(
                icon: Icon(Ionicons.ios_grid_outline, color: isHalloween ? white.withOpacity(0.6) : Theme.of(context).textTheme.titleMedium!.color),
                activeIcon: Icon(Ionicons.ios_grid, color: isHalloween ? white : primaryColor),
                label: appLocalization.translate("lbl_category")),
            BottomNavigationBarItem(
              icon: Stack(
                children: <Widget>[
                  Icon(Icons.shopping_bag_outlined, color: isHalloween ? white.withOpacity(0.6) : Theme.of(context).textTheme.titleMedium!.color),
                  appStore.count! > 0 && appStore.count != null
                      ? Positioned(
                          top: 2,
                          left: 10,
                          child: CircleAvatar(
                            maxRadius: 7,
                            backgroundColor: primaryColor,
                            child: FittedBox(
                              child: Text('${appStore.count}', style: secondaryTextStyle(color: Colors.white)),
                            ),
                          ),
                        ).visible(mIsLoggedIn || getBoolAsync(IS_GUEST_USER) == true)
                      : SizedBox()
                ],
              ),
              activeIcon: Stack(
                children: <Widget>[
                  Icon(MaterialIcons.shopping_bag, color: isHalloween ? white : primaryColor),
                  if (appStore.count.toString() != "0")
                    Positioned(
                      top: 2,
                      left: 10,
                      child: Observer(
                        builder: (_) => CircleAvatar(
                          maxRadius: 7,
                          backgroundColor: isHalloween ? mChristmasColor : primaryColor,
                          child: FittedBox(
                            child: Text(
                              '${appStore.count}',
                              style: secondaryTextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ).visible(mIsLoggedIn || getBoolAsync(IS_GUEST_USER) == true),
                ],
              ),
              label: appLocalization.translate("lbl_basket"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_sharp, color: isHalloween ? white.withOpacity(0.6) : Theme.of(context).textTheme.titleMedium!.color),
              activeIcon: Icon(MaterialIcons.favorite, color: isHalloween ? white : primaryColor),
              label: appLocalization.translate("lbl_favourite"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.person_outline, color: isHalloween ? white.withOpacity(0.6) : Theme.of(context).textTheme.titleMedium!.color),
              activeIcon: Icon(Ionicons.person, color: isHalloween ? white : primaryColor),
              label: appLocalization.translate("lbl_account"),
            )
          ],
          onTap: appStore.setBottomNavigationIndex,
        ),
      ),
    );
  }
}
