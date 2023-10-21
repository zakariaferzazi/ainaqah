import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import '/../AppLocalizations.dart';
import '/../main.dart';
import '/../models/CartModel.dart';
import '/../models/ProductDetailResponse.dart';
import '/../models/ProductResponse.dart';
import '/../models/WishListResponse.dart';
import '/../screen/DashBoardScreen.dart';
import '/../screen/MyCartScreen.dart';
import '/../screen/SignInScreen.dart';
import '/../utils/SharedPref.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../network/rest_apis.dart';
import '../service/LoginService.dart';
import 'Constants.dart';
import 'AppImages.dart';

String convertDate(date) {
  try {
    return date != null ? DateFormat(orderDateFormat).format(DateTime.parse(date)) : '';
  } catch (e) {
    log(e);
    return '';
  }
}

String createDateFormat(date) {
  try {
    return date != null ? DateFormat(CreateDateFormat).format(DateTime.parse(date)) : '';
  } catch (e) {
    log(e);
    return '';
  }
}

String reviewConvertDate(date) {
  try {
    return date != null ? DateFormat(reviewDateFormat).format(DateTime.parse(date)) : '';
  } catch (e) {
    log(e);
    return '';
  }
}

void redirectUrl(url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    toast('Please check URL');
    throw 'Could not launch $url';
  }
}

Future<bool> checkLogin(context) async {
  if (!await isLoggedIn()) {
    SignInScreen().launch(context);
    return false;
  } else {
    return true;
  }
}

Future logout(BuildContext context) async {
  return showConfirmDialogCustom(context,
      title: AppLocalizations.of(context)!.translate('lbl_logout'),
      positiveText: AppLocalizations.of(context)!.translate('lbl_yes'),
      primaryColor: primaryColor,
      negativeText: AppLocalizations.of(context)!.translate('lbl_cancel'), onAccept: (context) {
    setLogoutData(context);
  });
}

Future deleteAccount(BuildContext context) async {
  return showConfirmDialogCustom(context,
      title: AppLocalizations.of(context)!.translate('delete_account_msg'),
      positiveText: AppLocalizations.of(context)!.translate('lbl_yes'),
      primaryColor: primaryColor,
      negativeText: AppLocalizations.of(context)!.translate('lbl_cancel'), onAccept: (con) async {
    await deleteAccountApi().then((value) async {
      await LoginService().deleteUser().then((value) {
        setLogoutData(context);
      });
    });
  });
}

Future<void> setLogoutData(BuildContext context) async {
  if (getBoolAsync(IS_LOGGED_IN) == true) {
    var primaryColor = getStringAsync(THEME_COLOR);
    await setValue(THEME_COLOR, primaryColor);

    await removeKey(PROFILE_IMAGE);
    await removeKey(BILLING);
    await removeKey(SHIPPING);
    await removeKey(USERNAME);
    if (getBoolAsync(IS_SOCIAL_LOGIN) || !getBoolAsync(IS_REMEMBERED)) {
      await removeKey(PASSWORD);
      await removeKey(USER_EMAIL);
    }
    await removeKey(FIRST_NAME);
    await removeKey(LAST_NAME);
    await removeKey(TOKEN);
    await removeKey(USER_DISPLAY_NAME);
    await removeKey(USER_ID);
    await removeKey(AVATAR);
    await removeKey(COUNTRIES);
    await removeKey(CART_DATA);
    await removeKey(WISH_LIST_DATA);
    await removeKey(GUEST_USER_DATA);
    await removeKey(CARTCOUNT);
    await removeKey(DEFAULT_CURRENCY);
    await removeKey(CURRENCY_CODE);
    await removeKey(PLAYER_ID);
    await setValue(IS_GUEST_USER, false);
    await setValue(IS_LOGGED_IN, false);
    await setValue(IS_SOCIAL_LOGIN, false);
    await wishListStore.clearWishlist();
    await cartStore.clearCart();
    appStore.setCount(0);
    appStore.setBottomNavigationIndex(0);
    await DashBoardScreen().launch(context, isNewTask: true);
  }
}

