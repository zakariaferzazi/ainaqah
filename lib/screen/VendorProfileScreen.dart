import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '/../component/HomeScreenComponent/Dashboard1ProductComponent.dart';
import '/../models/ProductResponse.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';
import '../utils/AppBarWidget.dart';

class VendorProfileScreen extends StatefulWidget {
  static String tag = '/VendorProfileScreen';
  final int? mVendorId;

  VendorProfileScreen({Key? key, this.mVendorId}) : super(key: key);

  @override
  _VendorProfileScreenState createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  VendorResponse? mVendorModel;
  List<ProductResponse> mVendorProductList = [];

  @override
  void initState() {
    super.initState();
    log(widget.mVendorId.toString());
    fetchVendorProfile();
    fetchVendorProduct();
  }

  Future fetchVendorProfile() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getVendorProfile(widget.mVendorId).then((res) {
      if (!mounted) return;
      VendorResponse methodResponse = VendorResponse.fromJson(res);
      appStore.setLoading(false);
      mVendorModel = methodResponse;
      setState(() {});
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
    });
  }

  Future fetchVendorProduct() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getVendorProduct(widget.mVendorId).then((res) {
      appStore.setLoading(false);
      Iterable list = res;
      mVendorProductList = list.map((model) => ProductResponse.fromJson(model)).toList();
      setState(() {});
    }).catchError(
      (error) {
        appStore.setLoading(false);
      },
    );
  }

  Widget mOption(var value, var color, {maxLine = 1}) {
    return Text(value, style: primaryTextStyle(color: color), maxLines: maxLine).paddingOnly(left: 16, right: 16);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);
    String? addressText = "";

    if (mVendorModel != null) {
      if (mVendorModel!.address != null) {
        if (mVendorModel!.address!.street_1!.isNotEmpty && addressText.isEmpty) {
          addressText = mVendorModel!.address!.street_1;
        }
        if (mVendorModel!.address!.street_2!.isNotEmpty) {
          if (addressText!.isEmpty) {
            addressText = mVendorModel!.address!.street_2;
          } else {
            addressText += ", " + mVendorModel!.address!.street_2!;
          }
        }

        if (mVendorModel!.address!.city!.isNotEmpty) {
          if (addressText!.isEmpty) {
            addressText = mVendorModel!.address!.city;
          } else {
            addressText += ", " + mVendorModel!.address!.city!;
          }
        }
        if (mVendorModel!.address!.zip!.isNotEmpty) {
          if (addressText!.isEmpty) {
            addressText = mVendorModel!.address!.zip;
          } else {
            addressText += " - " + mVendorModel!.address!.zip!;
          }
        }
        if (mVendorModel!.address!.state!.isNotEmpty) {
          if (addressText!.isEmpty) {
            addressText = mVendorModel!.address!.state;
          } else {
            addressText += ", " + mVendorModel!.address!.state!;
          }
        }
        if (mVendorModel!.address!.country!.isNotEmpty) {
          if (addressText!.isEmpty) {
            addressText = mVendorModel!.address!.country;
          } else {
            addressText += ", " + mVendorModel!.address!.country!;
          }
        }
      }
    }

    final body = mVendorModel != null
        ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                mVendorModel!.banner!.isNotEmpty
                    ? Container(
                        height: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(mVendorModel!.banner.validate())),
                        ),
                      ).cornerRadiusWithClipRRect(10).paddingOnly(bottom: 16, left: 12, right: 12)
                    : SizedBox(),
                Text(mVendorModel!.storeName != null ? mVendorModel!.storeName! : '', style: boldTextStyle(size: 18)).paddingOnly(left: 16, right: 16).visible(mVendorModel!.storeName!.isNotEmpty),
                10.height.visible(!mVendorModel!.phone.isEmptyOrNull),
                !mVendorModel!.phone.isEmptyOrNull ? mOption(mVendorModel!.phone != null ? mVendorModel!.phone : '', Theme.of(context).textTheme.titleMedium!.color) : SizedBox(),
                10.height.visible(mVendorModel!.phone == null && mVendorModel!.phone.isEmptyOrNull),
                mOption(addressText.validate(), Theme.of(context).textTheme.titleMedium!.color, maxLine: 3).visible(addressText!.isNotEmpty),
                10.height.visible(addressText.isEmptyOrNull),
                Divider(color: view_color, thickness: 6),
                10.height,
                Text(appLocalization!.translate('lbl_product_list')!, style: boldTextStyle(size: 18)).paddingLeft(12).visible(mVendorProductList.isNotEmpty),
                mVendorProductList.isNotEmpty
                    ? AlignedGridView.count(
                        scrollDirection: Axis.vertical,
                        itemCount: mVendorProductList.length,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(12),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        itemBuilder: (context, index) {
                          return Dashboard1ProductComponent(mProductModel: mVendorProductList[index]);
                        },
                      )
                    : Text(appLocalization.translate('lbl_data_not_found')!, style: boldTextStyle()).paddingOnly(left: 8, right: 8)
              ],
            ),
          )
        : SizedBox();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: mTop(context, mVendorModel != null ? mVendorModel!.storeName : ' ', showBack: true) as PreferredSizeWidget?,
        body: BodyCornerWidget(
          child: Observer(builder: (context) {
            return Stack(
              children: <Widget>[
                body.visible(mVendorModel != null),
                mProgress().visible(appStore.isLoading).center(),
              ],
            );
          }),
        ),
      ),
    );
  }
}
