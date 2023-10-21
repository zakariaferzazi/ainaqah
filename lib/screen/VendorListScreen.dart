import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '/../component/VendorListComponent.dart';
import '/../models/ProductResponse.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import '../AppLocalizations.dart';
import '../main.dart';
import '../utils/AppBarWidget.dart';

class VendorListScreen extends StatefulWidget {
  static String tag = '/VendorListScreen';

  @override
  _VendorListScreenState createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  List<VendorResponse> mVendorList = [];

  // bool appStore.setLoading(false);
  String mErrorMsg = '';

  @override
  void initState() {
    super.initState();
    fetchVendorData();
  }

  Future fetchVendorData() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getVendor().then((res) {
      appStore.setLoading(false);
      Iterable list = res;
      mVendorList = list.map((model) => VendorResponse.fromJson(model)).toList();
      mErrorMsg = '';
    }).catchError((error) {
      appStore.setLoading(false);
      mErrorMsg = error.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: mTop(context, appLocalization.translate('lbl_vendors'), showBack: true) as PreferredSizeWidget?,
      body: Observer(
        builder: (context) {
          return BodyCornerWidget(
            child: mVendorList.isNotEmpty
                ? Stack(
                    children: <Widget>[
                      VendorListComponent(mVendorList: mVendorList),
                      mProgress().center().visible(appStore.isLoading),
                    ],
                  )
                : mProgress().center().visible(appStore.isLoading),
          );
        },
      ),
    );
  }
}
