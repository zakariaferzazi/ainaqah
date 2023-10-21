import 'package:flutter/material.dart';
import '/../models/BlogListResponse.dart';
import '/../screen/BlogDescriptionScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Common.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class BlogListComponent extends StatefulWidget {
  static String tag = '/BlogListComponent';
  List<Blog> mBlogList;

  BlogListComponent(this.mBlogList);

  @override
  BlogListComponentState createState() => BlogListComponentState();
}

class BlogListComponentState extends State<BlogListComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    List<Blog> mBlogList = widget.mBlogList;
    return AnimatedListView(
      scrollDirection: Axis.vertical,
      itemCount: mBlogList.length,
      padding: EdgeInsets.symmetric(horizontal: 16),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            log(mBlogList[index].iD);
            BlogDescriptionScreen(mId: mBlogList[index].iD).launch(context);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(8), backgroundColor: Theme.of(context).colorScheme.background, border: Border.all(color: Theme.of(context).colorScheme.background)),
                  child: mBlogList[index].image != null
                      ? commonCacheImageWidget(mBlogList[index].image, width: 100, height: 100, fit: BoxFit.fill).cornerRadiusWithClipRRect(8)
                      : Image.asset(ic_placeholder_logo, height: 100, width: 100, fit: BoxFit.fill).cornerRadiusWithClipRRect(8)),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(parseHtmlString(mBlogList[index].postTitle..validate().trim()), style: boldTextStyle()),
                  4.height,
                  Text(parseHtmlString(mBlogList[index].postContent.validate()), maxLines: 2, style: secondaryTextStyle()),
                  4.height,
                  Align(alignment: Alignment.bottomRight, child: Text(mBlogList[index].readableDate.validate(), style: secondaryTextStyle(), textAlign: TextAlign.justify))
                ],
              ).expand(),
            ],
          ).paddingOnly(bottom: 16),
        );
      },
    );
  }
}
