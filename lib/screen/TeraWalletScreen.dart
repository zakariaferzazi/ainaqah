import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '/../component/AddMoneyComponent.dart';
import '/../component/TeraWalletHistoryComponent.dart';
import '/../main.dart';
import '/../models/WalletConfigurationResponse.dart';
import '/../models/WalletResponse.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import '../AppLocalizations.dart';
import 'WebViewPaymentScreen.dart';

class TeraWalletScreen extends StatefulWidget {
  static String tag = '/TeraWalletScreen';

  get mCartProduct => null;

  @override
  TeraWalletScreenState createState() => TeraWalletScreenState();
}

class TeraWalletScreenState extends State<TeraWalletScreen> {
  Future<List<WalletResponse>>? getBalanceHistory;
  WalletConfigurationResponse mWalletConfigurationResponse = WalletConfigurationResponse();
  String? mTotalBalance = "";
  String error = "";

  @override
  void initState() {
    super.initState();
    // afterBuildCreated(() {
      init();
    // });
  }

  init() async {
    fetchTotalBalance();
    fetchWalletConfiguration();
    getBalanceHistory = getWalletBalance(getIntAsync(USER_ID));
  }

  Future fetchTotalBalance() async {
    setState(() {
      appStore.setLoading(true);
    });
    await getBalance().then((res) {
      mTotalBalance = res;
      appStore.setLoading(false);
    }).catchError((error) {
      appStore.setLoading(false);
    });
  }

  Future fetchWalletConfiguration() async {
    await getWalletConfiguration().then((value) {
      mWalletConfigurationResponse.productTitle = value['product_title'];
      mWalletConfigurationResponse.minTopupAmount = value['min_topup_amount'];
      mWalletConfigurationResponse.maxTopupAmount = value['max_topup_amount'];
      error="";
    }).catchError((error) {
      log("Error${error.toString()}");
      if (error.toString().contains('First configure your wallet')) {
        error = "First configure your wallet";
        toast("You have to set up Tera Wallet configurations first ");
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void mAddTransactionAPI(double amount) async {
    hideKeyboard(context);
    var request = {"amount": amount.toString()};
    appStore.setLoading(true);
    addWallet(request).then((response) async {
      appStore.setLoading(false);
      bool isPaymentDone = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebViewPaymentScreen(checkoutUrl: response['woocommerce_redirect'])),
          ) ??
          false;
      if (isPaymentDone) {
        setState(() {
          fetchTotalBalance();
          getBalanceHistory = getWalletBalance(getIntAsync(USER_ID));
        });
      } else {
        log("Sorry try again");
      }
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: mTop(context, appLocalization.translate('lbl_wallet')!, showBack: true) as PreferredSizeWidget?,
      body: Observer(
        builder: (context) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Arc(
                      arcType: ArcType.CONVEX,
                      edge: Edge.BOTTOM,
                      height: 30,
                      clipShadows: [],
                      child: Container(
                        height: context.height() * 0.15,
                        width: context.width(),
                        color: primaryColor,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(appLocalization.translate('total_amount')!, style: boldTextStyle(color: Colors.white)),
                                    Text(mTotalBalance!, style: boldTextStyle(size: 35, color: Colors.white)),
                                  ],
                                ),
                                AppButton(
                                  text: appLocalization.translate('lbl_add_money')!,
                                  textStyle: primaryTextStyle(color: primaryColor),
                                  color: Colors.white,
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                        shape: RoundedRectangleBorder(borderRadius: radius(10)),
                                        elevation: 0.0,
                                        backgroundColor: Colors.transparent,
                                        child: AddMoneyComponent(
                                            mWalletConfigurationResponse: mWalletConfigurationResponse,
                                            onCall: (amount) {
                                              mAddTransactionAPI(amount);
                                            }),
                                      ),
                                    );
                                  },
                                ).center().visible(!appStore.isLoading),
                              ],
                            ),
                          ],
                        ).paddingOnly(top: 16, left: 12, right: 12),
                      ),
                    ),
                    16.height,
                    FutureBuilder<List<WalletResponse>>(
                      future: getBalanceHistory != null ? getBalanceHistory! : null,
                      builder: (_, snap) {
                        if (snap.data.validate().isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(appLocalization.translate("lbl_history")!, style: boldTextStyle()).paddingSymmetric(horizontal: 16),
                              Container(
                                decoration: boxDecorationRoundedWithShadow(12, backgroundColor: context.scaffoldBackgroundColor),
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.separated(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(8),
                                      itemCount: snap.data!.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, i) {
                                        return TeraWalletHistoryComponent(snap.data![i]);
                                      },
                                      separatorBuilder: (BuildContext context, int index) {
                                        return Divider();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ).visible(snap.data!.isNotEmpty);
                        } else if (snap.data.validate().isNotEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(MaterialCommunityIcons.emoticon_cry_outline, size: 120, color: context.iconColor),
                              8.height,
                              Text(appLocalization.translate("msg_no_money")!, style: primaryTextStyle(), textAlign: TextAlign.center).paddingOnly(left: 16, right: 16),
                            ],
                          ).center().visible(!appStore.isLoading);
                        }
                        return snapWidgetHelper(snap, loadingWidget: mProgress());
                      },
                    ),
                  ],
                ),
              ).visible(!appStore.isLoading),
              mProgress().center().visible(appStore.isLoading)
            ],
          );
        },
      ),
    );
  }
}
