import 'package:flutter/material.dart';
import '/../models/WalletConfigurationResponse.dart';
import '/../utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';

class AddMoneyComponent extends StatefulWidget {
  static String tag = '/AddMoneyComponent';

  final Function? onCall;
  final WalletConfigurationResponse? mWalletConfigurationResponse;

  AddMoneyComponent({Key? key, this.onCall, this.mWalletConfigurationResponse}) : super(key: key);

  @override
  AddMoneyComponentState createState() => AddMoneyComponentState();
}

class AddMoneyComponentState extends State<AddMoneyComponent> {
  TextEditingController mPriceCont = TextEditingController();
  TextEditingController mDescriptionCont = TextEditingController();

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
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), backgroundColor: context.cardColor),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLocalization.translate('lbl_add_money')!.toUpperCase(), style: boldTextStyle()),
                IconButton(
                  onPressed: () {
                    finish(context, true);
                  },
                  icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color, size: 22),
                )
              ],
            ),
            Divider(height: 0),
            24.height,
            SimpleEditText(
              mController: mPriceCont,
              hintText: appLocalization.translate('lbl_enter_amount')!,
              keyboardType: TextInputType.number,
              validator: (String? v) {
                if (v!.trim().isEmpty) return "error_field_required";
              },
            ),
            AppButton(
                width: context.width(),
                text: appLocalization.translate('lbl_submit')!,
                textStyle: primaryTextStyle(color: white),
                color: primaryColor,
                onTap: () {
                  var min = widget.mWalletConfigurationResponse!.minTopupAmount.toString().toDouble();
                  var max = widget.mWalletConfigurationResponse!.maxTopupAmount.toString().toDouble();
                  var enterAmount = mPriceCont.text.toDouble();
                  if (enterAmount >= min && enterAmount <= max) {
                    finish(context);
                    widget.onCall!.call(mPriceCont.text.toDouble());
                  } else {
                    log(mPriceCont.text.toDouble());
                    toast("You have to add amount between $min to $max");
                  }
                }),
          ],
        ).paddingOnly(left: 16, right: 16, bottom: 16, top: 8),
      ),
    );
  }
}
