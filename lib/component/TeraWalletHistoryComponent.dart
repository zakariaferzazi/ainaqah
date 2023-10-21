import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import '/../main.dart';
import '/../models/WalletResponse.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class TeraWalletHistoryComponent extends StatefulWidget {
  static String tag = '/TeraWalletHistoryComponent';
  final WalletResponse data;

  TeraWalletHistoryComponent(this.data);

  @override
  TeraWalletHistoryComponentState createState() => TeraWalletHistoryComponentState();
}

class TeraWalletHistoryComponentState extends State<TeraWalletHistoryComponent> {
  NumberFormat nf = NumberFormat('##.00');
  double? num1;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    num1 = widget.data.amount.toString().toDouble();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: primaryColor!.withOpacity(0.4),
          child: Icon(Fontisto.dollar, size: 16, color: primaryColor),
        ),
        10.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.data.details!.toString(), style: primaryTextStyle()).visible(widget.data.details.toString().isNotEmpty),
            6.height,
            Text(reviewConvertDate(widget.data.date!.toString()), style: secondaryTextStyle()),
          ],
        ).expand(),
        Row(
          children: [
            Icon(
              widget.data.type == "credit" ? Icons.add : Icons.remove,
              color: widget.data.type == "credit" ? Colors.green : Colors.red,
              size: 14,
            ),
            Text(getStringAsync(DEFAULT_CURRENCY) + num1.toString(), style: boldTextStyle(color: widget.data.type == "credit" ? Colors.green : Colors.red)),
          ],
        ),
      ],
    );
  }
}
