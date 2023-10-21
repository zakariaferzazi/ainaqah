import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import '/../AppLocalizations.dart';
import '/../component/HomeScreenComponent/Dashboard1ProductComponent.dart';
import '/../main.dart';
import '/../models/ProductResponse.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppBarWidget.dart';
import '/../screen/EmptyScreen.dart';
import '/../utils/Countdown.dart';
import '/../utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class SaleScreen extends StatefulWidget {
  static String tag = '/SaleScreen';

  String? startDate = "";
  String? endDate = "";
  String? title = "";

  SaleScreen({this.startDate, this.endDate, this.title});

  @override
  SaleScreenState createState() => SaleScreenState();
}

class SaleScreenState extends State<SaleScreen> {
  List<ProductResponse> mProductModel = [];
  bool isLoading = false;
  var errorMsg = '';
  int? noPages;
  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    log(widget.startDate.toString());
    log(widget.endDate.toString());
    log(widget.title.toString());
    getAllProducts();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  getAllProducts() async {
    setState(() {
      isLoading = true;
    });
    await getSaleInfo(widget.startDate, widget.endDate).then((res) {
      if (!mounted) return;
      log(res);
      log(res);
      ProductListResponse listResponse = ProductListResponse.fromJson(res);
      setState(() {
        if (page == 1) {
          mProductModel.clear();
        }
        noPages = listResponse.numOfPages;
        mProductModel.addAll(listResponse.data!);
        isLoading = false;
        errorMsg = mProductModel.isEmpty ? 'No Data Found' : "";
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
        errorMsg = "No Data Found";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    Widget mDate() {
      var endTime = widget.endDate!;
      var endDate = DateFormat('yyyy-MM-dd').parse(endTime);
      var currentDate = DateFormat('yyyy-MM-dd').parse(widget.startDate!);
      var format = endDate.subtract(Duration(days: currentDate.day, hours: currentDate.hour, minutes: currentDate.minute, seconds: currentDate.second));
      return Countdown(
        duration: Duration(days: format.day, hours: format.hour, minutes: format.minute, seconds: format.second),
        onFinish: () {
          log('finished!');
        },
        builder: (BuildContext ctx, Duration? remaining) {
          var seconds = ((remaining!.inMilliseconds / 1000) % 60).toInt();
          var minutes = (((remaining.inMilliseconds / (1000 * 60)) % 60)).toInt();
          var hours = (((remaining.inMilliseconds / (1000 * 60 * 60)) % 24)).toInt();
          return Container(
            decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: primaryColor!.withOpacity(0.2)),
            width: context.width(),
            child: Text(appLocalization!.translate('lbl_sale_end_in')! + " " + '${remaining.inDays}d ${hours}h ${minutes}m ${seconds}s', style: primaryTextStyle()).paddingAll(8).center(),
          ).paddingOnly(left: 16, right: 16).visible(mProductModel.isNotEmpty);
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: mTop(context, widget.title, showBack: true) as PreferredSizeWidget?,
        body: BodyCornerWidget(
          child: Stack(
            children: [
              Column(
                children: [
                  mDate(),
                  8.height,
                  AlignedGridView.count(
                    scrollDirection: Axis.vertical,
                    itemCount: mProductModel.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 4, right: 4),
                    itemBuilder: (context, index) {
                      return Dashboard1ProductComponent(mProductModel: mProductModel[index], width: context.width());
                    },
                    crossAxisCount: 2,

                  ),
                ],
              ),
              Center(child: mProgress().paddingAll(24).visible(isLoading)),
              Center(child: EmptyScreen()).visible(errorMsg.isNotEmpty && !isLoading && mProductModel.isEmpty),
            ],
          ),
        ),
      ),
    );
  }
}
