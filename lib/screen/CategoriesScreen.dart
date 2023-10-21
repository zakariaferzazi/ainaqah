import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '/../component/HomeDataComponent.dart';
import '/../component/LayoutSelectionCategory.dart';
import '/../models/CategoryData.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppBarWidget.dart';
import '/../screen/EmptyScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';
import '../AppLocalizations.dart';
import '../main.dart';
import 'ViewAllScreen.dart';

class CategoriesScreen extends StatefulWidget {
  static String tag = '/CategoriesScreen';

  @override
  CategoriesScreenState createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {
  ScrollController scrollController = ScrollController();

  String errorMsg = '';

  bool isLastPage = false;

  int crossAxisCount = 2;
  int page = 1;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  init() async {
    await fetchCategoryData();
    crossAxisCount = getIntAsync(CATEGORY_CROSS_AXIS_COUNT, defaultValue: 2);
    scrollController.addListener(() async {
      await scrollHandler();
    });
    appStore.setLoading(false);
  }

  scrollHandler() {
    setState(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading && isLastPage == false) {
        page++;
        loadMoreData(page);
      }
    });
  }

  Future loadMoreData(page) async {
    appStore.setLoading(true);
    await getCategories(page, TOTAL_CATEGORY_PER_PAGE).then((res) {
      if (!mounted) return;
      appStore.setLoading(false);
      setState(() {
        Iterable list = res;
        mCategoryModel.addAll(list.map((model) => Category.fromJson(model)).toList());
        if (mCategoryModel.isEmpty) {
          isLastPage = true;
        }
      });
    }).catchError((error) {
      appStore.setLoading(false);
      log(error);
    });
  }

  void layoutSelectionBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return LayoutSelectionCategory(
          crossAxisCount: crossAxisCount,
          callBack: (crossValue) {
            crossAxisCount = crossValue;
            setState(() {});
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = context.width();
    var appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: mTop(
        context,
        appLocalization.translate('lbl_categories'),
        actions: [
          IconButton(
            onPressed: () {
              layoutSelectionBottomSheet(context);
            },
            icon: Icon(MaterialCommunityIcons.view_dashboard_outline, color: Colors.white, size: 30),
          )
        ],
      ) as PreferredSizeWidget?,
      body: BodyCornerWidget(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            if (mCategoryModel.isNotEmpty)
              Column(
                children: [
                  crossAxisCount != 1
                      ? AlignedGridView.count(
                          itemCount: mCategoryModel.length,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                ViewAllScreen(mCategoryModel[index].name, isCategory: true, categoryId: mCategoryModel[index].id).launch(context);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      decoration: boxDecorationWithRoundedCorners(
                                          borderRadius: radius(8), backgroundColor: Theme.of(context).colorScheme.background, border: Border.all(color: Theme.of(context).colorScheme.background)),
                                      child: mCategoryModel[index].image != null
                                          ? commonCacheImageWidget(mCategoryModel[index].image!.src.validate(), height: 160, width: w, fit: BoxFit.cover).cornerRadiusWithClipRRect(8)
                                          : Image.asset(ic_placeholder_logo, width: w, height: 160, fit: BoxFit.fill).cornerRadiusWithClipRRect(8)),
                                  Text(parseHtmlString(mCategoryModel[index].name.validate()), textAlign: TextAlign.center, style: primaryTextStyle(), maxLines: 1)
                                ],
                              ),
                            ).paddingAll(8);
                          },
                        ).expand()
                      : AnimatedListView(
                          itemCount: mCategoryModel.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                ViewAllScreen(mCategoryModel[index].name, isCategory: true, categoryId: mCategoryModel[index].id).launch(context);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    decoration: boxDecorationWithRoundedCorners(
                                        borderRadius: radius(8), backgroundColor: Theme.of(context).colorScheme.background, border: Border.all(color: Theme.of(context).colorScheme.background)),
                                    child: mCategoryModel[index].image != null
                                        ? commonCacheImageWidget(mCategoryModel[index].image!.src, height: 80, width: 80, fit: BoxFit.cover).cornerRadiusWithClipRRect(8)
                                        : Image.asset(ic_placeholder_logo, height: 80, width: 80, fit: BoxFit.cover).cornerRadiusWithClipRRect(8),
                                  ),
                                  8.width,
                                  Text(parseHtmlString(mCategoryModel[index].name), textAlign: TextAlign.start, style: boldTextStyle(size: 18), maxLines: 2).expand()
                                ],
                              ).paddingSymmetric(vertical: 8),
                            );
                          },
                        ).expand(),
                  mProgress().center().visible(appStore.isLoading && page > 1),
                  16.height,
                ],
              ),
            EmptyScreen().center().visible(!appStore.isLoading && mCategoryModel.validate().isEmpty),
            Center(child: mProgress().visible(appStore.isLoading && page == 1)),
          ],
        ),
      ),
    );
  }
}
