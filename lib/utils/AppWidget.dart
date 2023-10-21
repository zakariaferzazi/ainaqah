import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import '/../main.dart';
import '/../models/ProductResponse.dart';
import '/../models/WalkModel.dart';
import '/../utils/FestivalProgress.dart';
import '/../utils/Colors.dart';
import '/../utils/Constants.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'Common.dart';

// ignore: must_be_immutable
class EditText extends StatefulWidget {
  var isPassword;
  var hintText;
  var isSecure;
  int fontSize;
  var textColor;
  var fontFamily;
  var text;
  var maxLine;
  Function? validator;
  Function? onChanged;
  TextEditingController? mController;
  VoidCallback? onPressed;

  EditText({
    var this.fontSize = 16,
    var this.textColor = textColorSecondary,
    var this.hintText = '',
    var this.isPassword = true,
    var this.isSecure = false,
    var this.text = "",
    this.onChanged,
    this.validator,
    var this.mController,
    var this.maxLine = 1,
  });

  @override
  State<StatefulWidget> createState() {
    return EditTextState();
  }
}

class EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isSecure) {
      return TextFormField(
        controller: widget.mController,
        obscureText: widget.isPassword,
        cursorColor: primaryColor,
        maxLines: widget.maxLine,
        autofocus: true,
        style: TextStyle(
            fontSize: widget.fontSize.toDouble(),
            color: Theme.of(context).textTheme.titleMedium!.color,
            fontFamily: widget.fontFamily),
        onChanged: widget.onChanged as void Function(String)?,
        validator: widget.validator as String? Function(String?)?,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 12, 4, 12),
          labelText: widget.hintText,
          labelStyle: primaryTextStyle(
              color: Theme.of(context).textTheme.titleMedium!.color),
          enabledBorder: OutlineInputBorder(
            borderRadius: radius(8),
            borderSide: BorderSide(
                color: Theme.of(context).textTheme.titleMedium!.color!,
                width: 0.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: radius(8),
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: radius(8),
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          errorMaxLines: 2,
          errorStyle: primaryTextStyle(color: Colors.red, size: 12),
          focusedBorder: OutlineInputBorder(
            borderRadius: radius(8),
            borderSide: BorderSide(
                color: Theme.of(context).textTheme.titleMedium!.color!,
                width: 0.0),
          ),
        ),
      );
    } else {
      return TextFormField(
        controller: widget.mController,
        obscureText: widget.isPassword,
        cursorColor: primaryColor,
        validator: widget.validator as String? Function(String?)?,
        style: TextStyle(
            fontSize: widget.fontSize.toDouble(),
            color: Theme.of(context).textTheme.titleMedium!.color,
            fontFamily: widget.fontFamily),
        decoration: InputDecoration(
          suffixIcon: new GestureDetector(
            onTap: () {
              setState(() {
                widget.isPassword = !widget.isPassword;
              });
            },
            child: new Icon(
              widget.isPassword ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).textTheme.titleMedium!.color,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 14, 4, 14),
          labelText: widget.hintText,
          labelStyle: primaryTextStyle(
              color: Theme.of(context).textTheme.titleMedium!.color),
          // filled: true,
          // fillColor: Theme.of(context).textTheme.headline4.color,
          enabledBorder: OutlineInputBorder(
            borderRadius: radius(8),
            borderSide: BorderSide(
                color: Theme.of(context).textTheme.titleMedium!.color!,
                width: 0.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: radius(8),
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: radius(8),
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          errorMaxLines: 2,
          errorStyle: primaryTextStyle(color: Colors.red, size: 12),
          focusedBorder: OutlineInputBorder(
            borderRadius: radius(8),
            borderSide: BorderSide(
                color: Theme.of(context).textTheme.titleMedium!.color!,
                width: 0.0),
          ),
        ),
      );
    }
  }
}

// ignore: must_be_immutable
class SimpleEditText extends StatefulWidget {
  bool isPassword;
  bool isSecure;
  int fontSize;
  var textColor;
  var fontFamily;
  var text;
  var maxLine;
  Function? validator;
  TextInputType? keyboardType;
  var hintText;

  TextEditingController? mController;

  VoidCallback? onPressed;

