import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '/../component/HomeDataComponent.dart';
import '/../component/HomeScreenComponent2/DashBoard2Product.dart';
import '/../component/HomeScreenComponent2/DashboardComponent2.dart';
import '/../component/HomeScreenComponent2/VendorWidget2.dart';
import '/../main.dart';
import '/../models/ProductResponse.dart';
import '/../screen/SaleScreen.dart';
import '/../screen/SearchScreen.dart';
import '/../screen/ViewAllScreen.dart';
import '/../screen/WebViewExternalProductScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../AppLocalizations.dart';
import '../../utils/AppBarWidget.dart';

class HomeScreen2 extends StatefulWidget {
  static String tag = '/HomeScreen1';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen2> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  PageController salePageController = PageController();
  PageController bannerPageController = PageController(initialPage: 0);
  int _currentPage = 0;
  int selectIndex = 0;

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
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
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

    Widget availableOfferAndDeal(String title, String subtitle, List<ProductResponse> product) {
      return Stack(
        children: [
          Container(color: bgCardColor.withOpacity(0.6), height: 340),
          Column(
            children: [
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height: 1.5, width: 24, color: context.iconColor),
                  8.width,
                  Text(title, style: GoogleFonts.alata(fontSize: 24, color: context.iconColor)).paddingOnly(left: 8),
                  8.width,
                  Container(height: 1.5, width: 24, color: context.iconColor),
                ],
              ).paddingSymmetric(vertical: 8),
              viewAll(() {
                if (title == builderResponse.dashboard!.dealOfTheDay!.title) {
                  ViewAllScreen(title, isSpecialProduct: true, specialProduct: "deal_of_the_day").launch(context);
                } else if (title == builderResponse.dashboard!.offerProduct!.title) {
                  ViewAllScreen(MaxAdContentRating.t, isSpecialProduct: true, specialProduct: "offer").launch(context);
                } else {
                  ViewAllScreen(title);
                }
              }, subtitle),
              HorizontalList(
                padding: EdgeInsets.only(left: 12, right: 8),
                itemCount: product.length > 6 ? 6 : product.length,
                itemBuilder: (context, i) {
                  return DashBoard2Product(mProductModel: product[i], width: context.width() * 0.45, isHorizontal: true);
                },
              ),
            ],
          )
        ],
      ).paddingOnly(top: 8, bottom: 8);
    }

    Widget _category() {
      return mCategoryModel.isNotEmpty
          ? HorizontalList(
              padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
              itemCount: mCategoryModel.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    ViewAllScreen(mCategoryModel[index].name, isCategory: true, categoryId: mCategoryModel[index].id).launch(context);
                  },
                  child: Container(
                    decoration: boxDecorationWithShadow(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(blurRadius: 0.3, spreadRadius: 0.2, color: gray.withOpacity(0.3))],
                      backgroundColor: context.cardColor,
                    ),
                    height: 130,
                    width: context.width() * 0.25,
                    margin: EdgeInsets.only(right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        mCategoryModel[index].image != null
                            ? CircleAvatar(backgroundColor: context.cardColor, backgroundImage: NetworkImage(mCategoryModel[index].image!.src.validate()), radius: 40)
                            : CircleAvatar(backgroundColor: context.cardColor, backgroundImage: AssetImage(ic_placeholder_logo), radius: 40),
                        8.height,
                        Text(parseHtmlString(mCategoryModel[index].name), maxLines: 2, textAlign: TextAlign.center, style: primaryTextStyle(size: 14)).center()
                      ],
                    ),
                  ),
                );
              },
            )
          : SizedBox();
    }

    Widget carousel() {
      return mSliderModel.isNotEmpty
          ? Column(
              children: [
                Container(
                  height: 200,
                  child: PageView(
                    controller: bannerPageController,
                    onPageChanged: (i) {
                      selectIndex = i;
                      setState(() {});
                    },
                    children: mSliderModel.map((i) {
                      return Container(
                        decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), border: Border.all(color: textSecondaryColorGlobal.withOpacity(0.4))),
                        margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                        child: commonCacheImageWidget(i.image.validate(), height: 180, width: double.infinity, fit: BoxFit.cover).cornerRadiusWithClipRRect(10),
                      ).onTap(() {
                        if (i.url!.isNotEmpty) {
                          WebViewExternalProductScreen(mExternal_URL: i.url, title: i.title).launch(context);
                        } else {
                          toast('Sorry');
                        }
                      });
                    }).toList(),
                  ),
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
      return DashboardComponent2(
        title: builderResponse.dashboard!.newProduct!.title!,
        subTitle: builderResponse.dashboard!.newProduct!.viewAll!,
        product: mNewestProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.newProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget _featureProduct() {
      return DashboardComponent2(
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
        builderResponse.dashboard!.dealOfTheDay!.viewAll!,
        mDealProductModel,
      ).visible(mDealProductModel.isNotEmpty);
    }

    Widget _bestSelling() {
      return DashboardComponent2(
        title: builderResponse.dashboard!.bestSaleProduct!.title!,
        subTitle: builderResponse.dashboard!.bestSaleProduct!.viewAll!,
        product: mSellingProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.bestSaleProduct!.title, isBestSelling: true).launch(context);
        },
      );
    }

    Widget _saleProduct() {
      return DashboardComponent2(
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
        builderResponse.dashboard!.dealOfTheDay!.viewAll!,
        mOfferProductModel,
      ).visible(mOfferProductModel.isNotEmpty);
    }

    Widget _suggested() {
      return DashboardComponent2(
        title: builderResponse.dashboard!.suggestionProduct!.title!,
        subTitle: builderResponse.dashboard!.suggestionProduct!.viewAll!,
        product: mSuggestedProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.suggestionProduct!.title, isSpecialProduct: true, specialProduct: "suggested_for_you").launch(context);
        },
      );
    }

    Widget _youMayLike() {
      return DashboardComponent2(
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
              return carousel().visible(builderResponse.dashboard!.sliderView!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'categories') {
              return _category().paddingTop(8).visible(builderResponse.dashboard!.category!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'Sale_Banner') {
              return mSaleBannerWidget().paddingTop(8).visible(builderResponse.dashboard!.saleBanner!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'newest_product') {
              return _newProduct().paddingTop(16).visible(builderResponse.dashboard!.newProduct!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'vendor') {
              return mVendorDashBoard2Widget(context, mVendorModel, builderResponse.dashboard!.vendor!.title, builderResponse.dashboard!.vendor!.viewAll)
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
