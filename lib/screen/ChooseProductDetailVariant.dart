import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '/../AppLocalizations.dart';
import '/../utils/AppBarWidget.dart';
import '/../screen/DashBoardScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ChooseProductDetailVariant extends StatefulWidget {
  static String tag = '/ChooseDashboardScreen';

  @override
  ChooseProductDetailVariantState createState() => ChooseProductDetailVariantState();
}

class ChooseProductDetailVariantState extends State<ChooseProductDetailVariant> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setDynamicStatusBarColor();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return SafeArea(
      top: !isIOS ? true : false,
      child: Scaffold(
        appBar: mTop(
          context,
          appLocalization.translate('choose_product_detail_page_variant')!,
          showBack: true,
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 8),
              onPressed: () {
                appStore.setBottomNavigationIndex(0);
                DashBoardScreen().launch(context, isNewTask: true);
              },
              icon: Icon(Ionicons.ios_home_outline, size: 24,color: white),
            ),
          ],
        ) as PreferredSizeWidget?,
        body: BodyCornerWidget(
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 8,
              spacing: 8,
              children: [
                itemWidget(
                  title: '${appLocalization.translate('variant')} 1',
                  code: 1,
                  onTap: () async {
                    await setValue(PRODUCT_DETAIL_VARIANT, 1);
                    setState(() {});
                  },
                ),
                itemWidget(
                  title: '${appLocalization.translate('variant')} 2',
                  code: 2,
                  onTap: () async {
                    await setValue(PRODUCT_DETAIL_VARIANT, 2);
                    setState(() {});
                  },
                ),
                itemWidget(
                  title: '${appLocalization.translate('variant')} 3',
                  code: 3,
                  onTap: () async {
                    await setValue(PRODUCT_DETAIL_VARIANT, 3);
                    setState(() {});
                  },
                ),
              ],
            ).center().paddingTop(8),
          ),
        ),
      ),
    );
  }

  Widget itemWidget({required Function onTap, String? title, int code = 1, String? img}) {
    return Container(
      width: context.width() * 0.46,
      height: context.height() * 0.4,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        borderRadius: radius(8),
        border: Border.all(color: getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == code ? primaryColor! : Theme
            .of(context)
            .dividerColor),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/mightystore/productDetail_$code.jpg', fit: BoxFit.cover, alignment: Alignment.topCenter).cornerRadiusWithClipRRect(8),
          AnimatedContainer(duration: Duration(milliseconds: 800), color: getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == code ? transparentColor : Colors.black45)
              .cornerRadiusWithClipRRect(8),
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            child: Text(title.validate(), style: boldTextStyle(color: getIntAsync(DASHBOARD_PAGE_VARIANT, defaultValue: 1) == code ? white : textPrimaryColor)),
            decoration: BoxDecoration(color: getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == code ? Colors.black.withOpacity(0.5) : Colors.grey, borderRadius: radius(defaultRadius)),
            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          ).center(),
          Positioned(
            bottom: 8,
            right: 8,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 800),
              padding: EdgeInsets.all(4),
              child: Icon(Icons.check, size: 18, color: white),
              decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle, boxShadow: defaultBoxShadow()),
            ).visible(getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == code),
          ),
        ],
      ),
    ).onTap(
          () {
        onTap.call();
        setDynamicStatusBarColor();
      },
    );
  }
}
