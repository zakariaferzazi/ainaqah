import 'package:flutter/material.dart';
import '/../main.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppBarWidget.dart';
import '/../screen/DashBoardScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Constants.dart';
import '/../utils/AppImages.dart';
import '/../utils/SharedPref.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../utils/Colors.dart';

// ignore: must_be_immutable
class PlaceOrderScreen extends StatefulWidget {
  static String tag = '/PlaceOrderScreen';
  var mOrderID, total, transactionId, orderKey, paymentMethod, dateCreated;

  PlaceOrderScreen({Key? key, this.mOrderID, this.total, this.transactionId, this.orderKey, this.paymentMethod, this.dateCreated}) : super(key: key);

  @override
  PlaceOrderScreenState createState() => PlaceOrderScreenState();
}

class PlaceOrderScreenState extends State<PlaceOrderScreen> {
  DateTime? date = DateTime.now();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    createOrderTracking();
    date = DateTime.parse(widget.dateCreated);
  }

  Future createOrderTracking() async {
    appStore.setLoading(true);
    var request = {
      'customer_note': true,
      'note': "{\n" + "\"status\":\"Ordered\",\n" + "\"message\":\"Your order has been placed.\"\n" + "} ",
    };
    await createOrderNotes(widget.mOrderID, request).then((res) {
      if (!mounted) return;
      appStore.setLoading(false);
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  onComplete() async {
    if (!await isGuestUser()) {
      clearCartItems().then((response) {
        if (!mounted) return;
        cartStore.clearCart();
        setState(() {});
        appStore.setCount(0);
        DashBoardScreen().launch(context, isNewTask: true);
      }).catchError((error) {
        setState(() {});
        toast(error.toString());
      });
    } else {
      appStore.setCount(0);
      cartStore.clearCart();
      DashBoardScreen().launch(context, isNewTask: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
            elevation: 0,
            backgroundColor: isHalloween ? mChristmasColor : primaryColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: white),
              onPressed: () async {
                onComplete();
              },
            ),
            automaticallyImplyLeading: false),
      ),
      body: BodyCornerWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            Image.asset(Selected_icon, height: 60, width: 60, color: Color(0xFF66953A), fit: BoxFit.contain).center(),
            16.height,
            Text(appLocalization.translate('lbl_oder_placed_successfully')!, style: boldTextStyle(color: Theme.of(context).colorScheme.secondary, size: 18)).center(),
            16.height,
            Text(appLocalization.translate('lbl_total_amount_')!, style: secondaryTextStyle()),
            4.height,
            PriceWidget(price: widget.total, size: 18),
            Text(appLocalization.translate('lbl_transaction_id')!, style: secondaryTextStyle()).paddingTop(16).visible(widget.transactionId.toString().isNotEmpty),
            Text(widget.transactionId, style: boldTextStyle(size: 18)).paddingTop(4).visible(widget.transactionId.toString().isNotEmpty),
            Text(appLocalization.translate('order_id')!, style: secondaryTextStyle()).paddingTop(16),
            Text(widget.orderKey, style: boldTextStyle(size: 18)).paddingTop(4),
            Text(appLocalization.translate('lbl_transaction_date')!, style: secondaryTextStyle()).paddingTop(16),
            Text(date.toString(), style: boldTextStyle(size: 18)).paddingTop(4),
            28.height,
            AppButton(
              width: context.width(),
              text: appLocalization.translate('lbl_done'),
              textStyle: primaryTextStyle(color: white),
              color: primaryColor,
              onTap: () async {
                onComplete();
              },
            ),
          ],
        ).paddingOnly(left: 16, right: 16),
      ),
    );
  }
}
