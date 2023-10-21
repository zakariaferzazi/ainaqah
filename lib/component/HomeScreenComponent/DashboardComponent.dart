import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '/../models/ProductResponse.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import 'Dashboard1ProductComponent.dart';

class DashboardComponent extends StatefulWidget {
  const DashboardComponent({Key? key, required this.title, required this.subTitle, required this.product, required this.onTap}) : super(key: key);

  final String title, subTitle;
  final List<ProductResponse> product;
  final Function onTap;

  @override
  _DashboardComponentState createState() => _DashboardComponentState();
}

class _DashboardComponentState extends State<DashboardComponent> {
  Widget productList(List<ProductResponse> product) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: AlignedGridView.count(
        scrollDirection: Axis.vertical,
        itemCount: product.length >= TOTAL_DASHBOARD_ITEM ? TOTAL_DASHBOARD_ITEM : product.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return Dashboard1ProductComponent(mProductModel: product[i], width: context.width()).paddingAll(4);
        },
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: boldTextStyle()),
            Text(widget.subTitle, style: boldTextStyle(color: primaryColor)).onTap(() {
              widget.onTap.call();
            }).visible(widget.product.length >= TOTAL_DASHBOARD_ITEM),
          ],
        ).paddingOnly(left: 16, right: 16).visible(widget.product.isNotEmpty),
        productList(widget.product).visible(widget.product.isNotEmpty),
      ],
    );
  }
}
