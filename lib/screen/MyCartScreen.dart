import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import '/../component/CartListComponent.dart';
import '/../component/ShippingComponent.dart';
import '/../component/NotSignInComponent.dart';
import '/../main.dart';
import '/../models/CartModel.dart';
import '/../models/Countries.dart';
import '/../models/CustomerResponse.dart';
import '/../models/Line_items.dart';
import '/../models/OrderModel.dart';
import '/../models/ShippingMethodResponse.dart';
import '/../utils/AppBarWidget.dart';
import '/../screen/DashBoardScreen.dart';
import '/../screen/OrderSummaryScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import '/../utils/Constants.dart';
import '/../utils/SharedPref.dart';
import 'package:nb_utils/nb_utils.dart';
import '../AppLocalizations.dart';
import 'EditProfileScreen.dart';

// ignore: must_be_immutable
class MyCartScreen extends StatefulWidget {
  static String tag = '/MyCartScreen';

  bool? isShowBack = false;

  MyCartScreen({this.isShowBack});

  @override
  MyCartScreenState createState() => MyCartScreenState();
}

class MyCartScreenState extends State<MyCartScreen> {
  List<CartModel> mCartModelList = [];
  List<LineItems> mLineItems = [];
  List<Method> shippingMethods = [];
  List<Country> countryList = [];

  Shipping? shipping;
  ShippingMethodResponse? shippingMethodResponse;

  bool isCoupons = true;

  var selectedShipment = 0;
  var mDiscountInfo;

