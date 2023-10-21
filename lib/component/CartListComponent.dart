import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/../models/CartModel.dart';
import '/../screen/ProductDetail/ProductDetailScreen1.dart';
import '/../screen/ProductDetail/ProductDetailScreen2.dart';
import '/../screen/ProductDetail/ProductDetailScreen3.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import '/../utils/Constants.dart';
import '/../utils/SharedPref.dart';
import 'package:nb_utils/nb_utils.dart';
import '../AppLocalizations.dart';
import '../main.dart';

class CartListComponent extends StatefulWidget {
  @override
  CartListComponentState createState() => CartListComponentState();
}

class CartListComponentState extends State<CartListComponent> {
  NumberFormat nf = NumberFormat('##.00');

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

  removeCartItemDialog(BuildContext context, CartModel data) {
    var appLocalization = AppLocalizations.of(context)!;
    return showConfirmDialogCustom(
      context,
      primaryColor: primaryColor,
      title: appLocalization.translate("msg_remove"),
      positiveText: appLocalization.translate("lbl_yes"),
      negativeText: appLocalization.translate("lbl_no"),
      onAccept: (c) {
        cartStore.addToMyCart(data).then((value) {
          appStore.setLoading(false);
        });
        log("data" + data.quantity);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider();
      },
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: cartStore.cartList.length,
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () async {
            if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 1) {
              await ProductDetailScreen1(mProId: cartStore.cartList[i].proId).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
            } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 2) {
              await ProductDetailScreen2(mProId: cartStore.cartList[i].proId).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
            } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 3) {
              await ProductDetailScreen3(mProId: cartStore.cartList[i].proId).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
            } else {
              await ProductDetailScreen1(mProId: cartStore.cartList[i].proId).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (cartStore.cartList.isNotEmpty)
                cartStore.cartList[i].full == null
                    ? commonCacheImageWidget(cartStore.cartList[i].gallery!.validate().toString()[0], fit: BoxFit.cover, height: 85, width: 85).cornerRadiusWithClipRRect(8)
                    : commonCacheImageWidget(cartStore.cartList[i].full.toString().validate(), fit: BoxFit.cover, height: 85, width: 85).cornerRadiusWithClipRRect(8),
              8.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cartStore.cartList[i].name, maxLines: 2, style: primaryTextStyle(size: 15)),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            PriceWidget(
                              price: nf.format(double.parse(cartStore.cartList[i].price) * double.parse(cartStore.cartList[i].quantity)),
                              size: 16,
                            ),
                            PriceWidget(
                              price: cartStore.cartList[i].regularPrice.toString().isEmpty
                                  ? ''
                                  : nf.format(double.parse(cartStore.cartList[i].regularPrice) * double.parse(cartStore.cartList[i].quantity)),
                              size: 16,
                              color: textSecondaryColour,
                              isLineThroughEnabled: true,
                            ).paddingOnly(left: 2).visible(cartStore.cartList[i].salePrice.toString().validate().isNotEmpty && cartStore.cartList[i].onSale == true),
                          ],
                        ).expand(),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                var qty = int.parse(cartStore.cartList[i].quantity);
                                if (qty == 1 || qty < 1) {
                                  qty = 1;
                                } else {
                                  qty = qty - 1;
                                  appStore.setLoading(true);
                                  appStore.decrement();
                                  if (!await isGuestUser()) {
                                    var request = {
                                      'pro_id': cartStore.cartList[i].proId,
                                      'cart_id': cartStore.cartList[i].cartId,
                                      'quantity': qty,
                                    };
                                    cartStore.updateToCartItem(request);
                                  } else {
                                    appStore.setLoading(false);
                                    CartModel mCartModel = CartModel();
                                    mCartModel.name = cartStore.cartList[i].name;
                                    mCartModel.proId = cartStore.cartList[i].proId;
                                    mCartModel.onSale = cartStore.cartList[i].onSale;
                                    mCartModel.salePrice = cartStore.cartList[i].salePrice;
                                    mCartModel.regularPrice = cartStore.cartList[i].regularPrice;
                                    mCartModel.price = cartStore.cartList[i].price;
                                    mCartModel.gallery = cartStore.cartList[i].gallery;
                                    mCartModel.quantity = qty.toString();
                                    mCartModel.full = cartStore.cartList[i].full;
                                    mCartModel.cartId = cartStore.cartList[i].cartId;
                                    cartStore.removeFromCartList(cartStore.cartList[i]);
                                    cartStore.addToCartList(mCartModel);
                                  }
                                  setState(() {});
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.only(left: 8, right: 10),
                                decoration: BoxDecoration(color: isHalloween ? mChristmasColor : primaryColor, shape: BoxShape.circle),
                                child: Icon(Icons.remove, color: white, size: 16),
                              ),
                            ),
                            Text(cartStore.cartList[i].quantity, style: boldTextStyle()),
                            GestureDetector(
                              onTap: () async {
                                var qty = int.parse(cartStore.cartList[i].quantity);
                                var value = qty + 1;
                                appStore.setLoading(true);
                                appStore.increment();
                                if (!await isGuestUser()) {
                                  var request = {
                                    'pro_id': cartStore.cartList[i].proId,
                                    'cart_id': cartStore.cartList[i].cartId,
                                    'quantity': value,
                                  };
                                  cartStore.updateToCartItem(request);
                                  setState(() {});
                                } else {
                                  appStore.setLoading(false);
                                  CartModel mCartModel = CartModel();
                                  mCartModel.name = cartStore.cartList[i].name;
                                  mCartModel.proId = cartStore.cartList[i].proId;
                                  mCartModel.onSale = cartStore.cartList[i].onSale;
                                  mCartModel.salePrice = cartStore.cartList[i].salePrice;
                                  mCartModel.regularPrice = cartStore.cartList[i].regularPrice;
                                  mCartModel.price = cartStore.cartList[i].price;
                                  mCartModel.gallery = cartStore.cartList[i].gallery;
                                  mCartModel.quantity = value.toString();
                                  mCartModel.full = cartStore.cartList[i].full;
                                  mCartModel.cartId = cartStore.cartList[i].cartId;
                                  cartStore.removeFromCartList(cartStore.cartList[i]);
                                  cartStore.addToCartList(mCartModel);
                                }
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(color: isHalloween ? mChristmasColor : primaryColor, shape: BoxShape.circle),
                                child: Icon(Icons.add, size: 16, color: white),
                              ),
                            ),
                          ],
                        ).paddingLeft(8),
                      ],
                    ),
                    8.height,
                    Text(appLocalization.translate('lbl_sold_out')!, style: primaryTextStyle(color: Colors.red, size: 14)).paddingLeft(16).visible(cartStore.cartList[i].stockStatus == "outofstock"),
                    Divider(thickness: 0.5, color: grey.withOpacity(0.2)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, size: 20, color: lightGrey),
                        8.width,
                        Text(appLocalization.translate('lbl_remove')!, style: secondaryTextStyle(size: 16)),
                      ],
                    ).onTap(() async {
                      removeCartItemDialog(context, cartStore.cartList[i]);
                    }),
                    8.height,
                  ],
                ),
              )
            ],
          ).paddingOnly(left: 16, bottom: 8, top: 8),
        );
      },
    );
  }
}