checkLoggedIn(context) async {
  var pref = await getSharedPref();
  if (pref.getBool(IS_LOGGED_IN) != null && pref.getBool(IS_LOGGED_IN)!) {
    MyCartScreen(isShowBack: true).launch(context);
  } else {
    SignInScreen().launch(context);
  }
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

String durationFormatter(int milliSeconds) {
  int seconds = milliSeconds ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  var minutes = seconds ~/ 60;
  seconds = seconds % 60;
  final hoursString = hours >= 10
      ? '$hours'
      : hours == 0
          ? '00'
          : '0$hours';
  final minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
          ? '00'
          : '0$minutes';
  final secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
          ? '00'
          : '0$seconds';
  final formattedTime = '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';
  return formattedTime;
}

Future<String> getProductIdFromNative() async {
  const platform = const MethodChannel('getIdChannel');
  if (isMobile) {
    String? productId = await platform.invokeMethod('p');
    return productId.validate();
  } else {
    return '';
  }
}

Future<void> setDynamicStatusBarColor({Color? color, int milliseconds = 100}) async {
  if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: 1) == 1) {
    setStatusBarColor(color ?? primaryColor! /*, statusBarIconBrightness: Brightness.light*/, delayInMilliSeconds: milliseconds);
  } else if (getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: 1) == 2 || getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: 1) == 3) {
    setStatusBarColor(color ?? primaryColor! /*, statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark*/, delayInMilliSeconds: milliseconds);
  }
}

Future<void> setupRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: Duration.zero,
    minimumFetchInterval: Duration.zero,
  ));
  await remoteConfig.setDefaults(<String, dynamic>{
    HALLOWEEN_ENABLE: false,
  });
  bool res = await remoteConfig.fetchAndActivate();

  if (res) {
    await setValue(HALLOWEEN_ENABLE, remoteConfig.getBool(HALLOWEEN_ENABLE));
  }
}

class MyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(shape: BoxShape.circle), alignment: Alignment.center, child: Image.asset(app_logo, height: 30, width: 30));
  }
}

void addItemToWishlist({ProductResponse? data, ProductDetailResponse? mDetailResponse}) {
  WishListResponse mWishListModel = WishListResponse();
  var mList = <String>[];
  if (mDetailResponse != null) {
    mDetailResponse.images.forEachIndexed((element, index) {
      mList.add(element.src!);
    });
    mWishListModel.name = mDetailResponse.name;
    mWishListModel.proId = mDetailResponse.id;
    mWishListModel.salePrice = mDetailResponse.salePrice;
    mWishListModel.regularPrice = mDetailResponse.regularPrice;
    mWishListModel.price = mDetailResponse.price;
    mWishListModel.gallery = mList;
    mWishListModel.stockQuantity = 1;
    mWishListModel.thumbnail = "";
    mWishListModel.full = mDetailResponse.images![0].src;
    mWishListModel.sku = "";
    mWishListModel.createdAt = "";
  } else {
    data!.images.forEachIndexed((element, index) {
      mList.add(element.src!);
    });
    mWishListModel.name = data.name;
    mWishListModel.proId = data.id;
    mWishListModel.salePrice = data.salePrice;
    mWishListModel.regularPrice = data.regularPrice;
    mWishListModel.price = data.price;
    mWishListModel.gallery = mList;
    mWishListModel.stockQuantity = 1;
    mWishListModel.thumbnail = "";
    mWishListModel.full = data.images![0].src;
    mWishListModel.sku = "";
    mWishListModel.createdAt = "";
  }
  wishListStore.addToWishList(mWishListModel);
}

void checkWishList(ProductDetailResponse? mDetailResponse, context) async {
  if (!await isLoggedIn())
    SignInScreen().launch(context);
  else if (!await isGuestUser() && await isLoggedIn()) {
    addItemToWishlist(mDetailResponse: mDetailResponse!);
  } else {
    print("IsInWish" + wishListStore.isItemInWishlist(mDetailResponse!.id!).toString());
    List<String> mList = [];
    mDetailResponse.images.forEachIndexed((element, index) {
      mList.add(element.src!);
    });
    WishListResponse mWishListModel = WishListResponse();
    mWishListModel.name = mDetailResponse.name;
    mWishListModel.proId = mDetailResponse.id;
    mWishListModel.salePrice = mDetailResponse.salePrice;
    mWishListModel.regularPrice = mDetailResponse.regularPrice;
    mWishListModel.price = mDetailResponse.price;
    mWishListModel.gallery = mList;
    mWishListModel.stockQuantity = 1;
    mWishListModel.thumbnail = "";
    mWishListModel.full = mDetailResponse.images![0].src;
    mWishListModel.sku = "";
    mWishListModel.createdAt = "";
    if (wishListStore.isItemInWishlist(mDetailResponse.id!)) {
      wishListStore.addToWishList(mWishListModel);
    } else {
      wishListStore.addToWishList(mWishListModel);
    }
  }
}

