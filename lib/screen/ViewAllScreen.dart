import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '/../component/HomeScreenComponent/Dashboard1ProductComponent.dart';
import '/../component/LayoutSelection.dart';
import '/../main.dart';
import '/../models/CategoryData.dart';
import '/../models/ProductResponse.dart';
import '/../models/SearchRequest.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppBarWidget.dart';
import '/../screen/ProductDetail/ProductDetailScreen2.dart';
import '/../screen/SubCategoryScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';

import 'ProductDetail/ProductDetailScreen1.dart';
import 'ProductDetail/ProductDetailScreen3.dart';

// ignore: must_be_immutable
class ViewAllScreen extends StatefulWidget {
  static String tag = '/ViewAllScreen';
  bool? isFeatured = false;
  bool? isNewest = false;
  bool? isSpecialProduct = false;
  bool? isBestSelling = false;
  bool? isSale = false;
  bool? isCategory = false;
  int? categoryId = 0;
  String? specialProduct = "";
  String? startDate = "";
  String? endDate = "";
  String? headerName = "";

  ViewAllScreen(this.headerName,
      {this.isFeatured, this.isSale, this.isCategory, this.categoryId, this.isNewest, this.isSpecialProduct, this.isBestSelling, this.specialProduct, this.startDate, this.endDate});

  @override
  ViewAllScreenState createState() => ViewAllScreenState();
}

class ViewAllScreenState extends State<ViewAllScreen> {
  List<ProductResponse> mProductModel = [];
  List<Category> mCategoryModel = [];

  var searchRequest = SearchRequest();
  var scrollController = ScrollController();

