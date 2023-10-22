import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:flutterwave_standard/view/view_utils.dart';
import 'package:intl/intl.dart';
import '../utils/AppImages.dart';
import '/../main.dart';
import '/../models/CartModel.dart';
import '/../models/Coupon_lines.dart';
import '/../models/CreateOrderRequestModel.dart';
import '/../models/CustomerResponse.dart';
import '/../models/OrderModel.dart';
import '/../models/PaymentModel.dart';
import '/../models/ShippingMethodResponse.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppBarWidget.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import '/../utils/SharedPref.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../AppLocalizations.dart';
import 'DashBoardScreen.dart';
import 'PlaceOrderScreen.dart';
import 'WebViewPaymentScreen.dart';

class OrderSummaryScreen extends StatefulWidget {
  static String tag = '/OrderSummaryScreen';

  final List<CartModel>? mCartProduct;
  final mCouponData;
  final mPrice;
  final bool isNativePayment = false;
  final ShippingLines? shippingLines;
  final Method? method;
  final double? subtotal;
  final double? mRPDiscount;
  final double? discount;

  OrderSummaryScreen(
      {Key? key,
      this.mCartProduct,
      this.mCouponData,
      this.mPrice,
      this.shippingLines,
      this.method,
      this.subtotal,
      this.mRPDiscount,
      this.discount})
      : super(key: key);

  @override
  OrderSummaryScreenState createState() => OrderSummaryScreenState();
}

class OrderSummaryScreenState extends State<OrderSummaryScreen> {
  final formKey = GlobalKey<FormState>();
  final plugin = PaystackPlugin();
  CheckoutMethod method = CheckoutMethod.card;

  var mOrderModel = OrderResponse();

  late Razorpay _razorPay;
  List<PaymentClass>? paymentList = [];

  Shipping? shipping;
  Billing? billing;

  //Method? method;
  NumberFormat nf = NumberFormat('##.00');
  String? cardNumber;
  String? cvv;
  int? expiryMonth;
  int? expiryYear;

  String? mTotalBalance;

  bool isDisabled = false;
  bool isNativePayment = false;

  var mUserId, mCurrency;

  var mBilling, mShipping;
  var id;
  var isEnableCoupon;

  int? paymentIndex = 0;
  int? currentTimeValue = 0;
  bool? isSelected = false;
  num mAmount = 0;
  num remainAmount = 0;

  @override
  void initState() {
    super.initState();
    addList();
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    init();
  }

  init() async {
    plugin.initialize(publicKey: payStackPublicKey);
    setState(() {});
    fetchTotalBalance();
    if (getStringAsync(PAYMENTMETHOD) == PAYMENT_METHOD_NATIVE) {
      isNativePayment = true;
    } else {
      isNativePayment = false;
    }
    shipping = Shipping.fromJson(jsonDecode(getStringAsync(SHIPPING)));
    billing = Billing.fromJson(jsonDecode(getStringAsync(BILLING)));

    mUserId = getIntAsync(USER_ID);
    mCurrency = getStringAsync(DEFAULT_CURRENCY);
    setState(() {});
  }

