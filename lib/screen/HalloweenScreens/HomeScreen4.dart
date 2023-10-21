import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '/../component/HomeDataComponent.dart';
import '/../component/HomeScreenComponent4/DashBoard4Product.dart';
import '/../component/HomeScreenComponent4/DashBoard4VendorComponent.dart';
import '/../component/HomeScreenComponent4/DashboardComponent4.dart';
import '/../main.dart';
import '/../models/ProductResponse.dart';
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
import '../VendorListScreen.dart';

class HomeScreen4 extends StatefulWidget {
  static String tag = '/HomeScreen4';

  @override
  HomeScreen4State createState() => HomeScreen4State();
}

class HomeScreen4State extends State<HomeScreen4> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  PageController bannerPageController = PageController();
  PageController saleBannerPageController = PageController();

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
      setState(() {});
      appStore.setLoading(false);
    });
  }

  @override
  void dispose() {
    bannerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    Widget availableOfferAndDeal(String title, List<ProductResponse> product) {
      return Stack(
        children: [
          Image.asset(ic_halloween_background, height: 400, width: context.width(), fit: BoxFit.cover),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              Text(title, style: boldTextStyle(color: white, size: 20)).center(),
              8.height,
              Text(builderResponse.dashboard!.youMayLikeProduct!.viewAll!, style: boldTextStyle(color: white)).center().onTap(
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
              16.height,
              HorizontalList(
                padding: EdgeInsets.only(left: 12, right: 12),
                itemCount: product.length > 6 ? 6 : product.length,
                itemBuilder: (context, i) {
                  return Container(child: DashBoard4Product(mProductModel: product[i], width: context.width() * 0.42).paddingRight(6));
                },
              ),
              4.height,
            ],
          ),
        ],
      );
    }

    Widget _category() {
      return mCategoryModel.isNotEmpty
          ? Container(
              margin: EdgeInsets.only(top: 16),
              child: HorizontalList(
                itemCount: mCategoryModel.length,
                padding: EdgeInsets.only(left: 8),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      ViewAllScreen(mCategoryModel[index].name, isCategory: true, categoryId: mCategoryModel[index].id).launch(context);
                    },
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(backgroundColor: Colors.transparent, backgroundImage: AssetImage(ic_halloween_category), radius: 36),
                            mCategoryModel[index].image != null
                                ? CircleAvatar(backgroundColor: Colors.transparent, backgroundImage: NetworkImage(mCategoryModel[index].image!.src.validate()), radius: 36)
                                : CircleAvatar(backgroundColor: Colors.transparent, backgroundImage: AssetImage(ic_placeholder_logo), radius: 36),
                          ],
                        ),
                        4.height,
                        Text(parseHtmlString(mCategoryModel[index].name), maxLines: 2, textAlign: TextAlign.center, style: primaryTextStyle(size: 14, color: white)).center()
                      ],
                    ).paddingOnly(left: 8, right: 8),
                  );
                },
              ),
            )
          : SizedBox();
    }

    Widget carousel() {
      return mSliderModel.isNotEmpty
          ? Column(
              children: [
                Container(
                  height: 220,
                  child: PageView(
                    controller: bannerPageController,
                    onPageChanged: (i) {
                      setState(() {});
                    },
                    children: mSliderModel.map((i) {
                      return Stack(
                        children: [
                          Container(
                            decoration: boxDecorationWithRoundedCorners(border: Border.all(color: mHalloweenYellow, width: 16), borderRadius: radius(0)),
                          ),
                          commonCacheImageWidget(i.image.validate(), height: 220, width: context.width(), fit: BoxFit.cover).onTap(() {
                            if (i.url!.isNotEmpty) {
                              WebViewExternalProductScreen(mExternal_URL: i.url, title: i.title).launch(context);
                            } else {
                              toast('Sorry');
                            }
                          }).paddingAll(2),
                        ],
                      ).paddingOnly(bottom: 4, left: 16, top: 16, right: 16);
                    }).toList(),
                  ),
                ),
                DotIndicator(pageController: bannerPageController, currentDotSize: 8, dotSize: 6, pages: mSliderModel, unselectedIndicatorColor: white.withOpacity(0.4), indicatorColor: white)
                    .paddingBottom(8)
              ],
            )
          : SizedBox();
    }

    Widget mSaleBannerWidget() {
      return mSaleBanner.isNotEmpty
          ? Column(
              children: [
                Container(
                  height: 350,
                  child: PageView(
                    controller: saleBannerPageController,
                    onPageChanged: (i) {
                      setState(() {});
                    },
                    children: mSaleBanner.map((i) {
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          commonCacheImageWidget(i.image.validate(), height: 350, width: context.width(), fit: BoxFit.fitHeight).paddingAll(2),
                          Container(
                            height: 100,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 8,
                                blurRadius: 2,
                                offset: Offset(4, 2), // changes position of shadow
                              ),
                            ]),
                            child: Column(
                              children: [
                                Text(i.title!, style: boldTextStyle(color: white, size: 24)),
                                2.height,
                                Text(appLocalization.translate('lbl_sale_start_from')! + " " + i.startDate.validate() + " to " + i.endDate.validate(),
                                    style: secondaryTextStyle(size: 18, color: white.withOpacity(0.4))),
                              ],
                            ).paddingAll(16),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                DotIndicator(pageController: saleBannerPageController, currentDotSize: 6, dotSize: 6, pages: mSaleBanner, unselectedIndicatorColor: white.withOpacity(0.4), indicatorColor: white)
                    .paddingBottom(8)
              ],
            )
          : SizedBox();
    }

    Widget _newProduct() {
      return DashboardComponent4(
        title: builderResponse.dashboard!.newProduct!.title!,
        subTitle: builderResponse.dashboard!.newProduct!.viewAll!,
        product: mNewestProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.newProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget mVendor4Widget(BuildContext context, List<VendorResponse> mVendorModel, var title, var all, {size= 16}) {
      return mVendorModel.isNotEmpty
          ? Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Divider(color: Colors.white24).expand(),
                        Image.asset(ic_halloween_pumpkin_gif, height: 80, fit: BoxFit.cover).paddingOnly(left: 16, right: 16),
                        Divider(color: Colors.white24).expand()
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: boldTextStyle(size: 22, color: white)),
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.add, size: 14, color: white.withOpacity(0.4))),
                              TextSpan(text: all, style: secondaryTextStyle(size: 14, color: white.withOpacity(0.4))),
                            ],
                          ),
                        ),
                      ],
                    ).paddingOnly(left: 16, right: 16),
                  ],
                ).onTap(() {
                  VendorListScreen().launch(context);
                }),
                8.height,
                DashBoard4VendorComponent(mVendorModel)
              ],
            )
          : SizedBox();
    }

    Widget _featureProduct() {
      return DashboardComponent4(
        title: builderResponse.dashboard!.bestSaleProduct!.title!,
        subTitle: builderResponse.dashboard!.featureProduct!.viewAll!,
        product: mNewestProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.featureProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget _dealOfTheDay() {
      return availableOfferAndDeal(builderResponse.dashboard!.dealOfTheDay!.title!, mDealProductModel).visible(mDealProductModel.isNotEmpty);
    }

    Widget _bestSelling() {
      return DashboardComponent4(
        title: builderResponse.dashboard!.bestSaleProduct!.title!,
        subTitle: builderResponse.dashboard!.bestSaleProduct!.viewAll!,
        product: mNewestProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.bestSaleProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget _saleProduct() {
      return DashboardComponent4(
        title: builderResponse.dashboard!.saleProduct!.title!,
        subTitle: builderResponse.dashboard!.saleProduct!.viewAll!,
        product: mNewestProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.saleProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget _offer() {
      return Column(
        children: [
          availableOfferAndDeal(builderResponse.dashboard!.offerProduct!.title!, mOfferProductModel).visible(mOfferProductModel.isNotEmpty),
        ],
      );
    }

    Widget _suggested() {
      return DashboardComponent4(
        title: builderResponse.dashboard!.suggestionProduct!.title!,
        subTitle: builderResponse.dashboard!.suggestionProduct!.viewAll!,
        product: mNewestProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.suggestionProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget _youMayLike() {
      return DashboardComponent4(
        title: builderResponse.dashboard!.youMayLikeProduct!.title!,
        subTitle: builderResponse.dashboard!.youMayLikeProduct!.viewAll!,
        product: mNewestProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.youMayLikeProduct!.title, isNewest: true).launch(context);
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
              return _category().visible(builderResponse.dashboard!.category!.enable!).paddingTop(8);
            } else if (builderResponse.dashboard!.sorting![index] == 'Sale_Banner') {
              return mSaleBannerWidget().visible(builderResponse.dashboard!.saleBanner!.enable!).paddingTop(16);
            } else if (builderResponse.dashboard!.sorting![index] == 'newest_product') {
              return _newProduct().visible(builderResponse.dashboard!.newProduct!.enable!).paddingTop(8);
            } else if (builderResponse.dashboard!.sorting![index] == 'vendor') {
              return mVendor4Widget(context, mVendorModel, builderResponse.dashboard!.vendor!.title, builderResponse.dashboard!.vendor!.viewAll).visible(builderResponse.dashboard!.vendor!.enable!);
            } else if (builderResponse.dashboard!.sorting![index] == 'feature_products') {
              return _featureProduct().visible(builderResponse.dashboard!.featureProduct!.enable!).paddingTop(30);
            } else if (builderResponse.dashboard!.sorting![index] == 'deal_of_the_day') {
              return _dealOfTheDay().visible(builderResponse.dashboard!.dealOfTheDay!.enable!).paddingTop(16);
            } else if (builderResponse.dashboard!.sorting![index] == 'best_selling_product') {
              return _bestSelling().visible(builderResponse.dashboard!.bestSaleProduct!.enable!).paddingTop(30);
            } else if (builderResponse.dashboard!.sorting![index] == 'sale_product') {
              return _saleProduct().visible(builderResponse.dashboard!.saleProduct!.enable!).paddingTop(8);
            } else if (builderResponse.dashboard!.sorting![index] == 'offer') {
              return _offer().visible(builderResponse.dashboard!.offerProduct!.enable!).paddingTop(8);
            } else if (builderResponse.dashboard!.sorting![index] == 'suggested_for_you') {
              return _suggested().visible(builderResponse.dashboard!.suggestionProduct!.enable!).paddingTop(8);
            } else if (builderResponse.dashboard!.sorting![index] == 'you_may_like') {
              return _youMayLike().visible(builderResponse.dashboard!.youMayLikeProduct!.enable!).paddingTop(8);
            } else {
              return 0.height;
            }
          },
        ),
        Image.asset(
          ic_halloween_bg,
          fit: BoxFit.fitWidth,
          width: context.width(),
          height: 100,
        )
      ],
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: mHalloweenBackgroundColor,
        appBar: AppBar(
            elevation: 1,
            backgroundColor: mHalloweenBackgroundColor,
            actions: [
              IconButton(
                icon: Icon(Icons.search_sharp, color: white),
                onPressed: () {
                  SearchScreen().launch(context);
                },
              )
            ],
            title: Text(
              AppName,
              style: boldTextStyle(size: 18, color: white),
            ),
            automaticallyImplyLeading: false),
        key: scaffoldKey,
        body: RefreshIndicator(
          color: primaryColor,
          backgroundColor: Theme.of(context).cardTheme.color,
          onRefresh: () {
            return fetchDashboardData();
          },
          child: Observer(builder: (context) {
            return Stack(
              alignment: Alignment.center,
              children: [
                body.visible(!appStore.isLoading),
                mProgress().center().visible(appStore.isLoading),
              ],
            );
          }),
        ),
      ),
    );
  }
}
