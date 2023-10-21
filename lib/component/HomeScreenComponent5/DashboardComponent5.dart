import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '/../models/ProductResponse.dart';
import '/../utils/Colors.dart';
import '/../utils/Constants.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';

import 'DashBoard5Product.dart';

class DashboardComponent5 extends StatefulWidget {
  const DashboardComponent5({Key? key, required this.title, required this.subTitle, required this.product, required this.onTap}) : super(key: key);

  final String title, subTitle;
  final List<ProductResponse> product;
  final Function onTap;

  @override
  _DashboardComponent5State createState() => _DashboardComponent5State();
}

class _DashboardComponent5State extends State<DashboardComponent5> {
  Widget productList(List<ProductResponse> product) {
    return Container(
      margin: EdgeInsets.all(8),
      child: AlignedGridView.count(
        scrollDirection: Axis.vertical,
        itemCount: product.length >= TOTAL_DASHBOARD_ITEM ? TOTAL_DASHBOARD_ITEM : product.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return DashBoard5Product(mProductModel: product[i], width: context.width(), isHorizontal: false).paddingAll(4);
        },
        crossAxisCount: 2,

        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Text("#" + widget.title, style: GoogleFonts.pacifico(color: mChristmasColor, fontSize: 28, fontWeight: FontWeight.bold)).paddingOnly(left: 12, right: 26),
                Image.asset(ic_christmas_hat, height: 40, width: 40, fit: BoxFit.cover).paddingTop(12),
              ],
            ),
            Text(widget.subTitle, style: secondaryTextStyle(color: mChristmasColor, size: 14)),
          ],
        ).onTap(() {
          widget.onTap.call();
        }),
        8.height,
        productList(widget.product).visible(widget.product.isNotEmpty),
      ],
    );
  }
}
