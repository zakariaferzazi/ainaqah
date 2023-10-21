import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '/../component/OrderListComponent.dart';
import '/../main.dart';
import '/../models/OrderModel.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppBarWidget.dart';
import '/../screen/OrderDetailScreen.dart';
import '/../utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import '../component/OrderListEmptyComponent.dart';
import '../AppLocalizations.dart';

class OrderListScreen extends StatefulWidget {
  static String tag = '/OrderList';

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List<OrderResponse> mOrderModel = [];
  String mErrorMsg = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future fetchOrderData() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });

    await getOrders().then((res) {
      if (!mounted) return;
      appStore.setLoading(false);
      Iterable mOrderDetails = res;
      mOrderModel = mOrderDetails.map((model) => OrderResponse.fromJson(model)).toList();
      if (mOrderModel.isEmpty) {
        mErrorMsg = '';
      }
      setState(() {});
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
      mOrderModel.clear();
      mErrorMsg = error.toString();
    });
  }

  init() async {
    fetchOrderData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    Widget mBody = orderListWidget(context, mOrderModel, (i) async {
      bool? isChanged = await OrderDetailScreen(mOrderModel: mOrderModel[i]).launch(context);
      if (isChanged != null) {
        appStore.setLoading(true);
        init();
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: mTop(context, appLocalization.translate('lbl_orders'), showBack: true) as PreferredSizeWidget?,
      body: Observer(
        builder: (context) => BodyCornerWidget(
          child: Stack(
            children: [
              mOrderModel.isNotEmpty ? mBody : OrderListEmptyComponent().visible(!appStore.isLoading && mErrorMsg.isEmpty),
              mProgress().center().visible(appStore.isLoading),
              Text(mErrorMsg, style: primaryTextStyle(), textAlign: TextAlign.center).center().visible(!appStore.isLoading && mErrorMsg.isNotEmpty),
            ],
          ),
        ),
      ),
    );
  }
}
