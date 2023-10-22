import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import '/../component/HtmlWidget.dart';
import '/../component/VideoPlayDialog.dart';
import '/../main.dart';
import '/../models/ProductDetailResponse.dart';
import '/../models/ProductReviewModel.dart';
import '/../network/rest_apis.dart';
import '/../screen/ViewAllScreen.dart';
import '/../screen/ZoomImageScreen.dart';
import '/../utils/AppBarWidget.dart';
import '/../utils/Countdown.dart';
import '/../utils/AdmobUtils.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import '/../utils/AppImages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../AppLocalizations.dart';
import 'ProductDetailScreen1.dart';
import 'ProductDetailScreen2.dart';
import '../ReviewScreen.dart';
import '../SignInScreen.dart';
import '../VendorProfileScreen.dart';
import '../WebViewExternalProductScreen.dart';

class ProductDetailScreen3 extends StatefulWidget {
  final int? mProId;

  ProductDetailScreen3({Key? key, this.mProId}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen3> {
  ProductDetailResponse? productDetailNew;

  String mProfileImage = '';
  int? selectedOptionAvailableIn = 0;

  List<ProductDetailResponse> mProducts = [];
  List<ProductReviewModel> mReviewModel = [];
  List<ProductDetailResponse> mProductsList = [];
  List<String?> mProductOptions = [];
  List<int> mProductVariationsIds = [];
  List<ProductDetailResponse> product = [];
  List<Widget> productImg = [];
  List<String?> productImg1 = [];

  // InterstitialAd? interstitialAd;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  bool mIsGroupedProduct = false;
  bool mIsExternalProduct = false;

  bool mIsLoggedIn = false;

  double rating = 0.0;
  double discount = 0.0;

  int selectIndex = 0;
  int _currentPage = 0;

  String videoType = '';
  String? mSelectedVariation = '';
  String mExternalUrl = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  setTimer() {
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  init() async {
    afterBuildCreated(() {
      // adShow();
      productDetail();
      fetchReviewData();
      setTimer();
    });
  }

  // adShow() async {
  //   if (interstitialAd == null) {
  //     print('Warning: attempt to show interstitial before loaded.');
  //     return;
  //   }
  //   interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       print('$ad onAdDismissedFullScreenContent.');
  //       ad.dispose();
  //       _createInterstitialAd();
  //     },
  //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //       _createInterstitialAd();
  //     },
  //   );
  //   enableAds ? interstitialAd!.show() : SizedBox();
  // }

  // void _createInterstitialAd() {
  //   InterstitialAd.load(
  //       adUnitId: getInterstitialAdUnitId()!,
  //       request: AdRequest(),
  //       adLoadCallback: InterstitialAdLoadCallback(
  //         onAdLoaded: (InterstitialAd ad) {
  //           print('$ad loaded');
  //           interstitialAd = ad;
  //         },
  //         onAdFailedToLoad: (LoadAdError error) {
  //           print('InterstitialAd failed to load: $error.');
  //           interstitialAd = null;
  //         },
  //       ));
  // }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Future<void> dispose() async {
    _pageController.dispose();
    super.dispose();
  }

  Future productDetail() async {
    mIsLoggedIn = getBoolAsync(IS_LOGGED_IN);
    await getProductDetail(widget.mProId).then((res) {
      if (!mounted) return;
      setState(() {
        appStore.setLoading(false);
        Iterable mInfo = res;
        mProducts = mInfo.map((model) => ProductDetailResponse.fromJson(model)).toList();
        if (mProducts.isNotEmpty) {
          productDetailNew = mProducts[0];

          rating = double.parse(productDetailNew!.averageRating!);
          productDetailNew!.variations!.forEach((element) {
            mProductVariationsIds.add(element);
          });

          mProductsList.clear();

          for (var i = 0; i < mProducts.length; i++) {
            if (i != 0) {
              mProductsList.add(mProducts[i]);
            }
          }

          if (productDetailNew!.type == "variable" || productDetailNew!.type == "variation") {
            mProductOptions.clear();
            mProductsList.forEach((product) {
              var option = '';

              product.attributes!.forEach((attribute) {
                if (option.isNotEmpty) {
                  option = '$option - ${attribute.option.validate()}';
                } else {
                  option = attribute.option.validate();
                }
              });

              if (product.onSale!) {
                option = '$option [Sale]';
              }

              mProductOptions.add(option);
            });
            if (mProductOptions.isNotEmpty) mSelectedVariation = mProductOptions.first;

            if (productDetailNew!.type == "variable" || productDetailNew!.type == "variation" && mProductsList.isNotEmpty) {
              productDetailNew = mProductsList[0];
              mProducts = mProducts;
            }
            log('mProductOptions');
          } else if (productDetailNew!.type == 'grouped') {
            mIsGroupedProduct = true;
            product.clear();
            product.addAll(mProductsList);
          }

          if (productDetailNew!.woofVideoEmbed != null) {
            if (productDetailNew!.woofVideoEmbed!.url != '') {
              if (productDetailNew!.woofVideoEmbed!.url.validate().contains(VideoTypeYouTube)) {
                videoType = VideoTypeYouTube;
              } else if (productDetailNew!.woofVideoEmbed!.url.validate().contains(VideoTypeIFrame)) {
                videoType = VideoTypeIFrame;
              } else {
                videoType = VideoTypeCustom;
              }
              productImg.add(
                Stack(
                  fit: StackFit.expand,
                  children: [
                    commonCacheImageWidget(
                      productDetailNew!.images![0].src.validate(),
                      fit: BoxFit.cover,
                      height: 400,
                      width: double.infinity,
                    ).cornerRadiusWithClipRRectOnly(topLeft: 20, topRight: 20).paddingOnly(bottom: 24),
                    Icon(Icons.play_circle_fill_outlined, size: 40, color: Colors.black12).center(),
                  ],
                ).onTap(() {
                  VideoPlayDialog(data: productDetailNew!.woofVideoEmbed).launch(context);
                }),
              );
            }
          }
          mImage();
          setPriceDetail();
        }
      });
    }).catchError((error) {
      log('error:$error');
      appStore.setLoading(false);
      toast(error.toString());
      setState(() {});
    });
  }

  Future fetchReviewData() async {
    setState(() {
      appStore.setLoading(true);
    });
    await getProductReviews(widget.mProId).then((res) {
      if (!mounted) return;
      setState(() {
        appStore.setLoading(false);
        Iterable list = res;
        mReviewModel = list.map((model) => ProductReviewModel.fromJson(model)).toList();
      });
    }).catchError((error) {
      setState(() {
        appStore.setLoading(false);
      });
    });
  }

// Set Price Detail
  Widget setPriceDetail() {
    setState(() {
      if (productDetailNew!.onSale! && productDetailNew!.type != 'grouped') {
        double mrp = double.parse(productDetailNew!.regularPrice!).toDouble();
        double discountPrice = double.parse(productDetailNew!.price!).toDouble();
        discount = ((mrp - discountPrice) / mrp) * 100;
      }
    });
    return SizedBox();
  }

  void mImage() {
    setState(() {
      productImg1.clear();
      productDetailNew!.images!.forEach((element) {
        productImg1.add(element.src);
      });
    });
  }

  Widget mDiscount() {
    if (productDetailNew!.onSale!)
      return Text(
        '${discount.toInt()} % ${AppLocalizations.of(context)!.translate('lbl_off1')!}',
        style: primaryTextStyle(
          color: Colors.red,
          size: 14,
          decoration: TextDecoration.underline,
          textDecorationStyle: TextDecorationStyle.solid,
        ),
      );
    else
      return SizedBox();
  }

  Widget mSpecialPrice(String? value) {
    if (productDetailNew != null) {
      if (productDetailNew!.dateOnSaleTo != "") {
        var endTime = productDetailNew!.dateOnSaleTo.toString() + " 23:59:59.000";
        var endDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(endTime);
        var currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(DateTime.now().toString());
        var format = endDate.subtract(Duration(days: currentDate.day, hours: currentDate.hour, minutes: currentDate.minute, seconds: currentDate.second));
        log(format);

        return Countdown(
          duration: Duration(days: format.day, hours: format.hour, minutes: format.minute, seconds: format.second),
          onFinish: () {
            log('finished!');
          },
          builder: (BuildContext ctx, Duration? remaining) {
            var seconds = ((remaining!.inMilliseconds / 1000) % 60).toInt();
            var minutes = (((remaining.inMilliseconds / (1000 * 60)) % 60)).toInt();
            var hours = (((remaining.inMilliseconds / (1000 * 60 * 60)) % 24)).toInt();
            log(hours);
            return Container(
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(4), backgroundColor: colorAccent!.withOpacity(0.3)),
              child: Text(
                value! + " " + '${remaining.inDays}d ${hours}h ${minutes}m ${seconds}s',
                style: primaryTextStyle(size: 12),
              ).paddingAll(8),
            ).paddingOnly(left: 16, right: 16, top: 16, bottom: 16);
          },
        );
      } else {
        return SizedBox();
      }
    } else {
      return SizedBox();
    }
  }

// get Additional Information
  String getAllAttribute(Attribute attribute) {
    String attributes = "";
    for (var i = 0; i < attribute.options!.length; i++) {
      attributes = attributes + attribute.options![i];
      if (i < attribute.options!.length - 1) {
        attributes = attributes + ", ";
      }
    }
    return attributes;
  }

// Set additional information
  Widget mSetAttribute() {
    return AnimatedListView(
      itemCount: productDetailNew!.attributes!.length,
      padding: EdgeInsets.only(left: 8, right: 8),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, i) {
        return productDetailNew!.attributes![i].options != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productDetailNew!.attributes![i].name, style: primaryTextStyle()).visible(productDetailNew!.attributes![i].options!.isNotEmpty),
                  8.height.visible(productDetailNew!.attributes!.isNotEmpty),
                  Text(getAllAttribute(productDetailNew!.attributes![i]), maxLines: 4, style: secondaryTextStyle()),
                ],
              ).paddingOnly(left: 8)
            : SizedBox();
      },
    );
  }

