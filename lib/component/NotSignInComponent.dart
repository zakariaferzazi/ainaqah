import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '/../screen/SignInScreen.dart';
import '/../screen/SignUpScreen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';

class WishListNotSignInComponent extends StatefulWidget {
  static String tag = '/WishListNotSignInComponent';
  final bool? isWishlist;

  WishListNotSignInComponent({this.isWishlist});

  @override
  WishListNotSignInComponentState createState() => WishListNotSignInComponentState();
}

class WishListNotSignInComponentState extends State<WishListNotSignInComponent> {
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
        widget.isWishlist == true ? Icon(MaterialIcons.favorite_outline, color: primaryColor, size: 120) : Icon(Icons.shopping_bag_outlined, size: 120, color: primaryColor),
        20.height,
        widget.isWishlist == true
            ? Text(appLocalization.translate("msg_wishlist")!, style: primaryTextStyle(size: 20), textAlign: TextAlign.center).paddingOnly(left: 20, right: 20)
            : Text(appLocalization.translate("msg_empty_basket")!, style: secondaryTextStyle(size: 14), textAlign: TextAlign.center),
        Text(appLocalization.translate("lbl_wishlist_msg")!, style: secondaryTextStyle(size: 16), textAlign: TextAlign.center).paddingOnly(left: 20, right: 20).visible(widget.isWishlist == true),
        30.height,
        AppButton(
                width: context.width(),
                textStyle: primaryTextStyle(color: white),
                text: appLocalization.translate('lbl_sign_in'),
                onTap: () {
                  SignInScreen().launch(context);
                },
                color: primaryColor)
            .paddingOnly(left: 16, right: 16),
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(appLocalization.translate('lbl_dont_t_have_an_account')!, style: primaryTextStyle(size: 18, color: Theme.of(context).textTheme.titleMedium!.color)),
            Container(
              margin: EdgeInsets.only(left: 4),
              child: GestureDetector(
                child: Text(appLocalization.translate('lbl_sign_up_link')!, style: TextStyle(fontSize: 18, color: primaryColor)),
                onTap: () {
                  SignUpScreen().launch(context);
                },
              ),
            )
          ],
        ).paddingAll(16)
      ],
    );
  }
}
