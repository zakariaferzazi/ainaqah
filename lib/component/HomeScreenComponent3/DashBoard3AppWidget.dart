import 'package:flutter/material.dart';
import '/../main.dart';
import '/../models/ProductResponse.dart';
import 'package:nb_utils/nb_utils.dart';


Widget mDashBoard3Sale(ProductResponse product) {
  return Positioned(
    left: 0,
    top: 0,
    child: Container(
      decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.red, borderRadius: radius(0)),
      child: Text("Sale", style: secondaryTextStyle(color: white, size: 12)),
      padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
    ),
  ).visible(product.onSale == true && product.type!.contains("grouped") && !product.type!.contains("variation"));
}

Widget viewAllNewDashBoard3(BuildContext context, {String? viewAll}) {
  return GestureDetector(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(viewAll!, style: secondaryTextStyle(size: 14, color: appStore.isDarkMode! ? white : gray)).paddingTop(3),
        Icon(Icons.chevron_right, size: 24, color: appStore.isDarkMode! ? white : gray),
      ],
    ),
  );
}

Widget viewAllDashBoard3(BuildContext context, {String? viewAll}) {
  return GestureDetector(
    child: Container(
        width: 80,
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(border: Border.all(color: appStore.isDarkMode! ? context.iconColor : white), borderRadius: BorderRadius.circular(8)),
        child: Text(viewAll!, style: boldTextStyle(color: appStore.isDarkMode! ? context.iconColor : white), textAlign: TextAlign.center)),
  );
}
