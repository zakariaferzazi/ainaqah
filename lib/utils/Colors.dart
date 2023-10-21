import 'package:flutter/material.dart';

import '../main.dart';

const appColorPrimary = Color(0xFF4358DD);
const appColorAccent = Color(0xFF2635DF);
const textColorPrimary = Color(0xFF212121);
const textColorSecondary = Color(0xFF757575);
const view_color = Color(0xFFDADADA);
const yellowColor = Color(0xFFFEBA39);
const greyColor = Color(0xFFccd5e1);
const itemBackgroundColor = Color(0xFFF2F1ED);

const bgCardColor = Color(0xFFc9DAF9);

const scaffoldSecondaryDark = Color(0xFF1E1E1E);

const mHalloweenBackground = "#2b2b2b";
const mHalloweenBackgroundColor = Color(0xFF2b2b2b);
const mHalloweenYellow = Color(0xFFFFC430);
const mHalloweenCard = Color(0xFF222222);
const mHalloweenSale = Color(0xFF222222);


const mDashboardGradient1= Color(0xFF37D5D6);
const mDashboardGradient2= Color(0xFF63A4FF);

const pendingColor = Color(0xFFff9762);
const completeColor = Color(0xFF4aa832);
const processingColor = Color(0xFFab156a);
const cancelledColor = Color(0xFFc4241b);
const refundedColor = Color(0xFF4aa832);
const failedColor = Color(0xFFc4241b);

const mChristmasColor = Color(0xffa9000b);
const mChristmasBg='#a9000b';


Color statusColor(String? status) {
  Color color = primaryColor!;
  switch (status) {
    case "pending":
      return pendingColor;
    case "processing":
      return processingColor;
    case "on-hold":
      return primaryColor!;
    case "completed":
      return completeColor;
    case "cancelled":
      return cancelledColor;
    case "refunded":
      return refundedColor;
    case "failed":
      return failedColor;
    case "any":
      return primaryColor!;
  }
  return color;
}