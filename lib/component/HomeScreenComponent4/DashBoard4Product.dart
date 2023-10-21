import 'package:flutter/material.dart';
import '/../models/ProductResponse.dart';
import '/../utils/ProductWishListExtension.dart';
import '/../utils/AppWidget.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';

class DashBoard4Product extends StatefulWidget {
  static String tag = '/Product';
  final double? width;
  final ProductResponse? mProductModel;

  DashBoard4Product({Key? key, this.width, this.mProductModel}) : super(key: key);

  @override
  ProductState createState() => ProductState();
}

class ProductState extends State<DashBoard4Product> {
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
        child: Stack(
          children: [
            Image.asset(ic_halloween_product_frame1, height: 265, fit: BoxFit.fill, width: widget.width),
            Container(
              width: widget.width,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      commonCacheImageWidget(img.validate(), height: 190, width: widget.width, fit: BoxFit.cover),
                      mSale(widget.mProductModel!),
                      ProductWishListExtension(mProductModel: widget.mProductModel!).paddingOnly(left: 4),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 8, 8, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.mProductModel!.name, style: primaryTextStyle(color: white), maxLines: 1),
                        4.height,
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
                              color: white,
                            ),
                            4.width,
                            PriceWidget(
                              price: widget.mProductModel!.regularPrice.validate().toString(),
                              size: 12,
                              isLineThroughEnabled: true,
                              color: white.withOpacity(0.4),
                            ).visible(widget.mProductModel!.salePrice.validate().isNotEmpty && widget.mProductModel!.onSale == true),
                          ],
                        ).visible(!widget.mProductModel!.type!.contains("grouped") && !widget.mProductModel!.type!.contains("variable")).paddingOnly(bottom: 8),
                      ],
                    ),
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
