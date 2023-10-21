import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '/../models/ProductResponse.dart';
import '/../utils/Constants.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'DashBoard4Product.dart';

class DashboardComponent4 extends StatefulWidget {
  const DashboardComponent4({Key? key, required this.title, required this.subTitle, required this.product, required this.onTap}) : super(key: key);

  final String title, subTitle;
  final List<ProductResponse> product;
  final Function onTap;

  @override
  _DashboardComponent4State createState() => _DashboardComponent4State();
}

class _DashboardComponent4State extends State<DashboardComponent4> {
  Widget productList(List<ProductResponse> product) {
    return Container(
      margin: EdgeInsets.all(8),
      child: AlignedGridView.count(
        scrollDirection: Axis.vertical,
        itemCount: product.length >= TOTAL_DASHBOARD_ITEM ? TOTAL_DASHBOARD_ITEM : product.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return DashBoard4Product(mProductModel: product[i], width: context.width()).paddingAll(4);
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
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Image.asset(ic_halloween_heading, height: 100, fit: BoxFit.fill),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                2.height,
                Text(widget.title, style: primaryTextStyle(size: 24,fontFamily: GoogleFonts.bangers().fontFamily,color: white,letterSpacing: 2)),
                6.height,
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(child: Icon(Icons.add, size: 14, color: white.withOpacity(0.4))),
                      TextSpan(text: widget.subTitle, style: secondaryTextStyle(size: 14,color: white.withOpacity(0.4))),
                    ],
                  ),
                ).visible(widget.product.length >= TOTAL_DASHBOARD_ITEM),
              ],
            ).paddingOnly(left: 16, right: 16).visible(widget.product.isNotEmpty),
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
