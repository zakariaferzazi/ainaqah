import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '/../models/ProductResponse.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'DashBoard2Product.dart';

class DashboardComponent2 extends StatefulWidget {
  const DashboardComponent2({Key? key, required this.title, required this.subTitle, required this.product, required this.onTap}) : super(key: key);

  final String title, subTitle;
  final List<ProductResponse> product;
  final Function onTap;

  @override
  _DashboardComponent2State createState() => _DashboardComponent2State();
}

class _DashboardComponent2State extends State<DashboardComponent2> {
  Widget productList(List<ProductResponse> product) {
    return Container(
      margin: EdgeInsets.all(8),
      child: AlignedGridView.count(
        scrollDirection: Axis.vertical,
        itemCount: product.length >= TOTAL_DASHBOARD_ITEM ? TOTAL_DASHBOARD_ITEM : product.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return DashBoard2Product(mProductModel: product[i], width: context.width(),isHorizontal: false).paddingAll(4);
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 1.5, width: 24, color: context.iconColor),
            8.width,
            Text(widget.title, style: GoogleFonts.alata(fontSize: 24, color: context.iconColor)),
            8.width,
            Container(height: 1.5, width: 24, color: context.iconColor),
          ],
        ).paddingOnly(left: 12, right: 12, bottom: 8).visible(widget.product.isNotEmpty),
        viewAll(widget.onTap, widget.subTitle).visible(widget.product.length >= TOTAL_DASHBOARD_ITEM),
        productList(widget.product).visible(widget.product.isNotEmpty),
      ],
    );
  }
}

Widget viewAll(Function onTap, String subTitle) {
  return TextIcon(onTap: onTap, prefix: Icon(Icons.add, size: 18), text: subTitle, textStyle: secondaryTextStyle());
}
