import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '/../models/ProductResponse.dart';
import '/../utils/Constants.dart';
import '/../utils/DashedRectangle.dart';
import 'package:nb_utils/nb_utils.dart';

import 'DashBoard3AppWidget.dart';
import 'DashBoard3Product.dart';

class DashboardComponent3 extends StatefulWidget {
  const DashboardComponent3({Key? key, required this.title, required this.subTitle, required this.product, required this.onTap}) : super(key: key);

  final String title, subTitle;
  final List<ProductResponse> product;
  final Function onTap;

  @override
  _DashboardComponent3State createState() => _DashboardComponent3State();
}

class _DashboardComponent3State extends State<DashboardComponent3> {
  Widget productList(List<ProductResponse> product) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 8),
      child: AlignedGridView.count(
        scrollDirection: Axis.vertical,
        itemCount: product.length >= TOTAL_DASHBOARD_ITEM ? TOTAL_DASHBOARD_ITEM : product.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return DashBoard3Product(mProductModel: product[i], width: context.width());
        },
        crossAxisCount: 2,

        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.title, style: GoogleFonts.alata(fontSize: 23, color: context.iconColor)),
            4.height,
            SizedBox(width: context.width() * 0.48, child: DashedRectangle(gap: 3, color: context.iconColor)),
          ],
        ).visible(widget.product.isNotEmpty),
        4.height,
        viewAllNewDashBoard3(context, viewAll: widget.subTitle).onTap(() {
          widget.onTap.call();
        }).visible(widget.product.length >= TOTAL_DASHBOARD_ITEM),
        productList(widget.product).visible(widget.product.isNotEmpty),
      ],
    );
  }
}
