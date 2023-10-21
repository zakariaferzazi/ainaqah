import 'dart:convert';
import 'package:flutter/material.dart';
import '/../main.dart';
import '/../models/Coupon_lines.dart';
import '/../models/OrderModel.dart';
import '/../models/OrderTracking.dart';
import '/../models/TrackingResponse.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppBarWidget.dart';
import '/../screen/WebViewExternalProductScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import '/../utils/DashedRectangle.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import 'ProductDetail/ProductDetailScreen1.dart';
import 'ProductDetail/ProductDetailScreen2.dart';
import 'ProductDetail/ProductDetailScreen3.dart';

class OrderDetailScreen extends StatefulWidget {
  static String tag = '/OrderDetailScreen';
  final OrderResponse? mOrderModel;

  OrderDetailScreen({this.mOrderModel});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List<OrderResponse> mOrderModel = [];
  List<OrderTracking> mOrderTrackingModel = [];
  List<TrackingResponse> mGetTrackingModel = [];
  final List<String> mCancelList = [
    'Product is being delivered to a wrong address',
    'Product is not required anymore',
    'Cheaper alternative available for lesser price',
    'The price of the product has fallen due to sales/discounts and customer wants to get it at a lesser price.',
    'Bad review from friends/relatives after ordering the product.',
    'Order placed by mistake',
  ].toList();