  int page = 1;
  int? noPages;
  int crossAxisCount = 2;

  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  init() async {
    var crossAxisCount1 = getIntAsync(CROSS_AXIS_COUNT, defaultValue: 2);
    setState(() {
      crossAxisCount = crossAxisCount1;
    });

    if (widget.isCategory == true) {
      fetchCategoryData();
      fetchSubCategoryData();
    } else {
      searchRequest.onSale = widget.isSale != null
          ? widget.isSale!
              ? "_sale_price"
              : ""
          : "";
      searchRequest.featured = widget.isFeatured != null
          ? widget.isFeatured!
              ? "product_visibility"
              : ""
          : "";
      searchRequest.bestSelling = widget.isBestSelling != null
          ? widget.isBestSelling!
              ? "total_sales"
              : ""
          : "";
      searchRequest.newest = widget.isNewest != null
          ? widget.isNewest!
              ? "newest"
              : ""
          : "";
      searchRequest.specialProduct = widget.isSpecialProduct != null
          ? widget.isSpecialProduct!
              ? widget.specialProduct
              : ""
          : "";
      page = 1;
      getAllProducts();
    }
    scrollController.addListener(() {
      scrollHandler();
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Widget _productListWidget(ProductResponse product, BuildContext context) {
    String img = product.images!.isNotEmpty ? product.images!.first.src.validate() : '';

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 90,
              width: 90,
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: Theme.of(context).colorScheme.background),
              child: Stack(children: [commonCacheImageWidget(img, height: 120, width: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(8), mSale(product)])),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: primaryTextStyle(), maxLines: 2),
              8.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      PriceWidget(price: product.salePrice.validate().isNotEmpty ? product.salePrice.toString() : product.price.validate(), size: 14),
                      4.width,
                      PriceWidget(price: product.regularPrice.validate().toString(), size: 12, isLineThroughEnabled: true, color: Theme.of(context).textTheme.titleMedium!.color)
                          .visible(product.salePrice.validate().isNotEmpty)
                    ],
                  )
                ],
              ).paddingOnly(bottom: 8),
            ],
          ).expand(),
        ],
      ).paddingAll(8),
    );
  }

  scrollHandler() {
    if (widget.isCategory == true) {
      setState(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent && noPages! > page && !appStore.isLoading) {
          page++;
          loadMoreCategoryProduct(page);
        }
      });
    } else {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && noPages! > page && !appStore.isLoading) {
        page++;
        getAllProducts();
      }
    }
  }

  Future loadMoreCategoryProduct(page) async {
    appStore.setLoading(true);
    var data = {"category": widget.categoryId, "page": page, "perPage": TOTAL_ITEM_PER_PAGE};
    await searchProduct(data).then((res) {
      if (!mounted) return;
      appStore.setLoading(false);
      setState(() {
        ProductListResponse listResponse = ProductListResponse.fromJson(res);
        setState(() {
          if (page == 1) {
            mProductModel.clear();
          }
          noPages = listResponse.numOfPages;
          mProductModel.addAll(listResponse.data!);
        });
      });
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
    });
  }

  Future fetchCategoryData() async {
    appStore.setLoading(true);

    var data = {"category": widget.categoryId, "page": 1, "perPage": TOTAL_ITEM_PER_PAGE};
    print("Request $data");
    await searchProduct(data).then((res) {
      if (!mounted) return;
      setState(() {
        appStore.setLoading(false);
        ProductListResponse listResponse = ProductListResponse.fromJson(res);
        setState(() {
          if (page == 1) {
            mProductModel.clear();
          }
          noPages = listResponse.numOfPages;
          mProductModel.addAll(listResponse.data!);
          appStore.setLoading(false);
        });
        print("Model" + mProductModel.toString());
      });
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
      print("Error:" + error.toString());
    });
  }

  Future fetchSubCategoryData() async {
    appStore.setLoading(true);
    await getSubCategories(widget.categoryId, page).then((res) {
      if (!mounted) return;
      appStore.setLoading(false);
      setState(() {
        Iterable mCategory = res;
        mCategoryModel = mCategory.map((model) => Category.fromJson(model)).toList();
      });
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
    });
  }

  Widget mSubCategory(List<Category> category) {
    return Container(
      height: 110,
      child: AnimatedListView(
        itemCount: category.length,
        padding: EdgeInsets.only(right: 12, left: 12),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              SubCategoryScreen(mCategoryModel[i].name, categoryId: mCategoryModel[i].id).launch(context);
            },
            child: Container(
              margin: EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  mCategoryModel[i].image != null
                      ? CircleAvatar(backgroundColor: context.cardColor, backgroundImage: NetworkImage(mCategoryModel[i].image!.src.validate()), radius: 35)
                      : CircleAvatar(backgroundColor: context.cardColor, backgroundImage: AssetImage(ic_placeholder_logo), radius: 35),
                  2.height,
                  Text(parseHtmlString(category[i].name), style: primaryTextStyle(size: 12))
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

    Widget _gridProducts = AlignedGridView.count(
        scrollDirection: Axis.vertical,
        itemCount: mProductModel.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 12, right: 12),
        itemBuilder: (context, index) {
          return Dashboard1ProductComponent(mProductModel: mProductModel[index], width: context.width());
        },
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        );

    Widget _listProduct = AnimatedListView(
      scrollDirection: Axis.vertical,
      itemCount: mProductModel.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(right: 8, left: 8, bottom: 8),
      itemBuilder: (context, index) {
        return _productListWidget(mProductModel[index], context).onTap(() {
          if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 1) {
            ProductDetailScreen1(mProId: mProductModel[index].id).launch(context);
          } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 2) {
            ProductDetailScreen2(mProId: mProductModel[index].id).launch(context);
          } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 3) {
            ProductDetailScreen3(mProId: mProductModel[index].id).launch(context);
          } else {
            ProductDetailScreen1(mProId: mProductModel[index].id).launch(context);
          }
        });
      },
    );

    return Scaffold(
      appBar: mTop(
        context,
        parseHtmlString(widget.headerName),
        showBack: true,
        actions: [
          IconButton(
              onPressed: () {
                layoutSelectionBottomSheet(context);
              },
              icon: Icon(MaterialCommunityIcons.view_dashboard_outline, color: Colors.white, size: 30)),
          mCart(context, getBoolAsync(IS_LOGGED_IN))
        ],
      ) as PreferredSizeWidget?,
      body: Observer(builder: (context) {
        return BodyCornerWidget(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    mSubCategory(mCategoryModel).visible(widget.isCategory != null && widget.isCategory! && mCategoryModel.isNotEmpty),
                    crossAxisCount == 1 ? _listProduct.visible(mProductModel.isNotEmpty) : _gridProducts.visible(mProductModel.isNotEmpty),
                    mProgress().visible(appStore.isLoading && page > 1).center()
                  ],
                ),
              ),
              mProgress().paddingAll(24).center().visible(appStore.isLoading && page == 1)
            ],
          ),
        );
      }),
    );
  }

  getAllProducts() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    setState(() {
      searchRequest.page = page;
    });
    await searchProduct(searchRequest.toJson()).then((res) {
      if (!mounted) return;
      log(res);
      ProductListResponse listResponse = ProductListResponse.fromJson(res);
      setState(() {
        if (page == 1) {
          mProductModel.clear();
        }
        noPages = listResponse.numOfPages;
        mProductModel.addAll(listResponse.data!);
        appStore.setLoading(false);
      });
    }).catchError((error) {
      setState(() {
        appStore.setLoading(false);
        errorMsg = "No Data Found";
        if (page == 1) {
          mProductModel.clear();
        }
      });
    });
  }

  void layoutSelectionBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return LayoutSelection(
          crossAxisCount: crossAxisCount,
          callBack: (crossvalue) {
            crossAxisCount = crossvalue;
            setState(() {});
          },
        );
      },
    );
  }
}
