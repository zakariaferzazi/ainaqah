import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/../models/ProductResponse.dart';
import '/../screen/VendorListScreen.dart';
import '/../screen/VendorProfileScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../AppLocalizations.dart';

class DashBoard5VendorComponent extends StatefulWidget {
  static String tag = '/DashBoard5VendorComponent';

  final List<VendorResponse> product;

  DashBoard5VendorComponent(this.product);

  @override
  DashBoard5VendorComponentState createState() => DashBoard5VendorComponentState();
}

class DashBoard5VendorComponentState extends State<DashBoard5VendorComponent> {
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

  @override
  Widget build(BuildContext context) {

    return HorizontalList(
      itemCount: widget.product.length,
      padding: EdgeInsets.only(left: 8, right: 8),
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () {
            VendorProfileScreen(mVendorId: widget.product[i].id).launch(context);
          },
          child: getDashboard5VendorWidget(widget.product[i], context),
        );
      },
    );
  }
}

Widget getDashboard5VendorWidget(VendorResponse vendor, BuildContext context, {double width = 300}) {
  var appLocalization = AppLocalizations.of(context)!;
  String img = vendor.banner!.isNotEmpty ? vendor.banner.validate() : '';

  String? addressText = "";
  if (vendor.address != null) {
    if (vendor.address!.state != null) {
      if (vendor.address!.state!.isNotEmpty) {
        if (addressText.isEmpty) {
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
    height: 220,
    margin: EdgeInsets.fromLTRB(6, 8, 0, 8),
    child: Stack(
      children: [
        Image.asset(ic_christmas_vendor, height: 250, width: width, fit: BoxFit.fitWidth).cornerRadiusWithClipRRect(8),
        Container(
          decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              commonCacheImageWidget(img, height: 140, width: width, fit: BoxFit.fill).cornerRadiusWithClipRRect(8).paddingAll(4),
              4.height,
              Text(vendor.storeName!, style: boldTextStyle()).center(),
              4.height,
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(child: Icon(Icons.add, size: 14, color: Colors.black)),
                    TextSpan(text:appLocalization.translate('lbl_explore')! , style: secondaryTextStyle(size: 14, color: Colors.black)),
                  ],
                ),
              ).center()
            ],
          ).paddingAll(2),
        ).paddingAll(8),
      ],
    ),
  );
}

Widget mVendor5Widget(BuildContext context, List<VendorResponse> mVendorModel, var title, var all, {size= 16}) {
  return mVendorModel.isNotEmpty
      ? Column(
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Text("#" + title, style: GoogleFonts.pacifico(color: mChristmasColor, fontSize: 28, fontWeight: FontWeight.bold)).paddingOnly(left: 12, right: 26),
                    Image.asset(ic_christmas_hat, height: 40, width: 40, fit: BoxFit.cover).paddingTop(12),
                  ],
                ),
                Text(all, style: secondaryTextStyle(color: mChristmasColor, size: 14)),
              ],
            ).onTap(() {
              VendorListScreen().launch(context);
            }),
            8.height,
            DashBoard5VendorComponent(mVendorModel)
          ],
        )
      : SizedBox();
}
