import 'package:flutter/material.dart';
import '/../screen/DashBoardScreen.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';

class OrderListEmptyComponent extends StatelessWidget {
  const OrderListEmptyComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(ic_order, height: 110, width: 110, color: primaryColor),
        20.height,
        Text(appLocalization.translate("msg_empty_order")!, style: primaryTextStyle(size: 22), textAlign: TextAlign.center).paddingOnly(left: 20, right: 20),
        4.height,
        Text(appLocalization.translate("msg_info_empty_order")!, style: secondaryTextStyle(size: 16), textAlign: TextAlign.center).paddingOnly(left: 20, right: 20),
        30.height,
        AppButton(
            width: context.width(),
            textStyle: primaryTextStyle(color: white),
            text: appLocalization.translate('lbl_start_shopping'),
            color: primaryColor,
            onTap: () {
              DashBoardScreen().launch(context);
            }).paddingOnly(left: 20, right: 20),
      ],
    );
  }
}
