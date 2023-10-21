import 'package:flutter_mobx/flutter_mobx.dart';
import '/../models/ProductResponse.dart';
import '/../screen/ProductDetail/ProductDetailScreen1.dart';
import '/../screen/ProductDetail/ProductDetailScreen2.dart';
import '/../screen/ProductDetail/ProductDetailScreen3.dart';
import '/../screen/SignInScreen.dart';
import '/../utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import 'Common.dart';
import 'Constants.dart';

import 'package:flutter/material.dart';

class ProductWishListExtension extends StatefulWidget {
  static String tag = '/ProductWishListExtension';
  final ProductResponse? mProductModel;

  ProductWishListExtension({Key? key, this.mProductModel}) : super(key: key);

  @override
  ProductWishListExtensionState createState() => ProductWishListExtensionState();
}

class ProductWishListExtensionState extends State<ProductWishListExtension> {
  bool mIsInWishList = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Container(
        margin: EdgeInsets.all(6),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(shape: BoxShape.rectangle, color: isHalloween ? mHalloweenCard : Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(8)),
        child: wishListStore.isItemInWishlist(widget.mProductModel!.id!) == false
            ? Icon(Icons.favorite_border, color: isHalloween ? white : Theme.of(context).textTheme.titleSmall!.color, size: 16)
            : Icon(Icons.favorite, color: Colors.red, size: 16),
      ).visible(!widget.mProductModel!.type!.contains("grouped") && !widget.mProductModel!.type!.contains("external") && !widget.mProductModel!.type!.contains("variable")).onTap(
        () {
          if (getBoolAsync(IS_LOGGED_IN)) {
            addItemToWishlist(data: widget.mProductModel!);
            setState(() {});
          } else
            SignInScreen().launch(context);
        },
      );
    });
  }
}

onClickProduct(BuildContext context, ProductResponse? mProductModel) async {
  if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 1) {
    await ProductDetailScreen1(mProId: mProductModel!.id).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
  } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 2) {
    await ProductDetailScreen2(mProId: mProductModel!.id).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
  } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 3) {
    await ProductDetailScreen3(mProId: mProductModel!.id).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
  } else {
    await ProductDetailScreen1(mProId: mProductModel!.id).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
  }
}