  String? mValue;
  String? value = "";

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  init() async {
    mValue = mCancelList.first;
    fetchTrackingData();
    getTracking();
    if (widget.mOrderModel!.metaData != null) {
      widget.mOrderModel!.metaData!.forEach((element) {
        if (element.key == "delivery_date") {
          value = element.value;
          log("element:- $value");
        }
      });
    } else {
      value = "";
    }
    log('Order Detail' + widget.mOrderModel!.toJson().toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future fetchTrackingData() async {
    appStore.setLoading(true);
    await getOrdersTracking(widget.mOrderModel!.id).then((res) {
      if (!mounted) return;
      appStore.setLoading(false);
      setState(() {
        Iterable mCategory = res;
        mOrderTrackingModel =
            mCategory.map((model) => OrderTracking.fromJson(model)).toList();
      });
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  Future getTracking() async {
    appStore.setLoading(true);
    await getTrackingInfo(widget.mOrderModel!.id).then((res) {
      if (!mounted) return;
      appStore.setLoading(false);
      setState(() {
        Iterable mTracking = res;
        mGetTrackingModel =
            mTracking.map((model) => TrackingResponse.fromJson(model)).toList();
      });
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  void cancelOrderData(String? mValue) async {
    appStore.setLoading(true);
    var request = {
      "status": "cancelled",
      "customer_note": mValue,
    };
    await cancelOrder(widget.mOrderModel!.id, request).then((res) {
      if (!mounted) return;
      setState(() {
        var request = {
          'customer_note': true,
          'note': "{\n" +
              "\"status\":\"Cancelled\",\n" +
              "\"message\":\"Order Canceled by you due to " +
              mValue! +
              ".\"\n" +
              "} ",
        };
        createOrderNotes(widget.mOrderModel!.id, request).then((res) {
          if (!mounted) return;
          appStore.setLoading(false);
          finish(context, true);
        }).catchError((error) {
          appStore.setLoading(false);
          finish(context, true);
          toast(error.toString());
        });
      });
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
      toast(error.toString());
      finish(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    Widget mData(OrderTracking orderTracking) {
      Tracking tracking;
      try {
        var x = jsonDecode(orderTracking.note!) as Map<String, dynamic>;
        tracking = Tracking.fromJson(x);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Text(tracking.status.validate(), style: boldTextStyle()), Text(tracking.message.validate(), style: secondaryTextStyle())],
        );
      } on FormatException catch (e) {
         var status = "Processing";
        Color color = Colors.grey;
        if (orderTracking.note!.contains("to Completed")){
          status = "Completed";
          color = Colors.orange;
        }
        if (orderTracking.note!.contains("tracking number")) {
          status = "Shipped";
          color = Colors.green;
        }
        if (orderTracking.note!.contains("to Processing")) {
          status = "Pending";
          color = Colors.purple;
        }
        if (orderTracking.note!.contains("Cancelled")) {
          status = "Cancelled";
          color = Colors.red;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(status, style: boldTextStyle(color: color)),
            Text(orderTracking.note.validate(),
                style: secondaryTextStyle())
          ],
        );
      }
    }

    Widget mTracking() {
      return AnimatedListView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: mOrderTrackingModel.length,
        itemBuilder: (context, i) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: primaryColor, borderRadius: radius(16)),
                  ),
                  SizedBox(
                      height: 100,
                      child: DashedRectangle(gap: 2, color: primaryColor)),
                ],
              ),
              8.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    mData(mOrderTrackingModel[i]),
                    8.height,
                    Text(
                        convertDate(
                            mOrderTrackingModel[i].dateCreated.validate()),
                        style: secondaryTextStyle()),
                  ],
                ),
              )
            ],
          );
        },
      );
    }

    Widget mCancelOrder() {
      if (widget.mOrderModel!.status == COMPLETED ||
          widget.mOrderModel!.status == REFUNDED ||
          widget.mOrderModel!.status == CANCELED ||
          widget.mOrderModel!.status == TRASH ||
          widget.mOrderModel!.status == FAILED) {
        return SizedBox();
      } else {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      backgroundColor: Theme.of(context).cardTheme.color,
                      title: Text(
                          appLocalization.translate('title_cancel_order')!,
                          style: boldTextStyle()),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          16.height,
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(6),
                            decoration: boxDecorationWithRoundedCorners(
                                borderRadius: radius(8),
                                backgroundColor:
                                    Theme.of(context).colorScheme.background),
                            child: SingleChildScrollView(
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                    canvasColor:
                                        Theme.of(context).cardTheme.color),
                                child: DropdownButton<String>(
                                  value: mValue,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      mValue = newValue;
                                    });
                                  },
                                  items: mCancelList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: primaryTextStyle()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          20.height,
                          AppButton(
                              width: context.width(),
                              textStyle: primaryTextStyle(color: white),
                              text:
                                  appLocalization.translate('lbl_cancel_order'),
                              color: primaryColor,
                              onTap: () {
                                finish(context);
                                appStore.setLoading(true);
                                cancelOrderData(mValue);
                              }),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLocalization.translate('lbl_cancel_order')!,
                    style: primaryTextStyle(color: primaryColor)),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        );
      }
    }

    Widget mBody(BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            16.height,
            commonCacheImageWidget(
                    widget.mOrderModel!.lineItems![0].productImages![0].src,
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(16)
                .center(),
            Text(widget.mOrderModel!.lineItems![0].name!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: boldTextStyle())
                .center()
                .paddingOnly(left: 20, right: 20, top: 10, bottom: 10),
            Container(
              width: context.width(),
              decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(8),
                  backgroundColor: Theme.of(context).colorScheme.background),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.mOrderModel!.status.toUpperCase(),
                      style: boldTextStyle(color: primaryColor)),
                  4.height,
                  Text(
                          appLocalization.translate('lbl_deliver_on')! +
                              " " +
                              createDateFormat(value),
                          style: secondaryTextStyle())
                      .visible(value!.isNotEmpty)
                ],
              ).paddingAll(16),
            ).paddingOnly(left: 16, bottom: 16, right: 16),
            GestureDetector(
              onTap: () {
                WebViewExternalProductScreen(
                        mExternal_URL: mGetTrackingModel[0].trackingLink,
                        title: "Track your order")
                    .launch(context);
              },
              child: Container(
                width: context.width(),
                decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(8),
                    backgroundColor: Theme.of(context).colorScheme.background),
                child: Text(appLocalization.translate('lbl_tracking')!,
                        style: boldTextStyle(color: primaryColor))
                    .paddingAll(16)
                    .center(),
              ).paddingOnly(left: 16, bottom: 16, right: 16).visible(
                  mGetTrackingModel.isNotEmpty &&
                      (widget.mOrderModel!.status == "pending" ||
                          widget.mOrderModel!.status == "processing" ||
                          widget.mOrderModel!.status == "on-hold")),
            ),
            Divider(
                thickness: 6,
                color: Theme.of(context).textTheme.headlineMedium!.color),
            Container(
              width: context.width(),
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  8.height,
                  Text(appLocalization.translate('lbl_delivery_address')!,
                      style: boldTextStyle(size: 16)),
                  10.height,
                  Text(
                      widget.mOrderModel!.shipping!.firstName! +
                          " " +
                          widget.mOrderModel!.shipping!.lastName!,
                      style: boldTextStyle(size: 14)),
                  2.height,
                  Text(
                    widget.mOrderModel!.shipping!.address1! +
                        " " +
                        widget.mOrderModel!.shipping!.city! +
                        " " +
                        widget.mOrderModel!.shipping!.country! +
                        " " +
                        widget.mOrderModel!.shipping!.state!,
                    style: secondaryTextStyle(size: 14),
                  ),
                  4.height,
                ],
              ),
            ),
            Divider(
                    thickness: 6,
                    color: Theme.of(context).textTheme.headlineMedium!.color)
                .visible(mOrderTrackingModel.isNotEmpty),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                children: [
                  mTracking(),
                  mCancelOrder(),
                ],
              ),
            ).visible(mOrderTrackingModel.isNotEmpty),
            Divider(
                    thickness: 6,
                    color: Theme.of(context).textTheme.headlineMedium!.color)
                .visible(widget.mOrderModel!.lineItems!.length > 1),
            Container(
              width: context.width(),
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  8.height,
                  Text(appLocalization.translate('lbl_other_item_in_cart')!,
                      style: boldTextStyle(size: 18)),
                  Text(
                      appLocalization.translate('lbl_order_id')! +
                          widget.mOrderModel!.id.toString(),
                      style: secondaryTextStyle()),
                  16.height,
                  AnimatedListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.mOrderModel!.lineItems!.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          if (getIntAsync(PRODUCT_DETAIL_VARIANT,
                                  defaultValue: 1) ==
                              1) {
                            ProductDetailScreen1(
                                    mProId: widget
                                        .mOrderModel!.lineItems![0].productId)
                                .launch(context);
                          } else if (getIntAsync(PRODUCT_DETAIL_VARIANT,
                                  defaultValue: 1) ==
                              2) {
                            ProductDetailScreen2(
                                    mProId: widget
                                        .mOrderModel!.lineItems![0].productId)
                                .launch(context);
                          } else if (getIntAsync(PRODUCT_DETAIL_VARIANT,
                                  defaultValue: 1) ==
                              3) {
                            ProductDetailScreen3(
                                    mProId: widget
                                        .mOrderModel!.lineItems![0].productId)
                                .launch(context);
                          } else {
                            ProductDetailScreen1(
                                    mProId: widget
                                        .mOrderModel!.lineItems![0].productId)
                                .launch(context);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonCacheImageWidget(
                                      widget.mOrderModel!.lineItems![i]
                                          .productImages![0].src
                                          .validate(),
                                      height: 85,
                                      width: 85,
                                      fit: BoxFit.cover)
                                  .cornerRadiusWithClipRRect(8),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        widget.mOrderModel!.lineItems![i].name!,
                                        style: primaryTextStyle(),
                                        maxLines: 2),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        PriceWidget(
                                            price: widget.mOrderModel!
                                                .lineItems![i].total
                                                .toString(),
                                            size: 18.toDouble()),
                                        4.width,
                                        Text(
                                            appLocalization
                                                    .translate('lbl_qty')! +
                                                " " +
                                                widget.mOrderModel!
                                                    .lineItems![i].quantity
                                                    .toString(),
                                            style: primaryTextStyle()),
                                      ],
                                    )
                                  ],
                                ).paddingOnly(left: 16, right: 16, top: 4),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ).visible(widget.mOrderModel!.lineItems!.length > 1),
            Divider(
                thickness: 6,
                color: Theme.of(context).textTheme.headlineMedium!.color),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLocalization.translate('lbl_Shipping')!,
                    style: secondaryTextStyle(size: 16)),
                Text(
                    widget.mOrderModel!.shippingTotal.toString().toInt() != 0
                        ? getStringAsync(DEFAULT_CURRENCY) +
                            widget.mOrderModel!.shippingTotal
                        : "Free",
                    style: primaryTextStyle()),
              ],
            ).paddingSymmetric(horizontal: 16),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLocalization.translate("lbl_payment_methods")!,
                    style: boldTextStyle()),
                Text(
                    widget.mOrderModel!.paymentMethod
                        .toString()
                        .capitalizeFirstLetter(),
                    style: primaryTextStyle()),
              ],
            ).paddingSymmetric(horizontal: 16, vertical: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLocalization.translate("lbl_total_order_price")!,
                    style: boldTextStyle()),
                PriceWidget(price: widget.mOrderModel!.total, size: 16),
              ],
            ).paddingSymmetric(horizontal: 16, vertical: 8),
            RichTextWidget(
              list: [
                TextSpan(
                    text: appLocalization.translate('lbl_you_saved')! + " ",
                    style: secondaryTextStyle()),
                TextSpan(
                    text: widget.mOrderModel!.discountTotal,
                    style: boldTextStyle(color: context.accentColor)),
                TextSpan(
                    text: " " + appLocalization.translate('lbl_on_this_order')!,
                    style: secondaryTextStyle()),
              ],
            )
                .paddingSymmetric(horizontal: 8)
                .visible(int.parse(widget.mOrderModel!.discountTotal) > 0),
            Divider(
                thickness: 6,
                color: Theme.of(context).textTheme.headlineMedium!.color),
            Container(
              width: context.width(),
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.height,
                  Text(appLocalization.translate('lbl_update_sent_to')!,
                      style: boldTextStyle(size: 18)),
                  10.height,
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.call,
                                  size: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .color)
                              .paddingRight(10),
                        ),
                        TextSpan(
                            text: widget.mOrderModel!.billing!.phone,
                            style: secondaryTextStyle()),
                      ],
                    ),
                  ),
                  8.height,
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                            child: Icon(Icons.email,
                                    size: 16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .color)
                                .paddingRight(10)),
                        TextSpan(
                            text: widget.mOrderModel!.billing!.email,
                            style: secondaryTextStyle()),
                      ],
                    ),
                  ),
                  16.height
                ],
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: mTop(context, appLocalization.translate('lbl_order_details'),
          showBack: true) as PreferredSizeWidget?,
      body: BodyCornerWidget(
        child: Stack(
          children: [
            mBody(context),
            mProgress().center().visible(appStore.isLoading),
          ],
        ),
      ),
    );
  }
}
