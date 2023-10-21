import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';

class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(MaterialCommunityIcons.wifi_off, size: 80),
          20.height,
          Text(appLocalization!.translate('lbl_no_internet')!, style: boldTextStyle(size: 24, color: Theme.of(context).textTheme.titleMedium!.color)),
          4.height,
          Text(appLocalization.translate('lbl_no_internet_msg')!, style: secondaryTextStyle(size: 14), textAlign: TextAlign.center).paddingOnly(left: 20, right: 20),
        ],
      ),
    );
  }
}
