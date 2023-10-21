import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '/../AppLocalizations.dart';
import '/../main.dart';
import '/../models/ExampleModel.dart';
import '/../utils/AppBarWidget.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class ChooseDemo extends StatefulWidget {
  static String tag = '/ChooseDemo';

  @override
  ChooseDemoState createState() => ChooseDemoState();
}

class ChooseDemoState extends State<ChooseDemo> {
  bool mIsLoggedIn = false;

  int i = 0;

  String mAppUrl = "";
  String mConsumerKey = "";
  String mConsumerSecret = "";
  String mPrimaryColor = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
    setState(() {
      mIsLoggedIn = getBoolAsync(IS_LOGGED_IN);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: mTop(context, appLocalization.translate('lbl_multiple_demo'), showBack: true, actions: [
        IconButton(
            icon: Icon(Icons.check, color: Colors.white),
            onPressed: () async {
              if (mPrimaryColor.isEmpty) {
                mExampleList.forEachIndexed((element, index) async {
                  if (index == getIntAsync(DETAIL_PAGE_VARIANT)) {
                    mAppUrl = mExampleList[index].url;
                    mConsumerKey = mExampleList[index].consumerKey;
                    mConsumerSecret = mExampleList[index].consumerSecret;
                    mPrimaryColor = mExampleList[index].primaryColor;
                    await setValue(APP_URL, mAppUrl);
                    await setValue(CONSUMER_KEY, mConsumerKey);
                    await setValue(CONSUMER_SECRET, mConsumerSecret);
                    await setValue(PRIMARY_COLOR, mPrimaryColor);
                  }
                });
              } else {
                await setValue(APP_URL, mAppUrl);
                await setValue(CONSUMER_KEY, mConsumerKey);
                await setValue(CONSUMER_SECRET, mConsumerSecret);
                await setValue(PRIMARY_COLOR, mPrimaryColor);
              }
              logout(context);
              setState(() {
                if (primaryColor != null) {
                  primaryColor = getColorFromHex(mPrimaryColor, defaultColor: appColorPrimary);
                } else {
                  primaryColor = getColorFromHex(getStringAsync(PRIMARY_COLOR), defaultColor: appColorPrimary);
                }
              });
            })
      ]) as PreferredSizeWidget?,
      body: BodyCornerWidget(
        child: AlignedGridView.count(
          scrollDirection: Axis.vertical,
          itemCount: mExampleList.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 8, right: 8,bottom: 8),
          itemBuilder: (context, i) {
            return itemWidget(
                code: i,
                title: mExampleList[i].title,
                img: mExampleList[i].img,
                onTap: () async {
                  setValue(DETAIL_PAGE_VARIANT, i);
                  i = i;
                  mAppUrl = mExampleList[i].url;
                  mConsumerKey = mExampleList[i].consumerKey;
                  mConsumerSecret = mExampleList[i].consumerSecret;
                  mPrimaryColor = mExampleList[i].primaryColor;
                  setState(() {});
                });
          },
          crossAxisCount: 2,

        ),
      ),
    );
  }

  Widget itemWidget({required Function onTap, String? title, int code = 0, required String img}) {
    return Container(
      width: context.width(),
      height: context.height() * 0.4,
      margin: EdgeInsets.all(8),
      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            img,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            height: 50,
          ).cornerRadiusWithClipRRect(10),
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            color: getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 0) == code ? Colors.black12 : Colors.black45,
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            child: Text(title.validate(), style: boldTextStyle(color: textPrimaryColor), textAlign: TextAlign.center),
            decoration: BoxDecoration(color: getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 0) == code ? Colors.white : Colors.white54, borderRadius: radius(defaultRadius)),
            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          ).center(),
          Positioned(
            bottom: 8,
            right: 8,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 800),
              padding: EdgeInsets.all(4),
              child: Icon(Icons.check, size: 18, color: primaryColor),
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: defaultBoxShadow()),
            ).visible(getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 0) == code),
          ),
        ],
      ),
    ).onTap(() async {
      onTap.call();
    });
  }
}
