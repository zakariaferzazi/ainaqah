import 'package:flutter/material.dart';
import '/../models/ProductResponse.dart';
import '/../utils/ProductWishListExtension.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';

class DashBoard5Product extends StatefulWidget {
  static String tag = '/Product';
  final double? width;
  final ProductResponse? mProductModel;
  final bool? isHorizontal;

  DashBoard5Product({Key? key, this.width, this.mProductModel, this.isHorizontal}) : super(key: key);

  @override
  ProductState createState() => ProductState();
}

class ProductState extends State<DashBoard5Product> {
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
    String? img = widget.mProductModel!.images!.isNotEmpty ? widget.mProductModel!.images!.first.src : '';

    return GestureDetector(
      onTap: () async {
        setState(() {
          onClickProduct(context, widget.mProductModel!);
        });
      },
      child: Container(
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(defaultRadius),
          decorationImage: DecorationImage(image: AssetImage(ic_christmas_product_bg), fit: BoxFit.cover),
        ),
        padding: EdgeInsets.all(3),
        child: Stack(
          children: [
            Container(
              width: widget.width,
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(defaultRadius), backgroundColor: context.cardColor),
              padding: EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      commonCacheImageWidget(img.validate(), height: 190, width: widget.width, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                      mSale(widget.mProductModel!),
                      ProductWishListExtension(mProductModel: widget.mProductModel!).paddingOnly(left: 4),
                    ],
                  ),
                  Text(widget.mProductModel!.name, style: primaryTextStyle(), maxLines: 1),
                  4.height,
                  Stack(
                    children: [
                      Row(
                        children: [
                          PriceWidget(
                            price: widget.mProductModel!.onSale == true
                                ? widget.mProductModel!.salePrice.validate().isNotEmpty
                                    ? double.parse(widget.mProductModel!.salePrice.toString()).toStringAsFixed(2)
                                    : double.parse(widget.mProductModel!.price.validate()).toStringAsFixed(2)
                                : widget.mProductModel!.regularPrice!.isNotEmpty
                                    ? double.parse(widget.mProductModel!.regularPrice.validate().toString()).toStringAsFixed(2)
                                    : double.parse(widget.mProductModel!.price.validate().toString()).toStringAsFixed(2),
                            size: 16,
                            color: mChristmasColor,
                          ),
                          4.width,
                          PriceWidget(price: widget.mProductModel!.regularPrice.validate().toString(), size: 14, isLineThroughEnabled: true, color: mChristmasColor.withOpacity(0.5))
                              .visible(widget.mProductModel!.salePrice.validate().isNotEmpty && widget.mProductModel!.onSale == true),
                        ],
                      ).visible(!widget.mProductModel!.type!.contains("grouped") && !widget.mProductModel!.type!.contains("variable")),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
