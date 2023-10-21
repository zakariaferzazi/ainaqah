import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '/../models/BlogResponse.dart';
import '/../network/rest_apis.dart';
import '/../screen/WebViewExternalProductScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Common.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/AppBarWidget.dart';

class BlogDescriptionScreen extends StatefulWidget {
  static String tag = '/BlogDescriptionScreen';
  final int? mId;

  BlogDescriptionScreen({Key? key, this.mId}) : super(key: key);

  @override
  BlogDescriptionScreenState createState() => BlogDescriptionScreenState();
}

class BlogDescriptionScreenState extends State<BlogDescriptionScreen> {
  BlogResponse? post;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    afterBuildCreated(() {
      fetchBlogDetail();
    });
  }

  Future fetchBlogDetail() async {
    appStore.setLoading(true);
    await getBlogDetail(widget.mId).then((res) {
      if (!mounted) return;
      appStore.setLoading(false);
      post = BlogResponse.fromJson(res);
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mTop(
        context,
        post != null ? post!.postTitle.validate() : "",
        showBack: true,
        actions: [
          post != null
              ? IconButton(
                  icon: Icon(Icons.share_rounded, color: white),
                  onPressed: () {
                    WebViewExternalProductScreen(mExternal_URL: post!.shareUrl, title: post != null ? post!.postTitle.validate() : "").launch(context);
                  })
              : SizedBox()
        ],
      ) as PreferredSizeWidget?,
      body: Observer(
        builder: (context) => BodyCornerWidget(
          child: Stack(
            children: [
              post != null
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          16.height,
                          Text(post!.postTitle.validate(), style: boldTextStyle(size: 18)),
                          16.height,
                          post!.image.isEmptyOrNull
                              ? Image.asset(ic_placeholder_logo, width: context.width(), fit: BoxFit.cover)
                              : commonCacheImageWidget(post!.image.validate(), width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(16),
                          22.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(post!.postAuthorName.validate(), style: boldTextStyle()),
                              Text(post!.postDate.validate(), style: secondaryTextStyle()),
                            ],
                          ),
                          16.height,
                          Text(parseHtmlString(post!.postContent.validate()), style: secondaryTextStyle(), textAlign: TextAlign.justify)
                        ],
                      ).paddingOnly(left: 16, right: 16, bottom: 16),
                    ).visible(!appStore.isLoading)
                  : SizedBox(),
              mProgress().center().visible(appStore.isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
