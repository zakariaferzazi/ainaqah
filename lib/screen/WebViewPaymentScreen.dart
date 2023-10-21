import 'package:flutter/material.dart';
import '/../AppLocalizations.dart';
import '/../main.dart';
import '/../utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/AppBarWidget.dart';

class WebViewPaymentScreen extends StatefulWidget {
  static String tag = '/WebViewPaymentScreen';
  final String? checkoutUrl;

  WebViewPaymentScreen({this.checkoutUrl});

  @override
  WebViewPaymentScreenState createState() => WebViewPaymentScreenState();
}

class WebViewPaymentScreenState extends State<WebViewPaymentScreen> {
  bool mIsError = false;

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: mTop(context, appLocalization.translate('title_payment'), showBack: true) as PreferredSizeWidget?,
      body: BodyCornerWidget(
        child: Stack(
          children: [
            WebView(
              initialUrl: widget.checkoutUrl,
              javascriptMode: JavascriptMode.unrestricted,
              gestureNavigationEnabled: true,
              onPageFinished: (String url) {
                if (mIsError) return;
                if (url.contains('checkout/order-received')) {
                  appStore.setLoading(true);
                  //toast('Order placed successfully');
                  appStore.setCount(0);
                  finish(context, true);
                } else {
                  appStore.setLoading(false);
                }
              },
              onWebResourceError: (s) {
                mIsError = true;
              },
            ),
            mProgress().visible(appStore.isLoading).center()
          ],
        ),
      ),
    );
  }
}
