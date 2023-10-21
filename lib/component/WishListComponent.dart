import 'package:flutter/material.dart';
import '/../models/WishListResponse.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import '/../utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';
import '../AppLocalizations.dart';
import '../main.dart';

class WishListComponent extends StatefulWidget {
  static String tag = '/WishListComponent';
  final WishListResponse? mWishListModel;
  final Function onClick;

  WishListComponent({this.mWishListModel, required this.onClick});

  @override
  WishListComponentState createState() => WishListComponentState();
}

class WishListComponentState extends State<WishListComponent> {
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
    var appLocalization = AppLocalizations.of(context)!;

    return Container(
      decoration: boxDecorationWithRoundedCorners(backgroundColor: Theme.of(context).cardTheme.color!, border: Border.all(color: Theme.of(context).colorScheme.background)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              widget.mWishListModel!.full == null
                  ? commonCacheImageWidget(widget.mWishListModel!.gallery![0].validate(), height: 150, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8)
                  : commonCacheImageWidget(widget.mWishListModel!.full, height: 150, width: context.width(), fit: BoxFit.cover)
                      .visible(widget.mWishListModel!.full!.isNotEmpty)
                      .cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.red, borderRadius: radiusOnly(topLeft: 8)),
                    child: Text(appLocalization.translate('lbl_sale')!, style: secondaryTextStyle(color: white, size: 12)),
                    padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                  ).visible(widget.mWishListModel!.salePrice!.isNotEmpty),
                  Container(
                    margin: EdgeInsets.all(6),
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardTheme.color),
                    child: Icon(Icons.close, color: Theme.of(context).textTheme.titleSmall!.color, size: 16),
                  ).onTap(() async {
                    showConfirmDialogCustom(
                      context,
                      primaryColor: primaryColor,
                      title: appLocalization.translate("msg_remove"),
                      positiveText: appLocalization.translate("lbl_yes"),
                      negativeText: appLocalization.translate("lbl_no"),
                      onAccept: (c) async {
                        log("value");
                        await wishListStore.addToWishList(widget.mWishListModel!);
                        setState(() {});
                      },
                    );
                  })
                ],
              )
            ],
          ),
          8.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.mWishListModel!.name!, style: primaryTextStyle(), maxLines: 2).paddingOnly(left: 8, right: 8),
              8.height,
              Row(
                children: <Widget>[
                  PriceWidget(price: widget.mWishListModel!.salePrice!.isNotEmpty ? widget.mWishListModel!.salePrice.toString() : widget.mWishListModel!.price.toString(), size: 16),
                  4.width,
                  PriceWidget(price: widget.mWishListModel!.regularPrice.toString(), size: 14, color: Theme.of(context).textTheme.titleMedium!.color, isLineThroughEnabled: true)
                      .visible(widget.mWishListModel!.salePrice.validate().isNotEmpty),
                ],
              ).paddingOnly(left: 8, right: 8),
              Divider(color: view_color),
              if (widget.mWishListModel!.inStock == false)
                Text(appLocalization.translate('lbl_sold_out')!, style: boldTextStyle(color: greyColor)).paddingOnly(top: 6, bottom: 10).center()
              else
                Text(
                        cartStore.isItemInCart(widget.mWishListModel!.proId.validate())
                            ? appLocalization.translate('lbl_remove_cart')!.toUpperCase()
                            : appLocalization.translate('lbl_add_to_cart')!.toUpperCase(),
                        style: boldTextStyle())
                    .paddingOnly(top: 6, bottom: 10)
                    .center()
                    .onTap(
                  () async {
                    addCart(mData: widget.mWishListModel!);
                  },
                ),
            ],
          )
        ],
      ),
    );
  }
}
