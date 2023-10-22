import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import '/../main.dart';
import '/../utils/AdmobUtils.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../AppLocalizations.dart';
import '../utils/AppBarWidget.dart';

class AboutUsScreen extends StatefulWidget {
  static String tag = '/AboutUsScreen';

  @override
  AboutUsScreenState createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  PackageInfo? package;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    package = await PackageInfo.fromPlatform();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: mTop(context, appLocalization.translate('lbl_about'), showBack: true) as PreferredSizeWidget?,
      body: BodyCornerWidget(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                16.height,
                Container(width: 120, height: 120, padding: EdgeInsets.all(8), decoration: boxDecorationRoundedWithShadow(10), child: Image.asset(app_logo)),
                16.height,
                FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (_, snap) {
                      if (snap.hasData) {
                        return Column(
                          children: [
                            Text('${snap.data!.appName.validate()}', style: boldTextStyle(color: primaryColor, size: 20)),
                            8.height,
                            Text('V ${snap.data!.version.validate()}', style: boldTextStyle(color: primaryColor, size: 20)),
                            10.height,
                            Text("""Help Center\n Disputes & Reports, Buyer Protection, Report IPR infringement, Regulated Information, Integrity Compliance, please contact us on one of the following accounts with reference of order.""",textAlign: TextAlign.center, style: boldTextStyle()).visible(getStringAsync(WHATSAPP).isNotEmpty)
                          ],
                        );
                      }
                      return SizedBox();
                    }),
                8.height
              ],
            ).center(),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: enableAds == true ? 220 : 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: context.width(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          redirectUrl('https://wa.me/${getStringAsync(WHATSAPP)}');
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 16),
                          padding: EdgeInsets.all(10),
                          child: Image.asset(ic_WhatsUp, height: 35, width: 35),
                        ),
                      ).visible(getStringAsync(WHATSAPP).isNotEmpty),
                      InkWell(
                        onTap: () => redirectUrl(getStringAsync(INSTAGRAM)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(ic_Inst, height: 35, width: 35),
                        ),
                      ).visible(getStringAsync(INSTAGRAM).isNotEmpty),
                      InkWell(
                        onTap: () => redirectUrl(getStringAsync(TWITTER)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(ic_Twitter, height: 35, width: 35),
                        ),
                      ).visible(getStringAsync(TWITTER).isNotEmpty),
                      InkWell(
                        onTap: () => redirectUrl(getStringAsync(FACEBOOK)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(ic_Fb, height: 35, width: 35),
                        ),
                      ).visible(getStringAsync(FACEBOOK).isNotEmpty),
                      InkWell(
                        onTap: () => redirectUrl('tel:${getStringAsync(CONTACT)}'),
                        child: Container(
                          margin: EdgeInsets.only(right: 16),
                          padding: EdgeInsets.all(10),
                          child: Image.asset(ic_CallRing, height: 35, width: 35, color: primaryColor),
                        ),
                      ).visible(getStringAsync(CONTACT).isNotEmpty)
                    ],
                  ),
                ],
              ),
            ),
            FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return Text('V ${snap.data!.version.validate()}', style: secondaryTextStyle());
                  }
                  return SizedBox();
                }),
            2.height,
            Text(getStringAsync(COPYRIGHT_TEXT), style: secondaryTextStyle()).visible(getStringAsync(COPYRIGHT_TEXT).isNotEmpty),
            16.height,
            // Container(
            //   height: 60,
            //   child: AdWidget(
            //     ad: BannerAd(
            //       adUnitId:  getBannerAdUnitId()! ,
            //       size: AdSize.banner,
            //       request: AdRequest(),
            //       listener: BannerAdListener(),
            //     )..load(),
            //   ),
            // ).visible(enableAds == true)
          ],
        ),
      ),
    );
  }
}
