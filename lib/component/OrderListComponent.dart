import 'package:flutter/material.dart';
import '/../models/OrderModel.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';

Widget orderListWidget(context, List<OrderResponse> mOrderModel, Function(int index) onCall) {
  var appLocalization = AppLocalizations.of(context)!;
  return AnimatedListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: mOrderModel.length,
      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
      itemBuilder: (context, i) {
        return Container(
          margin: EdgeInsets.all(8),
          decoration: boxDecorationWithShadow(backgroundColor: context.cardColor, borderRadius: radius(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              10.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (mOrderModel[i].lineItems!.isNotEmpty.validate())
                    if (mOrderModel[i].lineItems![0].productImages![0].src!.isNotEmpty.validate())
                      commonCacheImageWidget(mOrderModel[i].lineItems![0].productImages![0].src.validate(), height: 70, width: 70, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      8.height,
                      if (mOrderModel[i].lineItems!.isNotEmpty)
                        if (mOrderModel[i].lineItems!.length > 1)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mOrderModel[i].lineItems![0].name.validate(), maxLines: 2, overflow: TextOverflow.ellipsis, style: primaryTextStyle()),
                              4.height,
                              Text(appLocalization.translate("lbl_more_item")!, style: secondaryTextStyle(color: primaryColor!.withOpacity(0.5))),
                            ],
                          )
                        else
                          Text(mOrderModel[i].lineItems![0].name.validate(), maxLines: 2, overflow: TextOverflow.ellipsis, style: primaryTextStyle())
                      else
                        Text(mOrderModel[i].id.toString().validate(), style: primaryTextStyle(size: 18)),
                      6.height,
                      Row(
                        children: [
                          PriceWidget(price: mOrderModel[i].total.toString(), size: 14, color: Theme.of(context).textTheme.titleSmall!.color).expand(),
                          Text(mOrderModel[i].status!.toUpperCase().toString(), style: boldTextStyle(color: statusColor(mOrderModel[i].status)))
                        ],
                      ),
                    ],
                  ).expand(),
                ],
              ),
              10.height,
            ],
          ).paddingOnly(left: 10, right: 10).onTap(() async {
            onCall(i);
          }),
        );
      });
}