Future<void> addCart({ProductDetailResponse? data, WishListResponse? mData}) async {
  CartModel mCartModel = CartModel();
  if (data != null) {
    var proID = data.id;
    log("proID$proID");
    List<String?> mList = [];
    data.images.forEachIndexed((element, index) {
      mList.add(element.src);
    });

    mCartModel.name = data.name;
    mCartModel.proId = proID.toString().isEmptyOrNull ? data.id : proID;
    mCartModel.onSale = data.onSale;
    mCartModel.salePrice = data.salePrice;
    mCartModel.regularPrice = data.regularPrice;
    mCartModel.price = data.price;
    mCartModel.gallery = mList;
    mCartModel.quantity = "1";
    mCartModel.stockQuantity = "1";
    mCartModel.stockStatus = "";
    mCartModel.thumbnail = "";
    mCartModel.full = data.images![0].src;
    mCartModel.cartId = data.id;
    mCartModel.sku = "";
    mCartModel.createdAt = "";
    if (cartStore.isItemInCart(data.id.validate())) {
      cartStore.addToMyCart(mCartModel);
    } else {
      cartStore.addToMyCart(mCartModel);
      appStore.increment();
    }
  } else {
    mCartModel.name = mData!.name;
    mCartModel.proId = mData.proId;
    mCartModel.salePrice = mData.salePrice;
    mCartModel.regularPrice = mData.regularPrice;
    mCartModel.price = mData.price;
    mCartModel.gallery = mData.gallery;
    mCartModel.quantity = "1";
    mCartModel.stockQuantity = "1";
    mCartModel.stockStatus = "";
    mCartModel.thumbnail = "";
    mCartModel.full = mData.full;
    mCartModel.sku = "";
    mCartModel.createdAt = "";
    if (mData.salePrice!.isNotEmpty) {
      mCartModel.onSale = true;
    } else {
      mCartModel.onSale = false;
    }
    if (cartStore.isItemInCart(mData.proId.validate())) {
      cartStore.addToMyCart(mCartModel);
      wishListStore.addToWishList(mData);
    } else {
      appStore.increment();
      cartStore.addToMyCart(mCartModel);
      wishListStore.addToWishList(mData);
    }
  }
/*
  var proID = mData!.proId;
    log("proID$proID");
    List<String?> mList = [];
    mData.gallery.forEachIndexed((element, index) {
      mList.add(element);
    });

    mCartModel.name = mData.name;
    mCartModel.proId = proID.toString().isEmptyOrNull ? mData.proId : proID;
    mCartModel.onSale = mData.salePrice;
    mCartModel.salePrice = mData.salePrice;
    mCartModel.regularPrice = mData.regularPrice;
    mCartModel.price = mData.price;
    mCartModel.gallery = mList;
    mCartModel.quantity = "1";
    mCartModel.stockQuantity = "1";
    mCartModel.stockStatus = "";
    mCartModel.thumbnail = "";
    mCartModel.full = mData.gallery;
    mCartModel.cartId = mData.proId;
    mCartModel.sku = "";
    mCartModel.createdAt = "";
    if (cartStore.isItemInCart(mData.proId.validate())) {
      appStore.decrement();
      cartStore.addToMyCart(mCartModel);
    } else {
      appStore.increment();
      cartStore.addToMyCart(mCartModel);
    }
  }*/
}

/*void checkCart({int? proID, ProductDetailResponse? data, context}) async {
  if (!await isGuestUser()) {
    if (cartStore.isItemInCart(data!.id.validate())) {
      //addCart(data);
    } else {
      //addCart(data);
    }
  } else {
    List<String?> mList = [];
    data!.images.forEachIndexed((element, index) {
      mList.add(element.src);
    });
    CartModel mCartModel = CartModel();
    mCartModel.name = data.name;
    mCartModel.proId = proID.toString().isEmptyOrNull ? data.id : proID;
    mCartModel.onSale = data.onSale;
    mCartModel.salePrice = data.salePrice;
    mCartModel.regularPrice = data.regularPrice;
    mCartModel.price = data.price;
    mCartModel.gallery = mList;
    mCartModel.quantity = "1";
    mCartModel.stockQuantity = "1";
    mCartModel.stockStatus = "";
    mCartModel.thumbnail = "";
    mCartModel.full = data.images![0].src;
    mCartModel.cartId = data.id;
    mCartModel.sku = "";
    mCartModel.createdAt = "";
    if (cartStore.isItemInCart(data.id.validate())) {
      appStore.decrement();
      //toast(appLocalization!.translate('msg_remove_cart'));
      //appStore.removeFromCartList(mCartModel);
      cartStore.addToMyCart(mCartModel);
    } else {
      appStore.increment();
      //toast(appLocalization!.translate('msg_add_cart'));
      //appStore.addToCartList(mCartModel);

      cartStore.addToMyCart(mCartModel);
    }
  }
}*/
