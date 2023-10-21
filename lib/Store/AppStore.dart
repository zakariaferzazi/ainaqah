import 'package:flutter/material.dart';
import '/../main.dart';
import '/../screen/CategoriesScreen.dart';
import '/../screen/ChristmasScreens/HomeScreen5.dart';
import '/../screen/MyCartScreen.dart';
import '/../screen/MyHomeScreen.dart';
import '/../screen/ProfileScreen.dart';
import '/../screen/WishListScreen.dart';
import '/../utils/Constants.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

part 'AppStore.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool isLoggedIn = false;

  @observable
  bool isNetworkAvailable = false;

  @observable
  bool isGuestUserLoggedIn = false;

  @observable
  bool isDarkModeOn = false;

  @observable
  int? count = 0;

  @observable
  bool mIsUserExistInReview = false;

  @observable
  bool isNotificationOn = true;

  @observable
  bool? isDarkMode = false;


  @observable
  String selectedLanguageCode = defaultLanguage;

  //Dashboard
  @observable
  int index = 0;

  @observable
  List<Widget> dashboardScreeList = [
    isHalloween ? HomeScreen5() : MyHomeScreen(),
    CategoriesScreen(),
    MyCartScreen(isShowBack: false),
    WishListScreen(),
    ProfileScreen(),
  ];

  @action
  void setLoading(bool aIsLoading) {
    isLoading = aIsLoading;
  }

  @action
  void setConnectionState(ConnectivityResult val) {
    isNetworkAvailable = val != ConnectivityResult.none;
  }

  @action
  void setBottomNavigationIndex(int val) {
    index = val;
  }

  @action
  Future<void> toggleDarkMode({bool? value}) async {
    isDarkModeOn = value ?? !isDarkModeOn;
  }

  @action
  void setLoggedIn(bool val) {
    isLoggedIn = val;
    setValue(IS_LOGGED_IN, val);
  }

  @action
  void setGuestUserLoggedIn(bool val) {
    isGuestUserLoggedIn = val;
    setValue(IS_GUEST_USER, val);
  }

  @action
  Future<void> setDarkMode({bool? aIsDarkMode}) async {
    isDarkMode = aIsDarkMode;

    if (isDarkMode!) {
      textPrimaryColorGlobal = Colors.white54;
      textSecondaryColorGlobal = Colors.white70;
      setStatusBarColor(primaryColor!);
    } else {
      textPrimaryColorGlobal = textPrimaryColour!;
      textSecondaryColorGlobal = textSecondaryColour!;
      setStatusBarColor(primaryColor!);
    }
  }

  @action
  void increment() {
    count = count! + 1;
  }

  @action
  void decrement({int? qty}) {
    if (qty != null) {
      count = count! - qty;
    } else {
      count = count! - 1;
    }
  }

  @action
  void setCount(int? aCount) => count = aCount;

  @action
  Future<void> setLanguage(String aSelectedLanguageCode) async {
    selectedLanguageCode = aSelectedLanguageCode;

    language = languages.firstWhere((element) => element.languageCode == aSelectedLanguageCode);
    setValue(LANGUAGE, aSelectedLanguageCode);
  }

  @action
  void setNotification(bool val) {
    isNotificationOn = val;

    setValue(IS_NOTIFICATION_ON, val);

    if (isMobile) {
      OneSignal.shared.disablePush(!val);
    }
  }
}
