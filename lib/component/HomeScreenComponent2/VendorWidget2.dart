import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/../models/ProductResponse.dart';
import '/../screen/VendorListScreen.dart';
import '/../screen/VendorProfileScreen.dart';
import '/../utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';

import 'DashboardComponent2.dart';

Widget getVendorDashBoard2Widget(VendorResponse vendor, BuildContext context, {double width = 260}) {
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
    decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(16),backgroundColor: Colors.transparent),
    margin: EdgeInsets.all(8.0),
    child: Stack(
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(8), child: commonCacheImageWidget(img, height: 150, width: width, fit: BoxFit.fill)),
        Positioned(
          top: 100,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            width: 245,
            padding: EdgeInsets.only(left: 16, right: 8, bottom: 4),
            decoration: boxDecorationRoundedWithShadow(8, blurRadius: 0.3, spreadRadius: 0.2, shadowColor: gray.withOpacity(0.3), backgroundColor: Theme.of(context).cardTheme.color!),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                4.height,
                Text(vendor.storeName!, maxLines:1,style: boldTextStyle()),
                4.height,
                Text(addressText!, maxLines: 2, style: primaryTextStyle()),
              ],
            ),
          ),
        )
      ],
    ).withHeight(200),
  );
}

Widget vendorDashBoard2List(List<VendorResponse> product) {
  return Container(
    height: 220,
    alignment: Alignment.centerLeft,
    child: AnimatedListView(
      itemCount: product.length,
      padding: EdgeInsets.only(left: 8, right: 8),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () {
            VendorProfileScreen(mVendorId: product[i].id).launch(context);
          },
          child: Column(
            children: [
              getVendorDashBoard2Widget(product[i], context),
            ],
          ),
        );
      },
    ),
  );
}

Widget mVendorDashBoard2Widget(BuildContext context, List<VendorResponse> mVendorModel, var title, var all, {size= 16}) {
  return mVendorModel.isNotEmpty
      ? Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 1.5, width: 24, color: context.iconColor),
                8.width,
                Text(title, style: GoogleFonts.alata(fontSize: 24, color: context.iconColor)),
                8.width,
                Container(height: 1.5, width: 24, color: context.iconColor),
              ],
            ).paddingOnly(left: 16, right: 16).visible(mVendorModel.isNotEmpty),
            8.height,
            viewAll(() {
              VendorListScreen().launch(context);
            }, all),
            vendorDashBoard2List(mVendorModel)
          ],
        )
      : SizedBox();
}
