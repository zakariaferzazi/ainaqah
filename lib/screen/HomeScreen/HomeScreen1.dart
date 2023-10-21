import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '/../component/HomeScreenComponent/Dashboard1ProductComponent.dart';
import '/../component/HomeDataComponent.dart';
import '/../component/HomeScreenComponent/VendorWidget.dart';
import '/../component/HomeScreenComponent/DashboardComponent.dart';
import '/../main.dart';
import '/../models/ProductResponse.dart';
import '/../screen/SaleScreen.dart';
import '/../screen/SearchScreen.dart';
import '/../screen/ViewAllScreen.dart';
import '/../screen/WebViewExternalProductScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../AppLocalizations.dart';
import '../../utils/AppBarWidget.dart';

class HomeScreen1 extends StatefulWidget {
  static String tag = '/HomeScreen1';

  @override
  HomeScreen1State createState() => HomeScreen1State();
}

class HomeScreen1State extends State<HomeScreen1> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  PageController salePageController = PageController();
  PageController bannerPageController = PageController();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  init() {
    afterBuildCreated(() async {
      appStore.setLoading(true);
      await setValue(CARTCOUNT, appStore.count);
      await fetchDashboardData();
      await fetchCategoryData();
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void dispose() {
    salePageController.dispose();
    bannerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    Widget availableOfferAndDeal(String title, List<ProductResponse> product, String subTitle) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 4, thickness: 4, color: Theme.of(context).textTheme.headlineMedium!.color),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: boldTextStyle()).paddingOnly(left: 8),
              Text(subTitle, style: boldTextStyle(color: primaryColor)).paddingAll(8).onTap(
                () {
                  if (title == builderResponse.dashboard!.dealOfTheDay!.title) {
                    ViewAllScreen(title, isSpecialProduct: true, specialProduct: "deal_of_the_day").launch(context);
                  } else if (title == builderResponse.dashboard!.offerProduct!.title) {
                    ViewAllScreen(title, isSpecialProduct: true, specialProduct: "offer").launch(context);
                  } else {
                    ViewAllScreen(title);
                  }
                },
              ).visible(product.length >= TOTAL_DASHBOARD_ITEM),
            ],
          ).paddingOnly(left: 4, top: 8, bottom: 8),
          HorizontalList(
            padding: EdgeInsets.only(left: 12, right: 12),
            itemCount: product.length > 6 ? 6 : product.length,
            itemBuilder: (context, i) {
              return Container(height: 280, child: Dashboard1ProductComponent(mProductModel: product[i], width: context.width() * 0.42).paddingRight(6));
            },
          ),
          Divider(height: 4, thickness: 4, color: Theme.of(context).textTheme.headlineMedium!.color),
          4.height,
        ],
      );
    }

    Widget _category() {
      return mCategoryModel.isNotEmpty
          ? HorizontalList(
              padding: EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 8),
              itemCount: mCategoryModel.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 95,
                  child: GestureDetector(
                    onTap: () {
                      ViewAllScreen(mCategoryModel[index].name, isCategory: true, categoryId: mCategoryModel[index].id).launch(context);
                    },
                    child: Column(
                      children: [
                        mCategoryModel[index].image != null
                            ? CircleAvatar(backgroundColor: context.cardColor, backgroundImage: NetworkImage(mCategoryModel[index].image!.src.validate()), radius: 30)
                            : CircleAvatar(backgroundColor: context.cardColor, backgroundImage: AssetImage(ic_placeholder_logo), radius: 30),
                        4.height,
                        Text(parseHtmlString(mCategoryModel[index].name), maxLines: 2, textAlign: TextAlign.center, style: primaryTextStyle(size: 14)).center()
                      ],
                    ).paddingRight(8),
                  ),
                );
              },
            )
          : SizedBox();
    }

    Widget carousel() {
      return mSliderModel.isNotEmpty
          ? Container(
              height: 200,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView(
                    controller: bannerPageController,
                    onPageChanged: (i) {
                      setState(() {});
                    },
                    children: mSliderModel.map((i) {
                      return Container(
                        decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), border: Border.all(color: textSecondaryColorGlobal.withOpacity(0.4))),
                        margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                        child: commonCacheImageWidget(i.image.validate(), height: 180, width: double.infinity, fit: BoxFit.fill).cornerRadiusWithClipRRect(10),
                      ).onTap(() {
                        if (i.url!.isNotEmpty) {
                          WebViewExternalProductScreen(mExternal_URL: i.url, title: i.title).launch(context);
                        } else {
                          toast('Sorry');
                        }
                      });
                    }).toList(),
                  ),
                  DotIndicator(pageController: bannerPageController, pages: mSliderModel, indicatorColor: primaryColor).paddingBottom(8)
                ],
              ),
            )
          : SizedBox();
    }

    Widget mSaleBannerWidget() {
      return mSaleBanner.isNotEmpty
          ? AnimatedListView(
              itemCount: mSaleBanner.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, i) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 210,
                      padding: EdgeInsets.only(bottom: 20),
                      child: commonCacheImageWidget(mSaleBanner[i].image.validate(), width: double.infinity, fit: BoxFit.cover),
                    ).onTap(() {
                      SaleScreen(startDate: mSaleBanner[i].startDate, endDate: mSaleBanner[i].endDate, title: mSaleBanner[i].title).launch(context);
                    }),
                    Container(
                      margin: EdgeInsets.only(left: 30, right: 30),
                      width: context.width(),
                      padding: EdgeInsets.all(8),
                      decoration: boxDecorationRoundedWithShadow(8, backgroundColor: Theme.of(context).cardTheme.color!),
                      child: Column(
                        children: [
                          Text(mSaleBanner[i].title!, style: boldTextStyle(color: primaryColor)),
                          2.height,
                          Text(appLocalization.translate('lbl_sale_start_from')! + " " + mSaleBanner[i].startDate.validate() + " to " + mSaleBanner[i].endDate.validate(),
                              style: secondaryTextStyle(size: 12)),
                        ],
                      ),
                    )
                  ],
                ).paddingOnly(bottom: 16).visible(mSaleBanner[i].title!.isNotEmpty && mSaleBanner[i].image!.isNotEmpty);
              },
            )
          : SizedBox();
    }

    Widget _newProduct() {
      return DashboardComponent(
        title: builderResponse.dashboard!.newProduct!.title!,
        subTitle: builderResponse.dashboard!.newProduct!.viewAll!,
        product: mNewestProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.newProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget _featureProduct() {
      return DashboardComponent(
        title: builderResponse.dashboard!.featureProduct!.title!,
        subTitle: builderResponse.dashboard!.featureProduct!.viewAll!,
        product: mFeaturedProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.featureProduct!.title, isFeatured: true).launch(context);
        },
      );
    }

    Widget _dealOfTheDay() {
      return availableOfferAndDeal(builderResponse.dashboard!.dealOfTheDay!.title!, mDealProductModel, builderResponse.dashboard!.dealOfTheDay!.viewAll!).visible(mDealProductModel.isNotEmpty);
    }

    Widget _bestSelling() {
      return DashboardComponent(
        title: builderResponse.dashboard!.bestSaleProduct!.title!,
        subTitle: builderResponse.dashboard!.bestSaleProduct!.viewAll!,
        product: mSellingProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.bestSaleProduct!.title, isBestSelling: true).launch(context);
        },
      );
    }

    Widget _saleProduct() {
      return DashboardComponent(
        title: builderResponse.dashboard!.saleProduct!.title!,
        subTitle: builderResponse.dashboard!.saleProduct!.viewAll!,
        product: mSaleProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.saleProduct!.title, isSale: true).launch(context);
        },
      );
    }

    Widget _offer() {
      return availableOfferAndDeal(builderResponse.dashboard!.offerProduct!.title!, mOfferProductModel, builderResponse.dashboard!.dealOfTheDay!.viewAll!).visible(mOfferProductModel.isNotEmpty);
    }

    Widget _suggested() {
      return DashboardComponent(
        title: builderResponse.dashboard!.suggestionProduct!.title!,
        subTitle: builderResponse.dashboard!.suggestionProduct!.viewAll!,
        product: mSuggestedProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.suggestionProduct!.title, isSpecialProduct: true, specialProduct: "suggested_for_you").launch(context);
        },
      );
    }

    Widget _youMayLike() {
      return DashboardComponent(
        title: builderResponse.dashboard!.youMayLikeProduct!.title!,
        subTitle: builderResponse.dashboard!.youMayLikeProduct!.viewAll!,
        product: mYouMayLikeProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.youMayLikeProduct!.title, isSpecialProduct: true, specialProduct: "you_may_like").launch(context);
        },
      );
    }

    Widget body = ListView(
      shrinkWrap: true,
      children: [
        AnimatedListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: builderResponse.dashboard == null ? 0 : builderResponse.dashboard!.sorting!.length,
          itemBuilder: (_, index) {
            if (builderResponse.dashboard!.sorting![index] == 'slider') {
              return carousel().paddingTop(8).visible(builderResponse.dashboard!.sliderView!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'categories') {
              return _category().paddingTop(8).visible(builderResponse.dashboard!.category!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'Sale_Banner') {
              return mSaleBannerWidget().paddingTop(8).visible(builderResponse.dashboard!.saleBanner!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'newest_product') {
              return _newProduct().paddingTop(8).visible(builderResponse.dashboard!.newProduct!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'vendor') {
              return mVendorWidget(context, mVendorModel, builderResponse.dashboard!.vendor!.title, builderResponse.dashboard!.vendor!.viewAll)
                  .paddingOnly(top: 8, bottom: 8)
                  .visible(builderResponse.dashboard!.vendor!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'feature_products') {
              return _featureProduct().paddingTop(8).visible(builderResponse.dashboard!.featureProduct!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'deal_of_the_day') {
              return _dealOfTheDay().paddingTop(8).visible(builderResponse.dashboard!.dealOfTheDay!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'best_selling_product') {
              return _bestSelling().paddingTop(8).visible(builderResponse.dashboard!.bestSaleProduct!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'sale_product') {
              return _saleProduct().paddingTop(8).visible(builderResponse.dashboard!.saleProduct!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'offer') {
              return _offer().paddingTop(8).visible(builderResponse.dashboard!.offerProduct!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'suggested_for_you') {
              return _suggested().paddingTop(8).visible(builderResponse.dashboard!.suggestionProduct!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'you_may_like') {
              return _youMayLike().paddingTop(8).visible(builderResponse.dashboard!.youMayLikeProduct!.enable!);
            } else {
              return 0.height;
            }
          },
        ),
        mBottom(context).visible(!appStore.isLoading && isDone == true)
      ],
    );

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: mTop(
        context,
        AppName,
        actions: [
          IconButton(
            icon: Icon(Icons.search_sharp, color: white),
            onPressed: () {
              SearchScreen().launch(context);
            },
          )
        ],
      ) as PreferredSizeWidget?,
      key: scaffoldKey,
      body: RefreshIndicator(
        color: primaryColor,
        backgroundColor: context.cardColor,
        onRefresh: () {
          return fetchDashboardData();
        },
        child: Observer(builder: (context) {
          return BodyCornerWidget(
            child: Stack(
              alignment: Alignment.center,
              children: [
                body.visible(!appStore.isLoading),
                mProgress().center().visible(appStore.isLoading),
              ],
            ),
          );
        }),
      ),
    );
  }
}
