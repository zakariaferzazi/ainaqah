import 'package:flutter/material.dart';
import '/../models/ProductResponse.dart';
import '/../screen/VendorProfileScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../AppLocalizations.dart';

class DashBoard4VendorComponent extends StatefulWidget {
  static String tag = '/DashBoard4VendorComponent';

  final List<VendorResponse> product;

  DashBoard4VendorComponent(this.product);

  @override
  DashBoard4VendorComponentState createState() => DashBoard4VendorComponentState();
}

class DashBoard4VendorComponentState extends State<DashBoard4VendorComponent> {
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
          child: getDashboard4VendorWidget(widget.product[i], context),
        );
      },
    );
  }
}

Widget getDashboard4VendorWidget(VendorResponse vendor, BuildContext context, {double width = 250}) {
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
    height: 285,
    margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
    child: Stack(
      children: [
        Image.asset(ic_halloween_vendor, height: 285, width: width, fit: BoxFit.fitWidth),
        Stack(
          children: [
            Container(
              color: mHalloweenCard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  commonCacheImageWidget(img, height: 200, width: width, fit: BoxFit.fill).paddingAll(4),
                  4.height,
                  Text(vendor.storeName!, style: boldTextStyle(color: white)).center(),
                  4.height,
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(child: Icon(Icons.add, size: 14, color: white.withOpacity(0.4))),
                        TextSpan(text: appLocalization.translate('lbl_light'), style: secondaryTextStyle(size: 14, color: white.withOpacity(0.4))),
                      ],
                    ),
                  ).center()
                ],
              ),
            ).paddingAll(2),
          ],
        ).paddingAll(8),
        // Image.asset(ic_halloween_category_border3,fit: BoxFit.fitHeight),
      ],
    ),
  );
}