  SimpleEditText(
      {this.fontSize = 20,
      this.textColor = textColorPrimary,
      this.isPassword = false,
      this.isSecure = true,
      this.text = '',
      this.mController,
      this.maxLine = 1,
      this.hintText = '',
      this.keyboardType,
      this.validator});

  @override
  State<StatefulWidget> createState() {
    return SimpleEditTextState();
  }
}

class SimpleEditTextState extends State<SimpleEditText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.mController,
      obscureText: widget.isPassword,
      cursorColor: primaryColor,
      validator: widget.validator as String? Function(String?)?,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 14, 4, 14),
        labelText: widget.hintText,
        labelStyle: primaryTextStyle(
            color: Theme.of(context).textTheme.titleMedium!.color),
        // filled: true,
        // fillColor: Theme.of(context).textTheme.headline4.color,

        enabledBorder: OutlineInputBorder(
            borderRadius: radius(8),
            borderSide: BorderSide(
                color: Theme.of(context).textTheme.titleMedium!.color!,
                width: 0.0)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: radius(8),
            borderSide: BorderSide(color: Colors.red, width: 1.0)),
        errorBorder: OutlineInputBorder(
            borderRadius: radius(8),
            borderSide: BorderSide(color: Colors.red, width: 1.0)),
        errorMaxLines: 2,
        errorStyle: primaryTextStyle(color: Colors.red, size: 12),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius(8),
          borderSide: BorderSide(
              color: Theme.of(context).textTheme.titleMedium!.color!,
              width: 0.0),
        ),
      ),
    ).paddingBottom(16);
  }
}

enum ConfirmAction { CANCEL, ACCEPT }

Future<ConfirmAction?> showConfirmDialogs(
    context, msg, positiveText, negativeText) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: Text(msg, style: TextStyle(fontSize: 16, color: primaryColor)),
        actions: <Widget>[
          TextButton(
            child: Text(negativeText,
                style: primaryTextStyle(
                    color: Theme.of(context).textTheme.titleMedium!.color)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          TextButton(
            child: Text(positiveText,
                style: primaryTextStyle(color: primaryColor)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

// ignore: must_be_immutable
class PriceWidget extends StatefulWidget {
  static String tag = '/PriceWidget';
  var price;
  double? size = 22.0;
  Color? color;
  var isLineThroughEnabled = false;

  PriceWidget(
      {Key? key,
      this.price,
      this.color,
      this.size,
      this.isLineThroughEnabled = false})
      : super(key: key);

  @override
  PriceWidgetState createState() => PriceWidgetState();
}

class PriceWidgetState extends State<PriceWidget> {
  var currency = '₹';

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    setState(() {
      currency = getStringAsync(DEFAULT_CURRENCY);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLineThroughEnabled) {
      return Text('$currency${widget.price.toString().replaceAll(".00", "")}',
              style: GoogleFonts.robotoSerif(
                  fontSize: widget.size,
                  color: widget.color != null ? widget.color : primaryColor))
          .paddingOnly(right: 4);
    } else {
      return widget.price.toString().isNotEmpty
          ? Text('$currency${widget.price.toString().replaceAll(".00", "")}',
              style: GoogleFonts.robotoSerif(
                  fontSize: widget.size,
                  color: widget.color ?? textPrimaryColor,
                  decoration: TextDecoration.lineThrough))
          : Text('');
    }
  }
}

Widget mCart(BuildContext context, bool mIsLoggedIn,
    {Color color = Colors.white}) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Icon(Icons.shopping_bag_outlined, color: white, size: 26).onTap(() {
        checkLoggedIn(context);
      }).paddingRight(14),
      if (appStore.count.toString() != "0")
        Positioned(
          top: 8,
          right: 10,
          child: Observer(
            builder: (_) => CircleAvatar(
              maxRadius: 7,
              minRadius: 5,
              backgroundColor: color,
              child: FittedBox(
                  child: Text('${appStore.count}',
                      style: Theme.of(context).textTheme.displaySmall)),
            ),
          ),
        ).visible(mIsLoggedIn ||
            getBoolAsync(IS_GUEST_USER, defaultValue: false) == true)
    ],
  );
}

Widget mTop(BuildContext context, var title,
    {List<Widget>? actions, bool showBack = false}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(60.0),
    child: AppBar(
      elevation: 0,
      backgroundColor: isHalloween ? mChristmasColor : primaryColor,
      leading: showBack
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: white),
              onPressed: () {
                finish(context);
                appStore.setLoading(false);
              },
            )
          : null,
      actions: actions,
      title: Text(title, style: boldTextStyle(color: Colors.white, size: 18)),
      automaticallyImplyLeading: false,
    ),
  );
}

