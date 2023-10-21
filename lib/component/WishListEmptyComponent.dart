import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '/../screen/DashBoardScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import '../AppLocalizations.dart';
import '../main.dart';

class WishListEmptyComponent extends StatefulWidget {
  static String tag = '/WishListEmptyComponent';

  @override
  WishListEmptyComponentState createState() => WishListEmptyComponentState();
}

class WishListEmptyComponentState extends State<WishListEmptyComponent> {
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
    var appLocalization = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(MaterialIcons.favorite_outline, color: primaryColor, size: 120),
        20.height,
        Text(appLocalization.translate('lbl_your_wishlist_empty')!, style: boldTextStyle(size: 20), textAlign: TextAlign.center).paddingOnly(left: 20, right: 20),
        8.height,
        Text(appLocalization.translate('lbl_wishlist_empty_msg')!, style: secondaryTextStyle(size: 16), textAlign: TextAlign.center).paddingOnly(left: 20, right: 20),
        30.height,
        AppButton(
                width: context.width(),
                textStyle: primaryTextStyle(color: white),
                text: appLocalization.translate('lbl_start_shopping'),
                onTap: () {
                  DashBoardScreen().launch(context);
                  appStore.setBottomNavigationIndex(0);
                },
                color: primaryColor)
            .paddingOnly(left: 16, right: 16),
      ],
    );
  }
}
