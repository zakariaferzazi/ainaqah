import 'package:flutter/material.dart';
import '/../models/ProductResponse.dart';
import '/../utils/ProductWishListExtension.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class Dashboard1ProductComponent extends StatefulWidget {
  static String tag = '/Product';
  final double? width;
  final ProductResponse? mProductModel;

  Dashboard1ProductComponent({Key? key, this.width, this.mProductModel}) : super(key: key);

  @override
  Dashboard1ProductComponentState createState() => Dashboard1ProductComponentState();
}

class Dashboard1ProductComponentState extends State<Dashboard1ProductComponent> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8.0), backgroundColor: Theme.of(context).colorScheme.background),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  commonCacheImageWidget(img.validate(), height: 170, width: productWidth, fit: BoxFit.cover).cornerRadiusWithClipRRect(8),
                  mSale(widget.mProductModel!),
                  ProductWishListExtension(mProductModel: widget.mProductModel)
                ],
              ),
            ),
            2.height,
            Text(widget.mProductModel!.name, style: primaryTextStyle(), maxLines: 1),
            Text(parseHtmlString(widget.mProductModel!.shortDescription!.isNotEmpty ? widget.mProductModel!.shortDescription : ''), style: secondaryTextStyle(size: 12), maxLines: 1)
                .visible(widget.mProductModel!.shortDescription!.isNotEmpty)
                .paddingTop(2),
            2.height,
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
                  size: 14,
                ),
                4.width,
                PriceWidget(price: widget.mProductModel!.regularPrice.validate().toString(), size: 12, isLineThroughEnabled: true, color: Theme.of(context).textTheme.titleMedium!.color)
                    .visible(widget.mProductModel!.salePrice.validate().isNotEmpty && widget.mProductModel!.onSale == true),
              ],
            ).visible(!widget.mProductModel!.type!.contains("grouped")&&!widget.mProductModel!.type!.contains("variable")).paddingOnly(bottom: 8),
          ],
        ),
      ),
    );
  }
}