  Future fetchTotalBalance() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getBalance().then((res) {
      mTotalBalance = res;
      appStore.setLoading(false);
    }).catchError((error) {
      appStore.setLoading(false);
    });
    paymentCount();
  }

  addList() {
    paymentList!
        .add(PaymentClass(paymentIndex: 0, paymentMethod: 'إيداع إلى محفظة الكريمي', image: karimi, account: "1234567890"));
    paymentList!
        .add(PaymentClass(paymentIndex: 1, paymentMethod: 'إيداع إلى محفظة فلوسك', image: faloosak, account: "1234567890"));
    paymentList!
        .add(PaymentClass(paymentIndex: 2, paymentMethod: 'إيداع إلى محفظة كاش', image: cash, account: "1234567890"));
    paymentList!
        .add(PaymentClass(paymentIndex: 3, paymentMethod: 'إيداع إلى محفظة كاك موبايلي', image: cac, account: "1234567890"));
    paymentList!
        .add(PaymentClass(paymentIndex: 4, paymentMethod: 'إيداع إلى محفظة موبايل موني', image: mobilemoney, account: "1234567890"));
    paymentList!
        .add(PaymentClass(paymentIndex: 5, paymentMethod: 'إيداع إلى محفظة سبأكاش', image: sabaa, account: "1234567890"));
    paymentList!
        .add(PaymentClass(paymentIndex: 6, paymentMethod: 'إيداع إلى محفظة محفظتي', image: mahfadati, account: "1234567890"));
    paymentList!
        .add(PaymentClass(paymentIndex: 7, paymentMethod: 'إيداع إلى محفظة أم فلوس', image: omfolos, account: "1234567890"));
    paymentList!
        .add(PaymentClass(paymentIndex: 8, paymentMethod: 'إيداع إلى محفظة جوالي', image: jawali, account: "1234567890"));
    paymentList!
        .add(PaymentClass(paymentIndex: 9, paymentMethod: 'حوالة عادية عبر أي صراف', image: atm, account: "1234567890"));

    setState(() {});
  }

  void paymentCount() {
    if (isSelected == true) {
      if (widget.mPrice.toString().toDouble() < mTotalBalance.toDouble()) {
        mAmount = widget.mPrice.toString().toDouble();
      } else if (widget.mPrice.toString().toDouble() ==
          mTotalBalance.toDouble()) {
        mAmount = mTotalBalance.toDouble();
      } else {
        mAmount = double.parse(widget.mPrice) - mTotalBalance.toDouble();
      }
    } else {
      mAmount = double.parse(widget.mPrice);
    }
  }

  void createNativeOrder(String mPayMethod, String? mPayTitle,
      {bool isWallet = false, bool isPayment = false}) async {
    hideKeyboard(context);

    List<LineItemsRequest> lineItems = [];
    List<ShippingLines?> shippingLines = [];
    widget.mCartProduct!.forEach((item) {
      var lineItem = LineItemsRequest();
      lineItem.productId = item.proId;
      lineItem.quantity = item.quantity;
      lineItem.variationId = item.proId;
      lineItems.add(lineItem);
    });

    var couponCode = widget.mCouponData;
    List<CouponLines> mCouponItems = [];
    if (couponCode.isNotEmpty) {
      var mCoupon = CouponLines();
      mCoupon.code = couponCode;
      mCouponItems.clear();
      mCouponItems.add(mCoupon);
    }

    if (widget.shippingLines != null) {
      shippingLines.add(widget.shippingLines);
    }
    var request = {
      'billing': billing,
      'shipping': shipping,
      'line_items': lineItems,
      'payment_method': mPayMethod,
      'payment_method_title': mPayTitle,
      'transaction_id': "",
      'customer_id': getIntAsync(USER_ID),
      'coupon_lines': couponCode.isNotEmpty ? mCouponItems : '',
      'status': "processing",
      'set_paid': false,
      'shipping_lines': shippingLines
    };
    appStore.setLoading(true);
    print("isWallet----" + isWallet.toString());
    print("isPayment---" + isPayment.toString());

    createOrderApi(request).then((response) async {
      if (!mounted) return;

      if (isWallet == true && isPayment == false) {
        var request = {
          "type": "debit",
          "amount": mAmount,
          "details": "",
        };
        log("mAmount" + mAmount.toString());

        await addTransaction(request).then((res) async {
          appStore.setLoading(false);
          await PlaceOrderScreen(
            mOrderID: response['id'],
            total: mAmount,
            transactionId: response['transaction_id'],
            orderKey: response['order_key'],
            paymentMethod: response['payment_method'],
            dateCreated: response['date_created'],
          ).launch(context, pageRouteAnimation: PageRouteAnimation.Scale);
        }).catchError((error) {
          print("Error" + error.toString());
          toast(error.toString());
        });
      } else if (isPayment == true && isWallet == false) {
        appStore.setLoading(false);
        log("va;ue--" + response.toString());
        await PlaceOrderScreen(
          mOrderID: response['id'],
          total: widget.mPrice,
          transactionId: response['transaction_id'],
          orderKey: response['order_key'],
          paymentMethod: response['payment_method'],
          dateCreated: response['date_created'],
        ).launch(context, pageRouteAnimation: PageRouteAnimation.Scale);
      } else if (isWallet == true && isPayment == true) {
        log("both payments");
        var req = {
          "type": "debit",
          "amount": mTotalBalance,
          "details": "",
        };
        await addTransaction(req).then((res) async {
          log("Done");
          appStore.setLoading(false);
          await PlaceOrderScreen(
            mOrderID: response['id'],
            total: widget.mPrice,
            transactionId: response['transaction_id'],
            orderKey: response['order_key'],
            paymentMethod: response['payment_method'],
            dateCreated: response['date_created'],
          ).launch(context, pageRouteAnimation: PageRouteAnimation.Scale);
        }).catchError((error) {
          print("Error" + error.toString());
          toast(error.toString());
        });
      }
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  Future createWebViewOrder() async {
    if (!accessAllowed) {
      return;
    }

    var request = CreateOrderRequestModel();

    if (widget.shippingLines != null) {
      List<ShippingLines?> shippingLines = [];
      shippingLines.add(widget.shippingLines);
      request.shippingLines = shippingLines;
    }
    List<LineItemsRequest> lineItems = [];

    widget.mCartProduct!.forEach((item) {
      var lineItem = LineItemsRequest();
      lineItem.productId = item.proId;
      lineItem.quantity = item.quantity;
      lineItem.variationId = item.proId;
      lineItems.add(lineItem);
    });

    request.paymentMethod = "webview";
    request.transactionId = "";
    request.customerId = getIntAsync(USER_ID);
    request.status = "pending";
    request.setPaid = false;

    request.lineItems = lineItems;
    request.shipping = shipping;
    request.billing = billing;
    createOrder(request);
  }

  void createOrder(CreateOrderRequestModel mCreateOrderRequestModel) async {
    appStore.setLoading(true);
    await createOrderApi(mCreateOrderRequestModel.toJson()).then((response) {
      if (!mounted) return;
      processPaymentApi(response['id']);
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString(), print: true);
    });
  }

  processPaymentApi(var mOrderId) async {
    log(mOrderId);
    var request = {"order_id": mOrderId};
    getCheckOutUrl(request).then((res) async {
      if (!mounted) return;

      appStore.setLoading(false);
      bool isPaymentDone = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WebViewPaymentScreen(checkoutUrl: res['checkout_url'])),
          ) ??
          false;
      if (isPaymentDone) {
        appStore.setLoading(true);
        if (!await isGuestUser()) {
          clearCartItems().then((response) {
            if (!mounted) return;

            appStore.setLoading(false);
            appStore.setCount(0);
            DashBoardScreen().launch(context, isNewTask: true);
          }).catchError((error) {
            appStore.setLoading(false);
            toast(error.toString());
          });
        } else {
          appStore.setCount(0);
          removeKey(CART_DATA);
          DashBoardScreen().launch(context, isNewTask: true);
        }
      } else {
        deleteOrder(mOrderId).then((value) => {log(value)});
        appStore.setCount(0);
      }
    }).catchError((error) {});
  }

  void onOrderNowClick(a, b) async {
    if (isSelected == true) {
      createNativeOrder(a, b,
          isPayment: true, isWallet: true);
    } else {
      createNativeOrder(a, b, isPayment: true);
    }
  }



  @override
  void dispose() {
    super.dispose();
    //_razorPay.clear();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: mTop(context, appLocalization.translate('lbl_order_summary'),
          showBack: true) as PreferredSizeWidget?,
      body: BodyCornerWidget(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  if (shipping != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appLocalization.translate("lbl_shipping_address")!,
                                style: boldTextStyle())
                            .visible(shipping != null),
                        4.height,
                        Text(
                          "${shipping!.firstName.validate()} ${shipping!.lastName.validate()}\n${shipping!.address1.validate()}\n${shipping!.city.validate()}\n${shipping!.state.validate()}-${shipping!.country.validate()}-${shipping!.postcode.validate()}",
                          style: secondaryTextStyle(),
                        ).visible(shipping != null),
                        4.height
                      ],
                    ).paddingOnly(right: 16, left: 16),
                  Divider(
                          thickness: 6,
                          color:
                              Theme.of(context).textTheme.headlineMedium!.color)
                      .visible(isNativePayment == true),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appLocalization.translate('lbl_payment_methods')!,
                              style: boldTextStyle())
                          .paddingLeft(16),
                      8.height,
                      
                      AnimatedListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 12, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 20,
                                      height: 20,
                                      padding: EdgeInsets.all(2),
                                      decoration:
                                          boxDecorationWithRoundedCorners(
                                        borderRadius: radius(4),
                                        backgroundColor: context.cardColor,
                                        border: Border.all(
                                          color: currentTimeValue == index
                                              ? primaryColor!
                                              : Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                        ),
                                      ),
                                      child: Icon(Icons.done,
                                              color: primaryColor, size: 14)
                                          .visible(currentTimeValue == index),
                                    ),
                                    12.width,ClipRRect(
  borderRadius: BorderRadius.circular(20), // Image border
  child: SizedBox.fromSize(
    size: Size.fromRadius(20), // Image radius
    child: Image.asset(paymentList![index].image!, fit: BoxFit.contain),
  ),
),
                                    12.width,
                                    Expanded(
                                      child: Text(
                                        paymentList![index].paymentMethod!,
                                        style: secondaryTextStyle(
                                            size: 16,
                                            color: currentTimeValue == index
                                                ? primaryColor
                                                : Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .color),
                                      ),
                                    ),
                                  ],
                                ).onTap(
                                  () {
                                    if (widget.mPrice.toString().toDouble() >=
                                        mTotalBalance.toDouble()) {
                                      setState(() {
                                        currentTimeValue = 0;
                                        currentTimeValue = index;
                                        paymentIndex = paymentList![
                                                currentTimeValue.validate()]
                                            .paymentIndex;
                                      });
                                    } else if (isSelected == false) {
                                      setState(() {
                                        log("value");
                                        currentTimeValue = 0;
                                        currentTimeValue = index;
                                        paymentIndex = paymentList![
                                                currentTimeValue.validate()]
                                            .paymentIndex;
                                      });
                                    }
                                  },
                                ),
                                Align(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: Column(
                                  children: [
                                    Text("الحساب : ${paymentList![index].account!}"),
                                    Text("بإسم : عساف غالب"),
                                    Text("+رقم الهاتف : 17146844346")
                                  ],).visible(currentTimeValue == index),
                                ),
                                
                              ],
                            ),
                          );
                        },
                        itemCount: paymentList!.length,
                      ),
                      Center(
                        child: Column(
                          children: [
                        Text("لأخذ المنتج من المتجر - Pick up", style: secondaryTextStyle(
                                            size: 17,)),
                        Text("Tahreer Square Sana'a", style: secondaryTextStyle(
                                            size: 17,)),
                        Text("+رقم الهاتف : 17146844346", style: secondaryTextStyle(
                                            size: 17,),)
                      
                        ],),
                      )
                    ],
                  ).paddingOnly(top: 8).visible(isNativePayment == true),
                  Divider(
                      thickness: 6,
                      color: Theme.of(context).textTheme.headlineMedium!.color),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appLocalization.translate("lbl_price_detail")!,
                          style: boldTextStyle()),
                      8.height,
                      Divider(),
                      8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(appLocalization.translate("lbl_total_mrp")!,
                              style: secondaryTextStyle(size: 16)),
                          PriceWidget(
                              price: nf.format(widget.subtotal.validate()),
                              color: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .color,
                              size: 16)
                        ],
                      ),
                      4.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              appLocalization.translate("lbl_discount_on_mrp")!,
                              style: secondaryTextStyle(size: 16)),
                          Row(
                            children: [
                              Text("-",
                                  style: primaryTextStyle(color: primaryColor)),
                              PriceWidget(
                                  price: widget.mRPDiscount!.toStringAsFixed(2),
                                  size: 16),
                            ],
                          )
                        ],
                      ).paddingBottom(4).visible(widget.mRPDiscount != 0.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              appLocalization.translate('lbl_coupon_discount')!,
                              style: secondaryTextStyle(size: 16)),
                          Row(
                            children: [
                              Text("-",
                                  style: primaryTextStyle(color: primaryColor)),
                              PriceWidget(
                                  price: widget.discount.validate(),
                                  size: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .color),
                            ],
                          ),
                        ],
                      ).paddingBottom(4).visible(
                          widget.discount != 0.0 && isEnableCoupon == true),
                      widget.method != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(appLocalization.translate("lbl_Shipping")!,
                                    style: secondaryTextStyle(size: 16)),
                                widget.method != null &&
                                        widget.method!.cost != null &&
                                        widget.method!.cost!.isNotEmpty
                                    ? PriceWidget(
                                        price: widget.method!.cost
                                            .toString()
                                            .validate(),
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .color,
                                        size: 16)
                                    : Text(
                                        appLocalization.translate('lbl_free')!,
                                        style:
                                            boldTextStyle(color: Colors.green))
                              ],
                            )
                          : SizedBox(),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(appLocalization.translate('lbl_total_amount')!,
                              style: boldTextStyle(color: primaryColor)),
                          PriceWidget(price: widget.mPrice, size: 16),
                        ],
                      ),
                    ],
                  ).paddingAll(16),
                ],
              ),
            ),
            Observer(
                builder: (context) =>
                    mProgress().center().visible(appStore.isLoading)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Theme.of(context).hoverColor.withOpacity(0.8),
                blurRadius: 15.0,
                offset: Offset(0.0, 0.75)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PriceWidget(
                    price: widget.mPrice,
                    size: 16,
                    color: Theme.of(context).textTheme.titleSmall!.color)
                .expand(),
            16.height,
            AppButton(
              text: appLocalization.translate('lbl_continue'),
              textStyle: primaryTextStyle(color: white),
              color: isHalloween ? mChristmasColor : primaryColor,
              onTap: () async {
                if (appStore.isLoading) {
                  return;
                }
                if (await isGuestUser()) {
                  toast(appLocalization.translate('lbl_guest_payment_msg'));
                } else {
                  if (isNativePayment == false) {
                    createWebViewOrder();
                  } else {
                    log("hello" + paymentIndex.toString());
                    if (widget.mPrice.toString().toDouble() <=
                            mTotalBalance.toDouble() &&
                        IS_PAY_FROM_WALLET &&
                        isSelected == true) {
                      log("IS_PAY_FROM_WALLET");
                      checkFormWallet();
                    }
                    // else if(widget.mPrice.toString().toDouble() >= mTotalBalance.toDouble()){
                    //   payments();
                    // }
                    else {
                      payments();
                    }
                  }
                }
              },
            ).expand(),
          ],
        ).paddingAll(16),
      ),
    );
  }

  void payments() {
    if (paymentIndex == 0) {
      cod("cod",'محفظة الكريمي');
    }
    if (paymentIndex == 1) {
      
      cod("cod",'محفظة فلوسك');
    }
    if (paymentIndex == 2) {
      
      cod("cod",'محفظة كاش');
    }
    if (paymentIndex == 3) {
      
      cod("cod",'محفظة كاك موبايلي');
    }
    if (paymentIndex == 4) {
      
      cod("cod",'محفظة موبايل موني');
    }
    if (paymentIndex == 5) {
      
      cod("cod",'محفظة سبأكاش');
    }
    if (paymentIndex == 6) {
      
      cod("cod",'محفظة محفظتي');
    }

    if (paymentIndex == 7) {
      
      cod("cod",'محفظة أم فلوس');
    }
    if (paymentIndex == 8) {
      
      cod("cod",'محفظة جوالي');
    }
    if (paymentIndex == 9) {
      
      cod("cod",'حوالة عادية عبر أي صراف');
    }
  }

  void checkFormWallet() {
    log("IS_PAY_FROM_WALLET");
    paymentCount();
    _wallet();
  }

  void stripePayment(BuildContext context) async {
    paymentCount();

    var request = {
      'apiKey': stripPaymentKey,
      'amount': mAmount * 100,
      'currency': "INR",
      'description': "556",
    };
    getStripeClientSecret(request).then(
      (res) async {
        SetupPaymentSheetParameters setupPaymentSheetParameters =
            SetupPaymentSheetParameters(
          paymentIntentClientSecret: res['client_secret'],
          style: ThemeMode.light,
          appearance: PaymentSheetAppearance(
              colors: PaymentSheetAppearanceColors(primary: primaryColor)),
          applePay: PaymentSheetApplePay(
              merchantCountryCode:
                  getStringAsync(DEFAULT_CURRENCY).toUpperCase()),
          googlePay: PaymentSheetGooglePay(
              merchantCountryCode:
                  getStringAsync(DEFAULT_CURRENCY).toUpperCase(),
              testEnv: true),
          merchantDisplayName: APP_NAME,
          customerId: isIOS ? null : '1',
          //customerEphemeralKeySecret: res.clientSecret.validate(),
          //setupIntentClientSecret: res.clientSecret.validate(),
        );
        await Stripe.instance
            .initPaymentSheet(
                paymentSheetParameters: setupPaymentSheetParameters)
            .then((value) async {
          await Stripe.instance.presentPaymentSheet().then((value) async {
            if (isSelected == true)
              createNativeOrder('strippay', 'Stripe Payment',
                  isPayment: true, isWallet: true);
            else
              createNativeOrder('strippay', 'Stripe Payment', isPayment: true);
          });
        }).catchError((e) {
          toast("Payment Failed");
          log("presentPaymentSheet ${e.toString()}");
        });
      },
    ).catchError((e) {
      log("SetupPaymentSheetParameters ${e.toString()}");
    });
  }

  void cod(a,b) {
    paymentCount();
    onOrderNowClick(a,b);
  }

  void _wallet() {
    log("Total Balance" + mTotalBalance.toString());
    log("Product Price" + widget.mPrice.toString());
    log("Product Price" + mAmount.toString());

    if (widget.mPrice.toString().toDouble() <= mTotalBalance.toDouble()) {
      createNativeOrder('wallet', "Wallet", isWallet: true, isPayment: false);
    } else if (widget.mPrice.toString().toDouble() >=
        mTotalBalance.toDouble()) {
      toast(
          "Please select another payment method. Your balance is less compare to total");
    } else if (mTotalBalance.toDouble() == 0) {
      toast(
          "Your balance is zero. Please add money and try again otherwise choose different payment method");
    } else {
      print("sorry");
    }
  }

  void openCheckout() async {
    paymentCount();
    var options = {
      'key': razorKey,
      'amount': mAmount * 100,
      'name': 'Ainaqah',
      'theme.color': '#4358DD',
      'description': 'Woocommerce Store',
      'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
      'prefill': {'contact': billing!.phone, 'email': billing!.email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorPay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    log("Success:+$response");
    Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId!);
    if (!await isGuestUser()) {
      if (isSelected == true) {
        createNativeOrder('razorpay', "RazorPay",
            isPayment: true, isWallet: true);
        clearCartItems().then((response) {
          if (!mounted) return;
          appStore.setCount(0);
          DashBoardScreen().launch(context, isNewTask: true);
          setState(() {});
        }).catchError((error) {
          appStore.setLoading(false);
          toast(error.toString());
        });
      } else {
        createNativeOrder('razorpay', "RazorPay", isPayment: true);
        clearCartItems().then((response) {
          if (!mounted) return;
          appStore.setCount(0);
          DashBoardScreen().launch(context, isNewTask: true);
          setState(() {});
        }).catchError((error) {
          appStore.setLoading(false);
          toast(error.toString());
        });
      }
    } else {
      appStore.setCount(0);
      removeKey(CART_DATA);
      DashBoardScreen().launch(context, isNewTask: true);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName!);
  }

  //PayStack Payment
  void payStackCheckOut(BuildContext context) async {
    paymentCount();
    formKey.currentState?.save();
    Charge charge = Charge()
      ..amount = (mAmount.toInt() * 100) // In base currency
      ..email = billing!.email
      ..currency = mCurrency
      ..card = PaymentCard(
          number: cardNumber,
          cvc: cvv,
          expiryMonth: expiryMonth,
          expiryYear: expiryYear);

    charge.reference = _getReference();

    try {
      CheckoutResponse response = await plugin.checkout(context,
          method: method, charge: charge, fullscreen: false, logo: MyLogo());
      payStackUpdateStatus(response.reference, response.message);
      if (response.message == SUCCESS) {
        if (isSelected == true)
          createNativeOrder('paystack', 'Paystack',
              isPayment: true, isWallet: true);
        else
          createNativeOrder('paystack', 'Paystack', isPayment: true);
      } else {
        toast("Payment Failed");
      }
    } catch (e) {
      payStackShowMessage("Check console for error");
      rethrow;
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  void payStackUpdateStatus(String? reference, String message) {
    payStackShowMessage(message, const Duration(seconds: 7));
  }

  void payStackShowMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    toast(message);
    log(message);
  }

  void flutterWaveCheckout() async {
    final customer = Customer(
      name: billing!.firstName.toString() + " " + billing!.lastName.toString(),
      phoneNumber: billing!.phone.toString(),
      email: billing!.email.toString(),
    );

    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: flutterWavePublicKey.validate(),
      currency: mCurrency,
      redirectUrl: "https://www.google.com",
      txRef: DateTime.now().millisecond.toString(),
      amount: mAmount.toString(),
      customer: customer,
      paymentOptions: "card, payattitude",
      customization: Customization(title: "Test Payment"),
      isTestMode: true,
    );
    final ChargeResponse response = await flutterwave.charge();
    if (response.status == 'successful') {
      if (isSelected == true)
        createNativeOrder('flutterwave', 'FlutterWave',
            isPayment: true, isWallet: true);
      else
        createNativeOrder('flutterwave', 'FlutterWave', isPayment: true);

      toast("Payment Successfully");
      print("${response.toJson()}");
    } else {
      FlutterwaveViewUtils.showToast(context, 'Transaction Failed');
    }
  }
}
