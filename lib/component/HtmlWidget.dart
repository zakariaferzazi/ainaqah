import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nb_utils/nb_utils.dart';
import '/../utils/AppWidget.dart';

class HtmlWidget extends StatelessWidget {
  final String? postContent;
  final Color? color;

  HtmlWidget({this.postContent, this.color});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: postContent,
      onLinkTap: (url, _, __, ___) {
        launchUrl(url!);
      },
      onImageTap: (s, _, __, ___) {
        openPhotoViewer(context, Image.network(s!).image);
      },
      style: {
        "strong,div,h1,h2,h3,h4,h5,h6,figure,ol,ul,strike,u,b,i,hr,header,code,data,body,big,blockquote": Style(color: Theme.of(context).textTheme.titleMedium!.color, fontSize: FontSize(14)),
        'embed': Style(color: color ?? transparentColor, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: FontSize(16)),
        'a': Style(color: color ?? Colors.blue, fontWeight: FontWeight.bold, fontSize: FontSize(16)),
        'img': Style(width: context.width(), padding: EdgeInsets.only(bottom: 8), fontSize: FontSize(16)),
      },
    );
  }
}

Future<void> launchUrl(String url, {bool forceWebView = false}) async {
  log(url);
  await launchUrl(url, forceWebView: forceWebView).catchError((e) {
    log(e);
    toast('Invalid URL: $url');
  });
}
