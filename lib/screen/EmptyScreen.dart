import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '/../AppLocalizations.dart';
import 'package:nb_utils/nb_utils.dart';

class EmptyScreen extends StatefulWidget {
  static String tag = '/EmptyScreen';

  @override
  EmptyScreenState createState() => EmptyScreenState();
}

class EmptyScreenState extends State<EmptyScreen> {
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
    var appLocalization = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(MaterialCommunityIcons.emoticon_cry_outline, size: 120,color: context.iconColor),
        Text(appLocalization.translate('lbl_data_not_found')!, style: boldTextStyle(size: 24)).paddingAll(16),
      ],
    ).center();
  }
}