  ScrollController _scrollController = ScrollController();
  NumberFormat nf = NumberFormat('##.00');

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (!await isGuestUser() && await isLoggedIn()) {
      cartStore.getStoreCartList();
    }
    cartStore.fetchShipmentData();
    appStore.setLoading(false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setValue(CARTCOUNT, appStore.count);
    var appLocalization = AppLocalizations.of(context)!;

    String getTotalAmount() {
      if (cartStore.shippingMethodResponse != null &&
          cartStore.shippingMethods.isNotEmpty &&
          cartStore.shippingMethods[cartStore.selectedShipment].cost != null &&
          cartStore.shippingMethods[cartStore.selectedShipment].cost!.isNotEmpty) {
        return ((mDiscountInfo != null
                    ? cartStore.cartTotalDiscount
                    : cartStore.cartTotalCount) +
                double.parse(cartStore.shippingMethods[cartStore.selectedShipment].cost!))
            .toStringAsFixed(2);
      } else {
        return mDiscountInfo != null
            ? cartStore.cartTotalDiscount.toStringAsFixed(2)
            : cartStore.cartTotalCount.toStringAsFixed(2);
      }
    }

    Widget mPaymentInfo() {
      return Observer(builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(appLocalization.translate('lbl_price_detail')!,
                    style: boldTextStyle()),
                2.width,
                Text("(" + cartStore.cartList.length.toString() + " Items)",
                    style: boldTextStyle()),
              ],
            ),
            4.height,
            Divider(),
            4.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLocalization.translate('lbl_total_mrp')!,
                    style: secondaryTextStyle(size: 16)),
                PriceWidget(
                    price: cartStore.cartTotalAmount,
                    color: Theme.of(context).textTheme.titleMedium!.color,
                    size: 16),
              ],
            ),
            4.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLocalization.translate('lbl_discount_on_mrp')!,
                    style: secondaryTextStyle(size: 16)),
                Row(
                  children: [
                    Text("-", style: primaryTextStyle(color: primaryColor)),
                    PriceWidget(
                        price: cartStore.cartTotalDiscount.toStringAsFixed(2),
                        size: 16),
                  ],
                )
              ],
            ).visible(cartStore.cartTotalDiscount != 0.0),
            4.height,
            cartStore.shippingMethodResponse != null &&
                    cartStore.shippingMethods.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(appLocalization.translate("lbl_Shipping")!,
                          style: secondaryTextStyle(size: 16)),
                      cartStore.shippingMethods[cartStore.selectedShipment].cost !=
                                  null &&
                              cartStore.shippingMethods[cartStore.selectedShipment].cost!
                                  .isNotEmpty
                          ? PriceWidget(
                              price: cartStore
                                  .shippingMethods[cartStore.selectedShipment].cost,
                              color: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .color,
                              size: 16)
                          : Text(appLocalization.translate('lbl_free')!,
                              style: boldTextStyle(color: Colors.green))
                    ],
                  )
                : SizedBox(),
            Divider(),
            4.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLocalization.translate('lbl_total_amount_')!,
                    style: boldTextStyle(color: primaryColor)),
                PriceWidget(price: getTotalAmount(), size: 16),
              ],
            ),
            16.height,
          ],
        ).paddingAll(16);
      });
    }

    Widget mBody() {
      return Observer(
        builder: (context) {
          return Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(bottom: 200),
                child: Column(
                  children: [
                    16.height,
                    CartListComponent(),
                    
                    




                    getBoolAsync(IS_GUEST_USER) == true ||
            cartStore.shipping != null &&
                cartStore.shippingMethodResponse != null
        ? Observer(builder: (context) {
            return Column(
              children: [
                Divider(
                    thickness: 6,
                    color: Theme.of(context).textTheme.headlineMedium!.color),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(appLocalization.translate("lbl_Shipping")!,
                            style: boldTextStyle()),
                        Text(appLocalization.translate("lbl_change")!,
                                style: secondaryTextStyle(
                                    color: primaryColor, size: 12))
                            .onTap(() async {
                          bool isChanged = await (EditProfileScreen().launch(
                              context,
                              pageRouteAnimation: PageRouteAnimation.Fade));
                          if (isChanged) {
                            /*  cartStore.countryList.clear();*/
                            /*   cartStore.shippingMethodResponse = null;*/
                            appStore.setLoading(true);
                            
                            setState(() {});
                          }
                          setState(() {});
                        }),
                      ],
                    ),
                    4.height,
                    getBoolAsync(IS_GUEST_USER) == true
                        ? Text(
                            appLocalization.translate(
                                'lbl_please_update_shipping_address')!,
                            style: primaryTextStyle())
                        : cartStore.shipping!.getAddress()!.isNotEmpty
                            ? Text(
                                    "(" +
                                        cartStore.shipping!.getAddress()! +
                                        ")",
                                    style: secondaryTextStyle())
                                .visible(cartStore.shipping!
                                    .getAddress()!
                                    .isNotEmpty)
                            : Text(
                                appLocalization.translate(
                                    'lbl_please_update_shipping_address')!,
                                style: primaryTextStyle()),
                    cartStore.shippingMethods.isNotEmpty
                        ? AnimatedListView(
                                itemCount: cartStore.shippingMethods.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 8),
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  Method method =
                                      cartStore.shippingMethods[index];
                                  return Container(
                                    padding: EdgeInsets.only(top: 4, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                            decoration:
                                                boxDecorationWithRoundedCorners(
                                                    borderRadius: radius(4),
                                                    backgroundColor: cartStore
                                                                .selectedShipment ==
                                                            index
                                                        ? primaryColor!
                                                        : Colors.grey
                                                            .withOpacity(0.3)),
                                            width: 16,
                                            height: 16,
                                            child: Icon(Icons.done,
                                                    size: 12,
                                                    color: Colors.white)
                                                .visible(cartStore
                                                        .selectedShipment ==
                                                    index)),
                                        Text(
                                          method.id != "free_shipping"
                                              ? method.title! + " :"
                                              : method.title! + " :",
                                          style: primaryTextStyle(),
                                        ).paddingLeft(8),
                                        method.cost == null
                                            ? Text("Free Shipping",
                                                    style: primaryTextStyle(
                                                        color: Colors.green))
                                                .paddingLeft(8)
                                            : Text(
                                                    getStringAsync(
                                                            DEFAULT_CURRENCY) +
                                                        method.cost.toString(),
                                                    style: primaryTextStyle(
                                                        color: Colors.red))
                                                .paddingLeft(8)
                                                .visible(method.id !=
                                                    "free_shipping")
                                      ],
                                    ),
                                  ).onTap(() {
                                    setState(() {
                                      cartStore.selectedShipment = index;
                                    });
                                    print(
                                        cartStore.shippingMethods[index].cost);
                                  });
                                })
                            .visible(
                                cartStore.shipping!.getAddress()!.isNotEmpty)
                        : Text(appLocalization.translate('lbl_free_shipping')!,
                            style: primaryTextStyle())
                  ],
                ).paddingOnly(left: 16, right: 16, top: 16),
              ],
            );
          })
        : SizedBox(),








                    Divider(thickness: 6, color: context.dividerColor),
                    mPaymentInfo(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Theme.of(context).hoverColor.withOpacity(0.8),
                          blurRadius: 15.0,
                          offset: Offset(0.0, 0.75)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PriceWidget(
                              price: getTotalAmount(),
                              size: 16,
                              color: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .color),
                          8.height,
                          Text(appLocalization.translate('lbl_view_details')!,
                                  style: primaryTextStyle(color: primaryColor))
                              .onTap(() {
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300));
                          })
                        ],
                      ).expand(),
                      16.height,
                      AppButton(
                        text: appLocalization.translate('lbl_continue'),
                        textStyle: primaryTextStyle(color: white),
                        color: isHalloween ? mChristmasColor : primaryColor,
                        onTap: () async {
                          ShippingLines? shippingLine;
                          Method? method;
                          if (cartStore.isOutOfStock == false) {
                            if (cartStore.shippingMethodResponse != null &&
                                !appStore.isLoading &&
                                cartStore.shipping!.getAddress()!.isNotEmpty) {
                              if (cartStore.shippingMethodResponse != null &&
                                  cartStore.shippingMethods.isNotEmpty) {
                                method =
                                    cartStore.shippingMethods[cartStore.selectedShipment];
                                shippingLine = ShippingLines(
                                    methodId: cartStore
                                        .shippingMethods[cartStore.selectedShipment].id,
                                    methodTitle: cartStore
                                        .shippingMethods[cartStore.selectedShipment]
                                        .methodTitle,
                                    total: cartStore
                                        .shippingMethods[cartStore.selectedShipment]
                                        .cost);
                              }
                              OrderSummaryScreen(
                                      mCartProduct: cartStore.cartList,
                                      mCouponData:
                                          mDiscountInfo != null && isCoupons
                                              ? mDiscountInfo['code']
                                              : '',
                                      mPrice: getTotalAmount().toString(),
                                      shippingLines: shippingLine,
                                      method: method,
                                      subtotal:
                                          cartStore.cartTotalAmount.toDouble(),
                                      discount: isCoupons
                                          ? cartStore.cartTotalDiscount
                                              .toDouble()
                                          : 0,
                                      mRPDiscount: cartStore.cartTotalDiscount
                                          .toDouble())
                                  .launch(context,
                                      pageRouteAnimation:
                                          PageRouteAnimation.Slide);
                            } else {
                              appStore.setLoading(false);
                              toast(appLocalization.translate(
                                  'lbl_please_add_shipping_details'));
                              bool isChanged =
                                  await EditProfileScreen().launch(context);
                              if (isChanged == true) {
                                cartStore.countryList.clear();
                                cartStore.shippingMethodResponse = null;
                                appStore.setLoading(true);
                                init();
                                setState(() {});
                                appStore.setLoading(false);
                              }
                            }
                          } else {
                            toast(appLocalization
                                .translate('lbl_confirmation_sold_out'));
                          }
                        },
                      ).expand(),
                    ],
                  ).paddingAll(16),
                ),
              )
            ],
          ).visible(cartStore.cartList.isNotEmpty);
        },
      );
    }

    return Scaffold(
      appBar: mTop(context, appLocalization.translate('lbl_my_cart'),
          showBack: widget.isShowBack! ? true : false) as PreferredSizeWidget?,
      body: Observer(builder: (context) {
        return BodyCornerWidget(
          child: !getBoolAsync(IS_LOGGED_IN)
              ? WishListNotSignInComponent(isWishlist: false)
                  .visible(!appStore.isLoading)
              : cartStore.cartList.isNotEmpty
                  ? Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        mBody(),
                        Observer(
                            builder: (context) => mProgress()
                                .center()
                                .visible(appStore.isLoading)),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined,
                            size: 120, color: primaryColor),
                        20.height,
                        Text(appLocalization.translate("msg_empty_basket")!,
                            style: secondaryTextStyle(size: 14),
                            textAlign: TextAlign.center),
                        30.height,
                        Container(
                          width: context.width(),
                          child: AppButton(
                              width: context.width(),
                              text: appLocalization
                                  .translate('lbl_start_shopping'),
                              textStyle: primaryTextStyle(color: white),
                              color:
                                  isHalloween ? mChristmasColor : primaryColor,
                              onTap: () {
                                DashBoardScreen().launch(context);
                                appStore.setBottomNavigationIndex(0);
                              }).paddingAll(16),
                        ),
                      ],
                    ).paddingOnly(left: 16, right: 16).center(),
        );
      }),
    );
  }
}