// ignore: missing_return
  mOtherAttribute() {
    toast('Product type not supported');
    finish(context);
  }

  @override
  Widget build(BuildContext context) {
    setValue(CARTCOUNT, appStore.count);

    var appLocalization = AppLocalizations.of(context);

    Widget mUpcomingSale() {
      if (productDetailNew != null) {
        if (productDetailNew!.dateOnSaleFrom != "") {
          int diff = DateTime.parse(productDetailNew!.dateOnSaleFrom.validate()).difference(DateTime.now()).inMilliseconds;
          return diff > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(thickness: 6, color: appStore.isDarkMode! ? white.withOpacity(0.2) : Theme.of(context).textTheme.headlineMedium!.color),
                    Text(
                      appLocalization!.translate('lbl_upcoming_sale_on_this_item')!,
                      style: boldTextStyle(),
                    ).paddingAll(16),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, bottom: 10),
                      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: primaryColor!.withOpacity(0.2)),
                      width: context.width(),
                      padding: EdgeInsets.fromLTRB(2, 8, 2, 8),
                      child: Marquee(
                        directionMarguee: DirectionMarguee.oneDirection,
                        child: Text(
                          appLocalization.translate('lbl_sale_start_from')! +
                              " " +
                              productDetailNew!.dateOnSaleFrom! +
                              " " +
                              appLocalization.translate('lbl_to')! +
                              " " +
                              productDetailNew!.dateOnSaleTo! +
                              ". " +
                              appLocalization.translate('lbl_ge_amazing_discounts_on_the_products')!,
                          style: secondaryTextStyle(color: Theme.of(context).textTheme.titleSmall!.color, size: 16),
                        ).paddingLeft(16),
                      ),
                    ),
                  ],
                )
              : SizedBox();
        } else {
          return SizedBox();
        }
      } else {
        return SizedBox();
      }
    }

    Widget _review() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalization!.translate("lbl_reviews")!,
            style: boldTextStyle(),
          ).paddingOnly(left: 16, right: 16, bottom: 4).visible(mReviewModel.isNotEmpty),
          ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: mReviewModel.length >= 5 ? 5 : mReviewModel.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          mProfileImage.isNotEmpty
                              ? CircleAvatar(backgroundImage: NetworkImage(mProfileImage.validate()), radius: 24)
                              : CircleAvatar(
                                  backgroundImage: Image.asset(User_Profile).image,
                                  radius: 24,
                                ),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mReviewModel[index].reviewer!, style: boldTextStyle(size: 14)),
                              8.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  RatingBar.builder(
                                    initialRating: mReviewModel[index].rating!.toDouble(),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    ignoreGestures: true,
                                    itemCount: 5,
                                    itemSize: 18,
                                    itemBuilder: (context, _) => Icon(Icons.star,
                                        color: mReviewModel[index].rating == 1
                                            ? redColor
                                            : mReviewModel[index].rating == 2
                                                ? yellowColor
                                                : mReviewModel[index].rating == 3
                                                    ? yellowColor
                                                    : Color(0xFF66953A),
                                        size: 14),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  8.width,
                                  Text(reviewConvertDate(mReviewModel[index].dateCreated), style: secondaryTextStyle()),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      4.height,
                      Text(parseHtmlString(mReviewModel[index].review), style: secondaryTextStyle(), maxLines: 3, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(appLocalization.translate("lbl_view_all_review")!, style: boldTextStyle(color: context.accentColor)),
              Icon(Icons.chevron_right),
            ],
          )
              .onTap(() {
                ReviewScreen(mProductId: widget.mProId).launch(context);
              })
              .paddingAll(16)
              .visible(mReviewModel.length >= 3 && productDetailNew!.reviewsAllowed == true),
        ],
      );
    }

    Widget upSaleProductList(List<UpsellId> product) {
      var productWidth = MediaQuery.of(context).size.width;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          8.height,
          Text(appLocalization!.translate('lbl_like')!, style: boldTextStyle()).paddingLeft(12.toDouble()),
          Container(
            margin: EdgeInsets.only(top: 4),
            height: 320,
            child: AnimatedListView(
              itemCount: product.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {
                    if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 1) {
                      ProductDetailScreen1(mProId: product[i].id).launch(context);
                    } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 2) {
                      ProductDetailScreen2(mProId: product[i].id).launch(context);
                    } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 3) {
                      ProductDetailScreen3(mProId: product[i].id).launch(context);
                    } else {
                      ProductDetailScreen1(mProId: product[i].id).launch(context);
                    }
                  },
                  child: Container(
                    width: context.width() * 0.55,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(border: Border.all(color: gray.withOpacity(0.5), width: 0.5)),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 16),
                          padding: EdgeInsets.all(1.2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF37D5D6),
                                Color(0xFF63A4FF),
                              ],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(1.0, 0.0),
                            ),
                          ),
                          child: commonCacheImageWidget(product[i].images!.first.src, height: 200, width: productWidth, fit: BoxFit.cover),
                        ),
                        4.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product[i].name!, style: primaryTextStyle(size: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                            //  8.height,
                            Row(
                              children: [
                                PriceWidget(price: product[i].salePrice.toString().isNotEmpty ? product[i].salePrice.toString() : product[i].price.toString(), size: 14),
                                4.width,
                                PriceWidget(price: product[i].regularPrice.toString(), size: 12, isLineThroughEnabled: true, color: Theme.of(context).textTheme.titleSmall!.color).visible(product[i].salePrice.toString().isNotEmpty),
                              ],
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
    }

    Widget mGroupAttribute(List<ProductDetailResponse> product) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(appLocalization!.translate('lbl_product_Involve')!, style: boldTextStyle()).paddingOnly(left: 12, top: 8),
          AnimatedListView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: product.length,
              padding: EdgeInsets.only(left: 12, right: 8),
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {
                    if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 1) {
                      ProductDetailScreen1(mProId: product[i].id).launch(context);
                    } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 2) {
                      ProductDetailScreen2(mProId: product[i].id).launch(context);
                    } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 3) {
                      ProductDetailScreen3(mProId: product[i].id).launch(context);
                    } else {
                      ProductDetailScreen1(mProId: product[i].id).launch(context);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        commonCacheImageWidget(product[i].images![0].src, height: 90, width: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(8),
                        10.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product[i].name!, style: primaryTextStyle()),
                            4.height,
                            Row(
                              children: [
                                PriceWidget(
                                    price: product[i].salePrice.toString().validate().isNotEmpty ? product[i].salePrice.toString() : product[i].price.toString().validate(),
                                    size: 14,
                                    color: Theme.of(context).textTheme.titleSmall!.color),
                                2.width,
                                PriceWidget(price: product[i].regularPrice.toString(), size: 12, isLineThroughEnabled: true, color: Theme.of(context).textTheme.titleSmall!.color).visible(product[i].salePrice.toString().isNotEmpty),
                              ],
                            ),
                            8.height,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: product[i].inStock == true ? primaryColor! : white, border: Border.all(color: primaryColor!)),
                              child: Text(
                                product[i].inStock == true
                                    ? product[i].type == 'external'
                                        ? product[i].buttonText!
                                        : cartStore.isItemInCart(product[i].id.validate())
                                            ? appLocalization.translate('lbl_remove_cart')!.toUpperCase()
                                            : appLocalization.translate('lbl_add_to_cart')!.toUpperCase()
                                    : appLocalization.translate('lbl_sold_out')!.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: boldTextStyle(color: product[i].inStock == false ? primaryColor : white, size: 12),
                              ),
                            ).onTap(() {
                              if (product[i].inStock == true) {
                                if (product[i].type == 'external') {
                                  WebViewExternalProductScreen(mExternal_URL: product[i].externalUrl, title: appLocalization.translate('lbl_external_product')).launch(context);
                                } else if (!getBoolAsync(IS_LOGGED_IN)) {
                                  SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                                } else {
                                  addCart(data: product[i]);

                                  init();
                                  setState(() {});
                                }
                              }
                            }),
                          ],
                        ).expand(),
                      ],
                    ),
                  ),
                );
              })
        ],
      );
    }

    final videoSlider = productDetailNew != null
        ? Column(
            children: [
              Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
                margin: EdgeInsets.only(bottom: 8),
                child: PageView(
                  children: productImg,
                  controller: _pageController,
                  onPageChanged: (index) {
                    selectIndex = index;
                    setState(() {});
                  },
                ),
              ),
              DotIndicator(
                pageController: _pageController,
                pages: productImg,
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

    final imgSlider = productDetailNew != null
        ? Column(
            children: [
              Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
                margin: EdgeInsets.only(bottom: 8),
                child: PageView(
                  children: productImg1.map((i) {
                    return commonCacheImageWidget(i.validate(), fit: BoxFit.cover, width: double.infinity).cornerRadiusWithClipRRectOnly(topLeft: 20, topRight: 20).onTap(() {
                      ZoomImageScreen(mImgList: productDetailNew!.images!).launch(context);
                    });
                  }).toList(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    selectIndex = index;
                    setState(() {});
                  },
                ),
              ),
              DotIndicator(
                pageController: _pageController,
                pages: productImg1,
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

    // Check Wish list
    final mFavourite = productDetailNew != null
        ? GestureDetector(
            onTap: () {
              if (productDetailNew!.type! == 'external') {
                toast(appLocalization!.translate('lbl_external_wishlist_msg')!);
              } else {
                checkWishList(productDetailNew, context);
                setState(() {});
              }
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(8), backgroundColor: Theme.of(context).cardTheme.color!, border: Border.all(color: primaryColor!)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  wishListStore.isItemInWishlist(productDetailNew!.id!) == false ? Icon(Icons.favorite_border, color: primaryColor) : Icon(Icons.favorite, color: redColor),
                ],
              ),
            ),
          ).visible(productDetailNew!.isAddedWishList != null)
        : SizedBox();

    final mCartData = productDetailNew != null
        ? GestureDetector(
            onTap: () {
              if (productDetailNew!.inStock == true) {
                if (mIsExternalProduct) {
                  WebViewExternalProductScreen(mExternal_URL: mExternalUrl, title: appLocalization!.translate('lbl_external_product')).launch(context);
                } else if (!getBoolAsync(IS_LOGGED_IN)) {
                  SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                } else {
                  addCart(data: productDetailNew!);
                  init();
                  setState(() {});
                }
              }
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(8), backgroundColor: productDetailNew!.inStock! ? context.primaryColor : textSecondaryColorGlobal.withOpacity(0.3)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, color: white),
                  4.width,
                  Text(
                    productDetailNew!.inStock! == true
                        ? productDetailNew!.type! == 'external'
                            ? productDetailNew!.buttonText!
                            : cartStore.isItemInCart(productDetailNew!.id.validate())
                                ? appLocalization!.translate('lbl_remove_cart')!.toUpperCase()
                                : appLocalization!.translate('lbl_add_to_basket')!.toUpperCase()
                        : appLocalization!.translate('lbl_sold_out')!.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: boldTextStyle(color: white, wordSpacing: 1, size: 14),
                  ),
                ],
              ),
            ),
          )
        : SizedBox();

    Widget mGetPrice() {
      final mPrice = productDetailNew != null
          ? productDetailNew!.onSale == true
              ? Row(
                  children: [
                    Text(appLocalization!.translate('lbl_mrp')! + " : ", style: primaryTextStyle(color: context.iconColor)),
                    4.width,
                    PriceWidget(
                        price: productDetailNew!.salePrice.toString().isNotEmpty ? double.parse(productDetailNew!.salePrice.toString()).toStringAsFixed(2) : double.parse(productDetailNew!.price.toString()).toStringAsFixed(2),
                        size: 18),
                    PriceWidget(
                      price: double.parse(productDetailNew!.regularPrice.toString()).toStringAsFixed(2),
                      size: 12,
                      color: Theme.of(context).textTheme.titleMedium!.color,
                      isLineThroughEnabled: true,
                    ).paddingOnly(left: 4).visible(productDetailNew!.salePrice.toString().isNotEmpty && productDetailNew!.onSale == true),
                    8.width,
                    Container(width: 1, height: 12, color: gray),
                    8.width,
                    mDiscount().visible(productDetailNew!.salePrice.toString().isNotEmpty && productDetailNew!.onSale == true)
                  ],
                )
              : Row(
                  children: [
                    Text(appLocalization!.translate('lbl_mrp')! + " : ", style: primaryTextStyle(color: context.iconColor)),
                    4.width,
                    PriceWidget(price: double.parse(productDetailNew!.price.toString()).toStringAsFixed(2), size: 18),
                  ],
                )
          : SizedBox();
      return mPrice;
    }

    Widget mSavePrice() {
      if (productDetailNew != null) {
        if (productDetailNew!.onSale!) {
          var value = double.parse(productDetailNew!.regularPrice.toString()) - double.parse(productDetailNew!.price.toString());
          if (value > 0) {
            return Row(
              children: [Text(appLocalization!.translate('lbl_save')! + " : ", style: secondaryTextStyle()), PriceWidget(price: value.toStringAsFixed(2), size: 16, color: greenColor)],
            ).paddingOnly(top: 4, left: 12, right: 8);
          } else {
            return SizedBox();
          }
        } else {
          return SizedBox();
        }
      } else {
        return SizedBox();
      }
    }

    Widget mExternalAttribute() {
      setPriceDetail();
      mIsExternalProduct = true;
      mExternalUrl = productDetailNew!.externalUrl.toString();
      return SizedBox();
    }

    final body = productDetailNew != null
        ? Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    productDetailNew!.images!.isNotEmpty
                        ? productDetailNew!.woofVideoEmbed != null && productDetailNew!.woofVideoEmbed!.url != ''
                            ? videoSlider
                            : imgSlider
                        : SizedBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(productDetailNew!.name!, style: boldTextStyle(size: 18)).paddingOnly(left: 12, right: 12).expand(),
                            if (productDetailNew!.onSale == true)
                              FittedBox(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
                                  child: Text(appLocalization!.translate('lbl_sale')!, style: boldTextStyle(color: Colors.white, size: 14)),
                                ).cornerRadiusWithClipRRectOnly(topLeft: 0, bottomLeft: 4).paddingOnly(left: 12, right: 12, bottom: 8),
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (productDetailNew!.type != 'grouped') mGetPrice(),
                            FittedBox(
                              child: Container(
                                decoration: boxDecorationWithRoundedCorners(backgroundColor: Theme.of(context).cardTheme.color!, border: Border.all(color: view_color)),
                                padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                margin: EdgeInsets.only(right: 16),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: rating.toString() + " ", style: secondaryTextStyle(size: 12)),
                                      WidgetSpan(child: Icon(Icons.star, size: 14, color: bgCardColor)),
                                    ],
                                  ),
                                ),
                              ),
                            ).onTap(() async {
                              final double? result = await ReviewScreen(mProductId: widget.mProId).launch(context);
                              if (result == null) {
                                rating = rating;
                                setState(() {});
                              } else {
                                rating = result;
                                setState(() {});
                              }
                            }).visible(productDetailNew!.reviewsAllowed == true)
                          ],
                        ).paddingOnly(top: 4, left: 12).visible(!productDetailNew!.type!.contains("grouped")),
                        if (productDetailNew!.type != 'grouped') mSavePrice(),
                        if (productDetailNew!.store != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(appLocalization!.translate('lbl_vendor')!, style: primaryTextStyle(color: Theme.of(context).textTheme.titleMedium!.color)).visible(productDetailNew!.store!.shopName.validate().isNotEmpty),
                                  8.width,
                                  Text(productDetailNew!.store!.shopName != null ? productDetailNew!.store!.shopName! : '', style: boldTextStyle(color: primaryColor)),
                                ],
                              ),
                              8.width,
                              Icon(Icons.arrow_forward_ios_outlined, color: context.iconColor, size: 16),
                            ],
                          ).paddingOnly(left: 12, right: 16, top: 8).onTap(() {
                            VendorProfileScreen(mVendorId: productDetailNew!.store!.id).launch(context);
                          }).visible(productDetailNew!.store!.shopName.validate().isNotEmpty),
                        if (productDetailNew!.onSale!) productDetailNew!.dateOnSaleFrom!.isNotEmpty ? mSpecialPrice(appLocalization!.translate('lbl_special_msg')) : SizedBox(),
                        if (productDetailNew!.type == "variable" || productDetailNew!.type == "variation")
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(appLocalization!.translate('lbl_possible')!, style: boldTextStyle()).paddingOnly(left: 12, right: 12, top: 8),
                              Wrap(
                                spacing: 8,
                                children: mProductOptions.map((e) {
                                  int index = mProductOptions.indexOf(e);
                                  return Container(
                                    margin: EdgeInsets.only(top: 8, bottom: 8, left: 8),
                                    padding: EdgeInsets.all(8),
                                    decoration: boxDecorationWithRoundedCorners(backgroundColor: selectedOptionAvailableIn == index ? bgCardColor : context.cardColor, border: Border.all(width: 0.1)),
                                    child: Text(e!, style: secondaryTextStyle(color: selectedOptionAvailableIn == index ? black : textSecondaryColour)),
                                  ).onTap(() {
                                    setState(
                                      () {
                                        mSelectedVariation = e;
                                        selectedOptionAvailableIn = index;
                                        mProducts.forEach((product) {
                                          if (mProductVariationsIds[index] == product.id) {
                                            this.productDetailNew = product;
                                          }
                                        });
                                        setPriceDetail();
                                        mImage();
                                      },
                                    );
                                  });
                                }).toList(),
                              ).paddingLeft(4)
                            ],
                          ).visible(mProductOptions.length != 0)
                        else if (productDetailNew!.type == "grouped")
                          mGroupAttribute(product)
                        else if (productDetailNew!.type == "simple")
                          Container()
                        else if (productDetailNew!.type == "external")
                          Column(
                            children: [
                              mExternalAttribute(),
                            ],
                          )
                        else
                          mOtherAttribute(),
                        mUpcomingSale().visible(!productDetailNew!.onSale!),
                        Text(appLocalization!.translate('lbl_product_details')!, style: boldTextStyle()).paddingOnly(left: 12, right: 12, top: 8).visible(productDetailNew!.description!.isNotEmpty),
                        HtmlWidget(postContent: productDetailNew!.description.toString().trim()).paddingOnly(right: 6, left: 6).visible(productDetailNew!.description!.isNotEmpty),
                        mSetAttribute().paddingBottom(8).visible(productDetailNew!.attributes!.isNotEmpty),
                        Text(appLocalization.translate('lbl_short_description')!, style: boldTextStyle()).paddingOnly(top: 8, left: 12, right: 12).visible(productDetailNew!.shortDescription.toString().isNotEmpty),
                        HtmlWidget(postContent: productDetailNew!.shortDescription).paddingOnly(left: 6, right: 6).visible(productDetailNew!.shortDescription.toString().isNotEmpty),
                        Text(appLocalization.translate('lbl_shop_category')!, style: boldTextStyle()).paddingOnly(left: 12, right: 12, top: 8).visible(productDetailNew!.categories!.isNotEmpty),
                        4.height.visible(productDetailNew!.categories!.isNotEmpty),
                        Wrap(
                          children: productDetailNew!.categories!.map((e) {
                            // int cIndex = productDetailNew!.categories!.indexOf(e);
                            return Container(
                              margin: EdgeInsets.only(right: 8, left: 6, top: 8, bottom: 8),
                              padding: EdgeInsets.all(8),
                              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, border: Border.all(width: 0.1)),
                              child: Text(e.name!, style: secondaryTextStyle()),
                            ).onTap(() {
                              ViewAllScreen(e.name, isCategory: true, categoryId: e.id).launch(context);
                            });
                          }).toList(),
                        ).paddingOnly(left: 8, right: 8).visible(productDetailNew!.categories!.isNotEmpty),
                        if (productDetailNew!.upSellIds != null) upSaleProductList(productDetailNew!.upSellId!).visible(productDetailNew!.upSellId!.isNotEmpty),
                        8.height,
                        _review(),
                        16.height,
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        : SizedBox();

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: white),
            onPressed: () {
              finish(context);
              appStore.setLoading(false);
            },
          ),
          actions: [
            mCart(context, mIsLoggedIn, color: white),
          ],
          title: Text(productDetailNew != null ? productDetailNew!.name! : ' ', style: boldTextStyle(color: Colors.white, size: 18)),
          automaticallyImplyLeading: false),
      body: Observer(builder: (context) {
        return BodyCornerWidget(
          child: mView(
              Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  productDetailNew != null ? body : SizedBox(),
                  Center(child: mProgress()).visible(appStore.isLoading),
                ],
              ),
              context),
        );
      }),
      bottomNavigationBar: Container(
        width: context.width(),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: <BoxShadow>[
            BoxShadow(color: Theme.of(context).hoverColor.withOpacity(0.8), blurRadius: 15.0, offset: Offset(0.0, 0.75)),
          ],
        ),
        child: Row(
          children: [mFavourite, 16.width, Expanded(child: mCartData, flex: 1)],
        ).paddingOnly(top: 8, bottom: 8, right: 16, left: 16).visible(!mIsGroupedProduct),
      ).visible(productDetailNew != null),
    );
  }
}
