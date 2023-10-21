import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import '/../component/HomeDataComponent.dart';
import '/../component/HomeScreenComponent3/DashBoard3Product.dart';
import '/../component/HomeScreenComponent3/DashBoard3AppWidget.dart';
import '/../component/HomeScreenComponent3/DashboardComponent3.dart';
import '/../component/HomeScreenComponent3/VendorWidget3.dart';
import '/../main.dart';
import '/../models/ProductResponse.dart';
import '/../utils/AppBarWidget.dart';
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

class HomeScreen3 extends StatefulWidget {
  static String tag = '/HomeScreen1';

  @override
  HomeScreen3State createState() => HomeScreen3State();
}

class HomeScreen3State extends State<HomeScreen3> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  PageController salePageController = PageController();
  PageController bannerPageController = PageController(initialPage: 0);
  int _currentPage = 0;

  Random rnd = new Random();

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
      setTimer();
      setState(() {});
      appStore.setLoading(false);
    });
  }

  setTimer() {
    Timer.periodic(
      Duration(seconds: 10),
      (Timer timer) {
        if (_currentPage < 2) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (bannerPageController.hasClients) {
          bannerPageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      },
    );
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

    Widget availableOfferAndDeal(String title, List<ProductResponse> product, String subtitle) {
      return Stack(
        children: [
          commonCacheImageWidget(ic_horizontal_bg, height: 285, width: context.width(), fit: BoxFit.cover),
          Container(height: 285, color: black.withOpacity(0.2)),
          Container(
            padding: EdgeInsets.only(left: 8),
            width: context.width() * 0.3,
            margin: EdgeInsets.only(top: context.height() * 0.17),
            child: Text(title, maxLines: 3, overflow: TextOverflow.ellipsis, style: GoogleFonts.alata(fontSize: 23, color: appStore.isDarkMode! ? context.iconColor : white)),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  HorizontalList(
                    padding: EdgeInsets.only(left: context.width() * 0.3, right: 8),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: product.length > 6 ? 6 : product.length,
                    itemBuilder: (context, i) {
                      return DashBoard3Product(mProductModel: product[i], width: context.width() * 0.42);
                    },
                  ),
                  viewAllDashBoard3(context, viewAll: builderResponse.dashboard!.youMayLikeProduct!.viewAll!).paddingOnly(right: 16).onTap(
                    () {
                      if (title == builderResponse.dashboard!.dealOfTheDay!.title) {
                        ViewAllScreen(title, isSpecialProduct: true, specialProduct: "deal_of_the_day").launch(context);
                      } else if (title == builderResponse.dashboard!.offerProduct!.title) {
                        ViewAllScreen(appLocalization.translate('lbl_offer'), isSpecialProduct: true, specialProduct: "offer").launch(context);
                      } else {
                        ViewAllScreen(title);
                      }
                    },
                  ).visible(product.length >= TOTAL_DASHBOARD_ITEM),
                ],
              ),
            ),
          )
        ],
      );
    }

    Widget _category() {
      return mCategoryModel.isNotEmpty
          ? Container(
              height: 260,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mCategoryModel.length,
                padding: EdgeInsets.only(left: 8, right: 4, bottom: 2),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 250, childAspectRatio: 1.02),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(left: 4, right: 8),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        mCategoryModel[index].image != null
                            ? commonCacheImageWidget(mCategoryModel[index].image!.src.validate(), height: 120, fit: BoxFit.cover).cornerRadiusWithClipRRect(8)
                            : Image.asset(ic_placeholder_logo, height: 120, fit: BoxFit.cover).cornerRadiusWithClipRRect(8),
                        Container(decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.all(Radius.circular(8)), backgroundColor: black.withOpacity(0.3)), height: 120),
                        Text(parseHtmlString(mCategoryModel[index].name), maxLines: 2, textAlign: TextAlign.center, style: boldTextStyle(size: 14, color: white)).paddingOnly(bottom: 4)
                      ],
                    ),
                  ).onTap(() {
                    ViewAllScreen(mCategoryModel[index].name, isCategory: true, categoryId: mCategoryModel[index].id).launch(context);
                  });
                },
              ),
            )
          : SizedBox();
    }

    Widget carousel() {
      return mSliderModel.isNotEmpty
          ? Container(
              height: 200,
              margin: EdgeInsets.only(top: 8),
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
                        margin: EdgeInsets.only(left: 12, right: 12),
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
                  8.height,
                  DotIndicator(
                    pageController: bannerPageController,
                    pages: mSliderModel,
                    indicatorColor: primaryColor,
                    unselectedIndicatorColor: grey.withOpacity(0.2),
                    currentBoxShape: BoxShape.rectangle,
                    boxShape: BoxShape.rectangle,
                    borderRadius: radius(2),
                    currentBorderRadius: radius(3),
                    currentDotSize: 18,
                    currentDotWidth: 6,
                    dotSize: 6,
                  ),
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
      return DashboardComponent3(
        title: builderResponse.dashboard!.newProduct!.title!,
        subTitle: builderResponse.dashboard!.newProduct!.viewAll!,
        product: mNewestProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.newProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget _featureProduct() {
      return DashboardComponent3(
        title: builderResponse.dashboard!.featureProduct!.title!,
        subTitle: builderResponse.dashboard!.featureProduct!.viewAll!,
        product: mFeaturedProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.featureProduct!.title, isFeatured: true).launch(context);
        },
      );
    }

    Widget _dealOfTheDay() {
      return availableOfferAndDeal(
        builderResponse.dashboard!.dealOfTheDay!.title!,
        mDealProductModel,
        builderResponse.dashboard!.dealOfTheDay!.viewAll!,
      ).visible(mDealProductModel.isNotEmpty);
    }

    Widget _bestSelling() {
      return DashboardComponent3(
        title: builderResponse.dashboard!.bestSaleProduct!.title!,
        subTitle: builderResponse.dashboard!.bestSaleProduct!.viewAll!,
        product: mSellingProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.bestSaleProduct!.title, isBestSelling: true).launch(context);
        },
      );
    }

    Widget _saleProduct() {
      return DashboardComponent3(
        title: builderResponse.dashboard!.saleProduct!.title!,
        subTitle: builderResponse.dashboard!.saleProduct!.viewAll!,
        product: mSaleProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.saleProduct!.title, isSale: true).launch(context);
        },
      );
    }

    Widget _offer() {
      return availableOfferAndDeal(
        builderResponse.dashboard!.offerProduct!.title!,
        mOfferProductModel,
        builderResponse.dashboard!.dealOfTheDay!.viewAll!,
      ).visible(mOfferProductModel.isNotEmpty);
    }

    Widget _suggested() {
      return DashboardComponent3(
        title: builderResponse.dashboard!.suggestionProduct!.title!,
        subTitle: builderResponse.dashboard!.suggestionProduct!.viewAll!,
        product: mSuggestedProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.suggestionProduct!.title, isSpecialProduct: true, specialProduct: "suggested_for_you").launch(context);
        },
      );
    }

    Widget _youMayLike() {
      return DashboardComponent3(
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
              return _newProduct().visible(builderResponse.dashboard!.newProduct!.enable!).paddingTop(16);
            } else if (builderResponse.dashboard!.sorting![index] == 'vendor') {
              return mVendorDashBoard3Widget(context, mVendorModel, builderResponse.dashboard!.vendor!.title, builderResponse.dashboard!.vendor!.viewAll)
                  .paddingTop(8)
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
      body: Observer(builder: (context) {
        return RefreshIndicator(
          backgroundColor: context.cardColor,
          onRefresh: () {
            return fetchDashboardData();
          },
          child: BodyCornerWidget(
            child: Stack(
              alignment: Alignment.center,
              children: [
                body.visible(!appStore.isLoading),
                mProgress().center().visible(appStore.isLoading),
              ],
            ),
          ),
        );
      }),
    );
  }
}
