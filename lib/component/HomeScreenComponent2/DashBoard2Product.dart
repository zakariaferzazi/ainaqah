import 'package:flutter/material.dart';
import '/../models/ProductResponse.dart';
import '/../utils/ProductWishListExtension.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

class DashBoard2Product extends StatefulWidget {
  static String tag = '/Product';
  final double? width;
  final ProductResponse? mProductModel;
  final bool? isHorizontal;

  DashBoard2Product({this.width, this.mProductModel, this.isHorizontal});

  @override
  ProductState createState() => ProductState();
}

class ProductState extends State<DashBoard2Product> {
  bool mIsInWishList = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var productWidth = MediaQuery.of(context).size.width;

    String? img = widget.mProductModel!.images!.isNotEmpty ? widget.mProductModel!.images!.first.src : '';

    return GestureDetector(
      onTap: () async {
        setState(() {
          onClickProduct(context, widget.mProductModel!);
        });
      },
      child: Container(
        width: widget.width,
        padding: EdgeInsets.all(1.2),
        margin: EdgeInsets.all(4),
        decoration: widget.isHorizontal == true
            ? BoxDecoration()
            : BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [mDashboardGradient1, mDashboardGradient2],
                ),
              ),
        child: Container(
          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: Theme.of(context).cardTheme.color!),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: Theme.of(context).colorScheme.background),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    commonCacheImageWidget(img.validate(), height: 180, width: productWidth, fit: BoxFit.cover).cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8),
                    mSale(widget.mProductModel!),
                    ProductWishListExtension(mProductModel: widget.mProductModel!)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 2, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.mProductModel!.name, style: primaryTextStyle(), maxLines: 1),
                    2.height,
                    Row(
                      children: [
                        PriceWidget(
                          price: widget.mProductModel!.onSale == true
                              ? widget.mProductModel!.salePrice.validate().isNotEmpty
                                  ? double.parse(widget.mProductModel!.salePrice.toString()).toStringAsFixed(2)
                                  : double.parse(widget.mProductModel!.price.validate()).toStringAsFixed(2)
                              : widget.mProductModel!.regularPrice.validate().isNotEmpty
                                  ? double.parse(widget.mProductModel!.regularPrice.validate().toString()).toStringAsFixed(2)
                                  : double.parse(widget.mProductModel!.price.validate().toString()).toStringAsFixed(2),
                          size: 14,
                        ),
                        4.width,
                        PriceWidget(
                          price: widget.mProductModel!.regularPrice.validate().toString(),
                          size: 12,
                          isLineThroughEnabled: true,
                          color: Theme.of(context).textTheme.titleMedium!.color,
                        ).visible(widget.mProductModel!.salePrice.validate().isNotEmpty && widget.mProductModel!.onSale == true),
                      ],
                    ).visible(!widget.mProductModel!.type!.contains("grouped") && !widget.mProductModel!.type!.contains("variable")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
