import 'package:flutter/material.dart';
import '/../main.dart';
import '/../utils/Colors.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class AppBarWidget extends StatelessWidget {
  final Widget? child;

  AppBarWidget({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isHalloween ? mChristmasColor :  primaryColor,
      child: child,
    );
  }
}

class BodyCornerWidget extends StatelessWidget {
  final Widget child;
  final Color? color;

  BodyCornerWidget({required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      child: Container(
        color: color ?? context.scaffoldBackgroundColor,
        height: context.height(),
        width: context.width(),
        child: child,
      ).cornerRadiusWithClipRRectOnly(
        topRight: 30,
        topLeft: 30,
      ),
    );
  }
}
