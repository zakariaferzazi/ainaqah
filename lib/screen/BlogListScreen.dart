import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '/../AppLocalizations.dart';
import '/../component/BlogListComponent.dart';
import '/../models/BlogListResponse.dart';
import '/../network/rest_apis.dart';
import '/../screen/EmptyScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/AppBarWidget.dart';

class BlogListScreen extends StatefulWidget {
  static String tag = '/BlogListScreen';

  @override
  BlogListScreenState createState() => BlogListScreenState();
}

class BlogListScreenState extends State<BlogListScreen> {
  List<Blog> mBlogList = [];

  ScrollController scrollController = new ScrollController();

  int? page = 1, noPages;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    fetchBlogListData(1);
    scrollController.addListener(() {
      scrollHandler();
    });
  }

  scrollHandler() {
    setState(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading && noPages! > page!) {
        page = page! + 1;
        fetchBlogListData(page);
      }
    });
  }

  Future fetchBlogListData(int? page) async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getBlogList(page, TOTAL_BLOG_ITEM).then((res) {
      if (!mounted) return;
      setState(() {
        appStore.setLoading(false);
        noPages = res['num_of_pages'];
        if (page == 1) mBlogList.clear();
        Iterable list = res['data'];
        mBlogList.addAll(list.map((model) => Blog.fromJson(model)).toList());
      });
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
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: mTop(context, appLocalization.translate('lbl_blog'), showBack: true) as PreferredSizeWidget?,
        body: Observer(
          builder: (context) => BodyCornerWidget(
            child: Stack(
              children: [
                if (mBlogList.isNotEmpty)
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        16.height,
                        BlogListComponent(mBlogList),
                        mProgress().center().visible(appStore.isLoading && page! > 1),
                        50.height,
                      ],
                    ),
                  ),
                EmptyScreen().visible(!appStore.isLoading&&mBlogList.isEmpty),
                mProgress().center().visible(appStore.isLoading && page == 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
