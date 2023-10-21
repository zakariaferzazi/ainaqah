import 'package:flutter/material.dart';
import '/../models/ProductResponse.dart';
import '/../screen/VendorListScreen.dart';
import '/../screen/VendorProfileScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

Widget getVendorWidget(VendorResponse vendor, BuildContext context, {double width = 300}) {
  String img = vendor.banner!.isNotEmpty ? vendor.banner.validate() : '';

  String? addressText = "";
  if (vendor.address != null) {
    if (vendor.address!.street_1 != null) {
      if (vendor.address!.street_1!.isNotEmpty && addressText.isEmpty) {
        addressText = vendor.address!.street_1;
      }
    }
    if (vendor.address!.street_2 != null) {
      if (vendor.address!.street_2!.isNotEmpty) {
        if (addressText!.isEmpty) {
          addressText = vendor.address!.street_2;
        } else {
          addressText += ", " + vendor.address!.street_2!;
        }
      }
    }
    if (vendor.address!.city != null) {
      if (vendor.address!.city!.isNotEmpty) {
        if (addressText!.isEmpty) {
          addressText = vendor.address!.city;
        } else {
          addressText += ", " + vendor.address!.city!;
        }
      }
    }

    if (vendor.address!.zip != null) {
      if (vendor.address!.zip!.isNotEmpty) {
        if (addressText!.isEmpty) {
          addressText = vendor.address!.zip;
        } else {
          addressText += " - " + vendor.address!.zip!;
        }
      }
    }
    if (vendor.address!.state != null) {
      if (vendor.address!.state!.isNotEmpty) {
        if (addressText!.isEmpty) {
          addressText = vendor.address!.state;
        } else {
          addressText += ", " + vendor.address!.state!;
        }
      }
    }
    if (vendor.address!.country != null) {
      if (!vendor.address!.country!.isNotEmpty) {
        if (addressText!.isEmpty) {
          addressText = vendor.address!.country;
        } else {
          addressText += ", " + vendor.address!.country!;
        }
      }
    }
  }

  return Container(
    width: width,
    margin: EdgeInsets.all(8.0),
    decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        commonCacheImageWidget(img, height: 140, width: width, fit: BoxFit.cover).cornerRadiusWithClipRRect(8),
        Row(
          children: [
            CircleAvatar(backgroundColor: context.cardColor, backgroundImage: NetworkImage(vendor.avatar!), radius: 30),
            10.width,
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(vendor.storeName!, style: boldTextStyle()),
                Text(addressText!, maxLines: 2, style: primaryTextStyle(size: 14)),
              ],
            ).expand(),
          ],
        ).paddingAll(12),
      ],
    ),
  );
}

Widget vendorList(List<VendorResponse> product) {
  return HorizontalList(
    itemCount: product.length >= TOTAL_DASHBOARD_ITEM ? TOTAL_DASHBOARD_ITEM : product.length,
    padding: EdgeInsets.only(left: 8, right: 8),
    itemBuilder: (context, i) {
      return GestureDetector(
        onTap: () {
          VendorProfileScreen(mVendorId: product[i].id).launch(context);
        },
        child: getVendorWidget(product[i], context),
      );
    },
  );
}

Widget mVendorWidget(BuildContext context, List<VendorResponse> mVendorModel, var title, var all, {size= 16}) {
  return mVendorModel.isNotEmpty
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: boldTextStyle(size: size)),
                Text(all, style: boldTextStyle(color: primaryColor)).onTap(() {
                  VendorListScreen().launch(context);
                }).visible(mVendorModel.length >= TOTAL_DASHBOARD_ITEM)
              ],
            ).paddingOnly(left: 16, right: 16).visible(mVendorModel.isNotEmpty),
            8.height,
            vendorList(mVendorModel)
          ],
        )
      : SizedBox();
}
