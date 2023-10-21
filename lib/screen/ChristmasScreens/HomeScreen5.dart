import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '/../component/HomeDataComponent.dart';
import '/../component/HomeScreenComponent5/DashBoard5Product.dart';
import '/../component/HomeScreenComponent5/DashBoard5VendorComponent.dart';
import '/../component/HomeScreenComponent5/DashboardComponent5.dart';
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

class HomeScreen5 extends StatefulWidget {
  static String tag = '/HomeScreen5';

  @override
  HomeScreen5State createState() => HomeScreen5State();
}

class HomeScreen5State extends State<HomeScreen5> {
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

    Widget availableOfferAndDeal(String title, List<ProductResponse> product, String subtitle) {
      return Stack(
        children: [
          Image.asset(ic_christmas_horizontal, width: context.width(), height: 380, fit: BoxFit.cover),
          Column(
            children: [
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("#" + title, style: GoogleFonts.pacifico(color: white, fontSize: 28, fontWeight: FontWeight.bold)).paddingRight(4),
                  Image.asset(ic_christmas_gift, height: 60, width: 60, fit: BoxFit.fill),
                ],
              ),
              8.height,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HorizontalList(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      itemCount: product.length > 6 ? 6 : product.length,
                      itemBuilder: (context, i) {
                        return Container(child: DashBoard5Product(mProductModel: product[i], width: context.width() * 0.42, isHorizontal: true).paddingRight(6));
                      },
                    ),
                    Text(subtitle, style: boldTextStyle(color: white)).center().onTap(
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
                    Icon(Icons.arrow_right_alt_rounded, color: white),
                    16.width,
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget _category() {
      return mCategoryModel.isNotEmpty
          ? Column(
              children: [
                10.height,
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Text("#" + appLocalization.translate("lbl_categories")!, style: GoogleFonts.pacifico(color: mChristmasColor, fontSize: 28, fontWeight: FontWeight.bold))
                        .paddingOnly(bottom: 12, left: 12, right: 26),
                    Image.asset(ic_christmas_hat, height: 40, width: 40, fit: BoxFit.cover),
                  ],
                ),
                8.height,
                Container(
                  height: 250,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mCategoryModel.length,
                    padding: EdgeInsets.only(left: 8, right: 4, bottom: 2),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 240, childAspectRatio: 1.1),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          ViewAllScreen(mCategoryModel[index].name, isCategory: true, categoryId: mCategoryModel[index].id).launch(context);
                        },
                        child: Column(
                          children: [
                            Container(
                                width: context.width() * .24,
                                height: 95,
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                decoration: BoxDecoration(image: DecorationImage(image: AssetImage(ic_christmas_categories))),
                                child: mCategoryModel[index].image != null
                                    ? CircleAvatar(backgroundColor: context.cardColor, backgroundImage: NetworkImage(mCategoryModel[index].image!.src.validate()), maxRadius: 60)
                                    : CircleAvatar(backgroundColor: context.cardColor, backgroundImage: AssetImage(ic_placeholder_logo), maxRadius: 60)),
                            8.height,
                            Text(parseHtmlString(mCategoryModel[index].name), maxLines: 2, textAlign: TextAlign.center, style: boldTextStyle(size: 14, color: blackColor)).center()
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : SizedBox();
    }

    Widget carousel() {
      return mSliderModel.isNotEmpty
          ? Stack(
              clipBehavior: Clip.none, alignment: Alignment.center,
              children: [
                Image.asset(ic_christmas_banner, height: 230, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(8).paddingSymmetric(horizontal: 12),
                Container(
                  height: 250,
                  padding: EdgeInsets.all(12),
                  child: PageView(
                    controller: bannerPageController,
                    onPageChanged: (i) {
                      setState(() {});
                    },
                    children: mSliderModel.map((i) {
                      return commonCacheImageWidget(i.image.validate(), fit: BoxFit.cover, height: 200, width: context.width()).cornerRadiusWithClipRRect(defaultRadius).paddingAll(6).onTap(() {
                        if (i.url!.isNotEmpty) {
                          WebViewExternalProductScreen(mExternal_URL: i.url, title: i.title).launch(context);
                        } else {
                          toast('Sorry');
                        }
                      });
                    }).toList(),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  child: DotIndicator(
                          pageController: bannerPageController,
                          currentDotSize: 8,
                          dotSize: 6,
                          pages: mSliderModel,
                          unselectedIndicatorColor: mChristmasColor.withOpacity(0.4),
                          indicatorColor: mChristmasColor)
                      .paddingTop(8),
                )
              ],
            )
          : SizedBox();
    }

    Widget mSaleBannerWidget() {
      return mSaleBanner.isNotEmpty
          ? Column(
              children: [
                16.height,
                Container(
                  height: 220,
                  child: PageView(
                    controller: saleBannerPageController,
                    onPageChanged: (i) {
                      setState(() {});
                    },
                    children: mSaleBanner.map((i) {
                      return Stack(
                        clipBehavior: Clip.none, alignment: Alignment.bottomCenter,
                        children: [
                          commonCacheImageWidget(i.image.validate(), fit: BoxFit.cover, height: 220).cornerRadiusWithClipRRect(defaultRadius),
                          Positioned(
                            bottom: -40,
                            child: Container(
                              height: 80,
                              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              padding: EdgeInsets.all(12),
                              decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                              child: Column(
                                children: [
                                  Text(i.title!, style: boldTextStyle(size: 18)),
                                  2.height,
                                  Text(
                                      appLocalization.translate('lbl_sale_start_from')! +
                                          " " +
                                          DateFormat('dd MMM').format(DateTime.parse(i.startDate.toString())) +
                                          " - " +
                                          DateFormat('dd MMM').format(DateTime.parse(i.endDate.toString())),
                                      style: secondaryTextStyle(size: 16, color: mChristmasColor)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(bottom: 16).visible(i.title!.isNotEmpty && i.image!.isNotEmpty);
                    }).toList(),
                  ),
                ),
                DotIndicator(pageController: saleBannerPageController, currentDotSize: 6, dotSize: 6, pages: mSaleBanner, indicatorColor: mChristmasColor).paddingBottom(8)
              ],
            )
          : SizedBox();
    }

    Widget _newProduct() {
      return DashboardComponent5(
        title: builderResponse.dashboard!.newProduct!.title!,
        subTitle: builderResponse.dashboard!.newProduct!.viewAll!,
        product: mNewestProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.newProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget _featureProduct() {
      return DashboardComponent5(
        title: builderResponse.dashboard!.featureProduct!.title!,
        subTitle: builderResponse.dashboard!.featureProduct!.viewAll!,
        product: mFeaturedProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.featureProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget _dealOfTheDay() {
      return availableOfferAndDeal(builderResponse.dashboard!.dealOfTheDay!.title!, mDealProductModel, builderResponse.dashboard!.dealOfTheDay!.viewAll!).visible(mDealProductModel.isNotEmpty);
    }

    Widget _bestSelling() {
      return DashboardComponent5(
        title: builderResponse.dashboard!.bestSaleProduct!.title!,
        subTitle: builderResponse.dashboard!.bestSaleProduct!.viewAll!,
        product: mSellingProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.bestSaleProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget _saleProduct() {
      return DashboardComponent5(
        title: builderResponse.dashboard!.saleProduct!.title!,
        subTitle: builderResponse.dashboard!.saleProduct!.viewAll!,
        product: mSaleProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.saleProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget _offer() {
      return availableOfferAndDeal(builderResponse.dashboard!.offerProduct!.title!, mOfferProductModel, builderResponse.dashboard!.offerProduct!.viewAll!).visible(mOfferProductModel.isNotEmpty);
    }

    Widget _suggested() {
      return DashboardComponent5(
        title: builderResponse.dashboard!.suggestionProduct!.title!,
        subTitle: builderResponse.dashboard!.suggestionProduct!.viewAll!,
        product: mSuggestedProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.suggestionProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget _youMayLike() {
      return DashboardComponent5(
        title: builderResponse.dashboard!.youMayLikeProduct!.title!,
        subTitle: builderResponse.dashboard!.youMayLikeProduct!.viewAll!,
        product: mYouMayLikeProductModel,
        onTap: () {
          ViewAllScreen(builderResponse.dashboard!.youMayLikeProduct!.title, isNewest: true).launch(context);
        },
      );
    }

    Widget body = Stack(
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            Image.asset(ic_christmas_border, width: context.width()),
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
                  return mVendor5Widget(context, mVendorModel, builderResponse.dashboard!.vendor!.title, builderResponse.dashboard!.vendor!.viewAll)
                      .visible(builderResponse.dashboard!.vendor!.enable!);
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
            Image.asset(ic_christmas_tag, fit: BoxFit.fitWidth, width: context.width(), height: 160),
            Image.asset(ic_christmas_bottom, fit: BoxFit.fitWidth, width: context.width())
          ],
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: mChristmasColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search_sharp, color: white),
            onPressed: () {
              SearchScreen().launch(context);
            },
          )
        ],
        title: Text(AppName, style: boldTextStyle(size: 18, color: white)),
        automaticallyImplyLeading: false,
      ),
      key: scaffoldKey,
      body: RefreshIndicator(
        color: primaryColor,
        backgroundColor: context.cardColor,
        onRefresh: () {
          return fetchDashboardData();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            body.visible(!appStore.isLoading),
            mProgress().center().visible(appStore.isLoading),
          ],
        ),
      ),
    );
  }
}
