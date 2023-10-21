import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '/../component/HomeScreenComponent/Dashboard1ProductComponent.dart';
import '/../component/LayoutSelection.dart';
import '/../main.dart';
import '/../models/CategoryData.dart';
import '/../models/ProductResponse.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppBarWidget.dart';
import '/../screen/EmptyScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class SubCategoryScreen extends StatefulWidget {
  static String tag = '/SubCategory';
  int? categoryId = 0;
  String? headerName = "";

  SubCategoryScreen(this.headerName, {this.categoryId});

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  var scrollController = new ScrollController();

  List<ProductResponse> mProductModel = [];
  List<Category> mCategoryModel = [];

  bool isLoadingMoreData = false;
  bool isLastPage = false;
  bool mIsLoggedIn = false;

  int page = 1;
  int crossAxisCount = 2;

  var sortType = -1;

  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    init();
    fetchCategoryData();
    fetchSubCategoryData();
  }

  init() async {
    crossAxisCount = getIntAsync(CROSS_AXIS_COUNT, defaultValue: 2);
    mIsLoggedIn = getBoolAsync(IS_LOGGED_IN);
    scrollController.addListener(() {
      scrollHandler();
    });
    setState(() {});
  }

  scrollHandler() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLastPage) {
      page++;
      loadMoreCategoryData(page);
    }
  }

  Future loadMoreCategoryData(page) async {
    setState(() {
      isLoadingMoreData = true;
    });
    var data = {"category": widget.categoryId, "page": page, "perPage": TOTAL_ITEM_PER_PAGE};
    await searchProduct(data).then((res) {
      if (!mounted) return;
      ProductListResponse listResponse = ProductListResponse.fromJson(res);
      setState(() {
        if (page == 1) {
          mProductModel.clear();
        }
        mProductModel.addAll(listResponse.data!);
        isLoadingMoreData = false;
        isLastPage = false;
      });
    }).catchError((error) {
      if (!mounted) return;
      setState(() {
        isLastPage = true;
        isLoadingMoreData = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future fetchCategoryData() async {
    appStore.setLoading(true);
    var data = {"category": widget.categoryId, "page": 1, "perPage": TOTAL_ITEM_PER_PAGE};
    await searchProduct(data).then((res) {
      if (!mounted) return;
      ProductListResponse listResponse = ProductListResponse.fromJson(res);
      if (page == 1) {
        mProductModel.clear();
      }
      mProductModel.addAll(listResponse.data!);
      appStore.setLoading(false);
    }).catchError((error) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future fetchSubCategoryData() async {
    appStore.setLoading(true);
    await getSubCategories(widget.categoryId, page).then((res) {
      if (!mounted) return;
      setState(() {
        Iterable mCategory = res;
        mCategoryModel = mCategory.map((model) => Category.fromJson(model)).toList();
      });
    }).catchError((error) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Widget mSubCategory(List<Category> category) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      height: MediaQuery.of(context).size.width * 0.15,
      child: AnimatedListView(
        itemCount: category.length,
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 16),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              SubCategoryScreen(mCategoryModel[i].name, categoryId: mCategoryModel[i].id).launch(context);
            },
            child: Container(
              margin: EdgeInsets.only(right: 8),
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), backgroundColor: context.cardColor, border: Border.all()),
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  if (category[i].image != null) commonCacheImageWidget(category[i].image!.src, width: MediaQuery.of(context).size.width * 0.1, fit: BoxFit.contain),
                  4.width,
                  Text(parseHtmlString(category[i].name.validate()), style: primaryTextStyle(size: 14)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setValue(CARTCOUNT, appStore.count);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: mTop(
        context,
        widget.headerName,
        showBack: true,
        actions: [
          IconButton(
              onPressed: () {
                layoutSelectionBottomSheet(context);
              },
              icon: Icon(MaterialCommunityIcons.view_dashboard_outline, color: Colors.white, size: 20)),
          mCart(context, mIsLoggedIn)
        ],
      ) as PreferredSizeWidget?,
      body: Observer(builder: (context) {
        return BodyCornerWidget(
          child: Stack(
            children: [
              errorMsg.isEmpty && mProductModel.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          16.height,
                          mSubCategory(mCategoryModel).visible(mCategoryModel.isNotEmpty),
                          AlignedGridView.count(
                              scrollDirection: Axis.vertical,
                              itemCount: mProductModel.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.only(left: 12, right: 12, bottom: 8),
                              itemBuilder: (context, index) {
                                return Dashboard1ProductComponent(mProductModel: mProductModel[index], width: context.width());
                              },
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: 6,
                              crossAxisSpacing: 6),
                          mProgress().visible(isLoadingMoreData).center()
                        ],
                      ),
                    )
                  : EmptyScreen().center().visible(errorMsg.isEmpty && mProductModel.isEmpty && !appStore.isLoading),
              mProgress().paddingAll(8).center().visible(appStore.isLoading)
            ],
          ),
        );
      }),
    );
  }

  void layoutSelectionBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return LayoutSelection(
          crossAxisCount: crossAxisCount,
          callBack: (crossValue) {
            crossAxisCount = crossValue;
            setState(() {});
          },
        );
      },
    );
  }
}