Widget mTopNew(BuildContext context, var title,
    {List<Widget>? actions, bool showBack = false}) {
  return AppBar(
    elevation: 0,
    backgroundColor: primaryColor,
    leading: showBack
        ? IconButton(
            icon: Icon(Icons.arrow_back, color: white),
            onPressed: () {
              finish(context);
            },
          )
        : null,
    actions: actions,
    title: Text(title, style: boldTextStyle(color: Colors.white, size: 18)),
    automaticallyImplyLeading: false,
  );
}

Widget mView(Widget widget, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: boxDecorationWithRoundedCorners(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor),
    child: widget,
  );
}

Widget mProgress() {
  return isHalloween
      ? FestivalProgress()
      : Container(
          alignment: Alignment.center,
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 4,
            margin: EdgeInsets.all(4),
            shape: RoundedRectangleBorder(borderRadius: radius(50)),
            child: Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                  strokeWidth: 3, color: primaryColor),
            ),
          ),
        );
}

Widget mFestivalProgress() {
  return Container(
    alignment: Alignment.center,
    child: Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 4,
      margin: EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: radius(50)),
      child: Container(
        width: 45,
        height: 45,
        padding: EdgeInsets.all(8),
        child: Image.asset(ic_christmas_tree),
      ),
    ),
  );
}

Widget mSale(ProductResponse product) {
  return Positioned(
    left: 0,
    top: 0,
    child: Container(
      decoration: boxDecorationWithRoundedCorners(
          backgroundColor: Colors.red, borderRadius: radiusOnly(topLeft: 8)),
      child: Text("Sale", style: secondaryTextStyle(color: white, size: 12)),
      padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
    ),
  ).visible(product.onSale == true &&
      product.type!.contains("grouped") &&
      !product.type!.contains("variation"));
}

Widget commonCacheImageWidget(String? url,
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    bool usePlaceholderIfUrlEmpty = true,
    double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        radius: radius);
  } else if (url.validate().startsWith('http')) {
    return Image.network(
      url!,
      height: height,
      width: width,
      fit: fit,
      errorBuilder:
          (BuildContext? context, Object? exception, StackTrace? stackTrace) {
        return Image.asset(ic_placeHolder,
                height: height,
                width: width,
                fit: fit,
                alignment: alignment ?? Alignment.center)
            .cornerRadiusWithClipRRect(radius ?? defaultRadius);
      },
      alignment: alignment as Alignment? ?? Alignment.center,
    );
  } else {
    return Image.asset(ic_placeHolder,
            height: height,
            width: width,
            fit: fit,
            alignment: alignment ?? Alignment.center)
        .cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget(
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    double? radius}) {
  return Image.asset(ic_placeHolder,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          alignment: alignment ?? Alignment.center)
      .cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

void openPhotoViewer(context, ImageProvider imageProvider) {
  Scaffold(
    body: Stack(
      children: <Widget>[
        PhotoView(
          imageProvider: imageProvider,
          minScale: PhotoViewComputedScale.contained,
          maxScale: 1.0,
        ),
        Positioned(top: 35, left: 16, child: BackButton(color: Colors.white)),
      ],
    ),
  ).launch(context);
}

List<WalkModel> getWalkData() {
  List<WalkModel> featured = [];
  featured.add(WalkModel.info(ic_halloween_walk1, "Welcome to Ainaqah",
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry."));
  featured.add(WalkModel.info(ic_halloween_walk2, "Checkout",
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry."));
  featured.add(WalkModel.info(ic_halloween_walk3, "Get Your Order",
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry."));

  return featured;
}

List<WalkModel> getChristmasWalkData() {
  List<WalkModel> featured = [];
  featured.add(WalkModel.info(ic_christmas_walk1, "Welcome to Ainaqah",
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry."));
  featured.add(WalkModel.info(ic_christmas_walk2, "Checkout",
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry."));
  featured.add(WalkModel.info(ic_christmas_walk3, "Get Your Order",
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry."));

  return featured;
}
