import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
import 'ProductDetailScreen3.dart';
import '../ReviewScreen.dart';
import '../SignInScreen.dart';
import '../VendorProfileScreen.dart';
import '../WebViewExternalProductScreen.dart';

class ProductDetailScreen2 extends StatefulWidget {
  final int? mProId;

  ProductDetailScreen2({Key? key, this.mProId}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen2> {
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

  InterstitialAd? interstitialAd;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
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
      adShow();
      productDetail();
      fetchReviewData();
      setTimer();
    });
  }

  adShow() async {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    enableAds ? interstitialAd!.show() : SizedBox();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: getInterstitialAdUnitId()!,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            interstitialAd = null;
          },
        ));
  }

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
      return DottedBorder(
        color: context.iconColor,
        strokeWidth: 1,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          '${discount.toInt()} % ${AppLocalizations.of(context)!.translate('lbl_off1')!}',
          style: primaryTextStyle(
            color: Colors.red,
            size: 14,
          ),
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
      padding: EdgeInsets.only(left: 4, right: 4),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, i) {
        return productDetailNew!.attributes![i].options != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productDetailNew!.attributes![i].name, style: primaryTextStyle()).visible(productDetailNew!.attributes![i].options != null),
                  4.height,
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
      return Container(
        width: context.width(),
        padding: EdgeInsets.only(top: 8, bottom: 16),
        margin: EdgeInsets.only(top: 8),
        decoration: boxDecorationRoundedWithShadow(0, backgroundColor: context.cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.height,
            Text(appLocalization!.translate("lbl_customer_review")!, style: boldTextStyle()).paddingOnly(left: 16, right: 16, bottom: 4).visible(mReviewModel.isNotEmpty),
            ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider();
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: mReviewModel.length >= 5 ? 5 : mReviewModel.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mProfileImage.isNotEmpty ? CircleAvatar(backgroundImage: NetworkImage(mProfileImage.validate()), radius: 24) : CircleAvatar(backgroundImage: Image.asset(User_Profile).image, radius: 24),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mReviewModel[index].reviewer!, style: primaryTextStyle()),
                            4.height,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RatingBar.builder(
                                      initialRating: mReviewModel[index].rating!.toDouble(),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      ignoreGestures: true,
                                      itemCount: 5,
                                      itemSize: 16,
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
                                4.height,
                                Text(parseHtmlString(mReviewModel[index].review), style: secondaryTextStyle(), maxLines: 3, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ],
                        ).expand(),
                      ],
                    ),
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLocalization.translate("lbl_view_all_customer_review")!, style: boldTextStyle(color: context.accentColor)),
                Icon(Icons.chevron_right),
              ],
            ).paddingAll(16).visible(mReviewModel.length >= 3 && productDetailNew!.reviewsAllowed == true).onTap(() {
              ReviewScreen(mProductId: productDetailNew!.id).launch(context);
            })
          ],
        ),
      ).visible(mReviewModel.isNotEmpty);
    }

    Widget upSaleProductList(List<UpsellId> product) {
      var productWidth = MediaQuery.of(context).size.width;
      return Container(
        width: context.width(),
        padding: EdgeInsets.only(top: 8, bottom: 8),
        margin: EdgeInsets.only(top: 8, bottom: 8),
        decoration: boxDecorationRoundedWithShadow(0, backgroundColor: context.cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            8.height,
            Text(builderResponse.dashboard!.youMayLikeProduct!.title!, style: boldTextStyle()).paddingLeft(16),
            8.height,
            HorizontalList(
              itemCount: product.length,
              padding: EdgeInsets.only(left: 8),
              itemBuilder: (context, i) {
                return Container(
                  width: 160,
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(blurRadius: 0.3, spreadRadius: 0.2, color: gray.withOpacity(0.4))], backgroundColor: Theme.of(context).cardTheme.color!),
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: radius(8),
                          backgroundColor: Theme.of(context).colorScheme.background,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF37D5D6),
                              Color(0xFF63A4FF),
                            ],
                            begin: FractionalOffset(0.0, 0.0),
                            end: FractionalOffset(1.0, 0.0),
                          ),
                        ),
                        child: commonCacheImageWidget(product[i].images!.first.src, height: 180, width: productWidth, fit: BoxFit.cover).cornerRadiusWithClipRRect(8),
                      ),
                      4.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product[i].name!, style: primaryTextStyle(size: 12), maxLines: 2),
                          8.height,
                          Row(
                            children: [
                              PriceWidget(price: product[i].salePrice.toString().isNotEmpty ? product[i].salePrice.toString() : product[i].price.toString(), size: 14),
                              4.width,
                              PriceWidget(price: product[i].regularPrice.toString(), size: 12, isLineThroughEnabled: true, color: Theme.of(context).textTheme.titleSmall!.color).visible(product[i].salePrice.toString().isNotEmpty),
                            ],
                          ),
                        ],
                      ).paddingOnly(left: 8, top: 8, bottom: 8, right: 8),
                    ],
                  ),
                ).onTap(() {
                  if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 1) {
                    ProductDetailScreen1(mProId: product[i].id).launch(context);
                  } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 2) {
                    ProductDetailScreen2(mProId: product[i].id).launch(context);
                  } else if (getIntAsync(PRODUCT_DETAIL_VARIANT, defaultValue: 1) == 3) {
                    ProductDetailScreen3(mProId: product[i].id).launch(context);
                  } else {
                    ProductDetailScreen1(mProId: product[i].id).launch(context);
                  }
                });
              },
            )
          ],
        ),
      );
    }

    Widget mGroupAttribute(List<ProductDetailResponse> product) {
      return Container(
        width: context.width(),
        padding: EdgeInsets.only(top: 8, bottom: 8),
        margin: EdgeInsets.only(top: 8, bottom: 8),
        decoration: boxDecorationRoundedWithShadow(0, backgroundColor: context.cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(appLocalization!.translate('lbl_product_include')!, style: boldTextStyle()).paddingOnly(left: 12, top: 8),
            AnimatedListView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: product.length,
              padding: EdgeInsets.only(left: 6, right: 6),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product[i].name!, style: primaryTextStyle()),
                            4.height,
                            product[i].onSale!
                                ? Row(
                                    children: [
                                      PriceWidget(
                                          price: product[i].salePrice.toString().validate().isNotEmpty ? product[i].salePrice.toString() : product[i].price.toString().validate(),
                                          size: 14,
                                          color: Theme.of(context).textTheme.titleSmall!.color),
                                      2.width,
                                      PriceWidget(price: product[i].regularPrice.toString(), size: 12, isLineThroughEnabled: true, color: Theme.of(context).textTheme.titleSmall!.color)
                                          .visible(product[i].salePrice.toString().isNotEmpty),
                                    ],
                                  )
                                : PriceWidget(price: double.parse(product[i].price.toString()).toStringAsFixed(2), size: 18),
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
                            ).onTap(() async {
                              log("hello:${product[i].id!}");
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
                        ),
                      ),
                      commonCacheImageWidget(product[i].images![0].src, height: 105, width: 85, fit: BoxFit.cover).cornerRadiusWithClipRRect(8),
                    ],
                  ).paddingAll(8),
                );
              },
            )
          ],
        ),
      );
    }

    final videoSlider = productDetailNew != null
        ? Column(
            children: [
              Container(
                height: 450,
                width: MediaQuery.of(context).size.width,
                decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
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
                height: 450,
                width: MediaQuery.of(context).size.width,
                decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
                child: PageView(
                  children: productImg1.map((i) {
                    return commonCacheImageWidget(
                      i.validate(),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ).cornerRadiusWithClipRRectOnly(topLeft: 20, topRight: 20).onTap(() {
                      ZoomImageScreen(mImgList: productDetailNew!.images).launch(context);
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  wishListStore.isItemInWishlist(productDetailNew!.id!) == false ? Icon(Icons.favorite_border, color: primaryColor) : Icon(Icons.favorite, color: primaryColor),
                  4.width,
                  Text(wishListStore.isItemInWishlist(productDetailNew!.id!) == false ? appLocalization!.translate('lbl_wish_list')!.toUpperCase() : appLocalization!.translate('lbl_wishlisted')!.toUpperCase(),
                      textAlign: TextAlign.center, style: boldTextStyle(color: primaryColor, wordSpacing: 2, size: 14)),
                ],
              ),
            ),
          ).visible(productDetailNew!.isAddedWishList != null)
        : SizedBox();

    final mCartData = productDetailNew != null
        ? Container(
            padding: EdgeInsets.all(10),
            decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(8), backgroundColor: productDetailNew!.inStock! ? context.primaryColor : textSecondaryColorGlobal.withOpacity(0.3)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, color: white),
                4.width,
                Text(
                  productDetailNew!.inStock! == true
                      ? productDetailNew!.type! == 'external'
                          ? productDetailNew!.buttonText!
                          : cartStore.isItemInCart(productDetailNew!.id.validate())
                              ? appLocalization!.translate('lbl_remove_cart')!.toUpperCase()
                              : appLocalization!.translate('lbl_add_to_cart')!.toUpperCase()
                      : appLocalization!.translate('lbl_sold_out')!.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: boldTextStyle(color: white, wordSpacing: 1, size: 14),
                ),
              ],
            ),
          ).onTap(() {
            appStore.setLoading(true);
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
          })
        : SizedBox();

    Widget mGetPrice() {
      final mPrice = productDetailNew != null
          ? productDetailNew!.onSale == true
              ? Row(
                  children: [
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
                    mDiscount().visible(productDetailNew!.salePrice.toString().isNotEmpty && productDetailNew!.onSale == true)
                  ],
                )
              : Row(
                  children: [
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
              children: [Text(appLocalization!.translate('lbl_you_saved')! + " ", style: secondaryTextStyle()), PriceWidget(price: value.toStringAsFixed(2), size: 18, color: Theme.of(context).textTheme.titleMedium!.color)],
            ).paddingOnly(left: 12, right: 8);
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

    final RenderObjectWidget body;
    if (productDetailNew != null) {
      body = Stack(
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
                Container(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  decoration: boxDecorationRoundedWithShadow(0, backgroundColor: context.cardColor),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(productDetailNew!.name!, style: boldTextStyle(size: 18)).expand(),
                          if (productDetailNew!.onSale == true)
                            FittedBox(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(4))),
                                child: Text(appLocalization!.translate('lbl_sale')!, style: boldTextStyle(color: Colors.white, size: 12)),
                              ).cornerRadiusWithClipRRectOnly(topLeft: 0, bottomLeft: 4),
                            ),
                        ],
                      ).paddingOnly(left: 12, right: 12, bottom: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (productDetailNew!.type != 'grouped') mGetPrice(),
                          FittedBox(
                            child: Container(
                              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(4), backgroundColor: Theme.of(context).cardTheme.color!, border: Border.all(color: view_color)),
                              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                              margin: EdgeInsets.only(right: 12),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: rating.toString() + " ", style: secondaryTextStyle(size: 10)),
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
                      ).paddingOnly(left: 12, bottom: 8).visible(!productDetailNew!.type!.contains("grouped")),
                      if (productDetailNew!.type != 'grouped') mSavePrice(),
                    ],
                  ),
                ),
                if (productDetailNew!.store != null)
                  Container(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    decoration: boxDecorationRoundedWithShadow(0, backgroundColor: context.cardColor),
                    child: Row(
                      children: [
                        Text(appLocalization!.translate('lbl_trade_in')!, style: primaryTextStyle()).visible(productDetailNew!.store!.shopName.validate().isNotEmpty),
                        8.width,
                        Text(productDetailNew!.store!.shopName != null ? productDetailNew!.store!.shopName! : '', style: boldTextStyle(color: primaryColor)).expand(),
                        Icon(Icons.arrow_forward_ios_outlined, color: context.iconColor, size: 16)
                      ],
                    ).paddingOnly(left: 12, right: 12).onTap(() {
                      VendorProfileScreen(mVendorId: productDetailNew!.store!.id).launch(context);
                    }),
                  ).visible(productDetailNew!.store!.shopName.validate().isNotEmpty),
                if (productDetailNew!.onSale!) productDetailNew!.dateOnSaleFrom!.isNotEmpty ? mSpecialPrice(appLocalization!.translate('lbl_special_msg')) : SizedBox(),
                Column(
                  children: [
                    if (productDetailNew!.type == "variable" || productDetailNew!.type == "variation")
                      Container(
                        width: context.width(),
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        decoration: boxDecorationRoundedWithShadow(0, backgroundColor: context.cardColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(appLocalization!.translate('lbl_Available')!, style: boldTextStyle()).paddingOnly(left: 12, right: 12, top: 8),
                            Wrap(
                              children: mProductOptions.map((e) {
                                int index = mProductOptions.indexOf(e);
                                return Container(
                                  margin: EdgeInsets.all(4),
                                  padding: EdgeInsets.all(8),
                                  decoration: boxDecorationWithRoundedCorners(backgroundColor: selectedOptionAvailableIn == index ? bgCardColor : context.cardColor, border: Border.all(width: 0.1, color: context.iconColor)),
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
                            ).paddingOnly(top: 8, left: 4)
                          ],
                        ),
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
                  ],
                ),
                Container(
                        width: context.width(),
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        decoration: boxDecorationRoundedWithShadow(0, backgroundColor: context.cardColor),
                        child: mUpcomingSale())
                    .visible(productDetailNew!.onSale! && productDetailNew!.dateOnSaleFrom != ""),
                Container(
                  width: context.width(),
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  decoration: boxDecorationRoundedWithShadow(0, backgroundColor: context.cardColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appLocalization!.translate('lbl_product_details')!, style: boldTextStyle()).paddingOnly(left: 12, right: 12, top: 8).visible(productDetailNew!.description!.isNotEmpty),
                      HtmlWidget(postContent: productDetailNew!.description.toString().trim()).paddingOnly(right: 6, left: 6).visible(productDetailNew!.description!.isNotEmpty),
                      if (productDetailNew!.attributes != null) mSetAttribute().paddingBottom(8).visible(productDetailNew!.attributes!.isNotEmpty),
                    ],
                  ),
                ).visible(productDetailNew!.description!.isNotEmpty),
                Container(
                  width: context.width(),
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  decoration: boxDecorationRoundedWithShadow(0, backgroundColor: context.cardColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appLocalization.translate('lbl_short_description')!, style: boldTextStyle()).paddingOnly(top: 8, left: 12, right: 12).visible(productDetailNew!.shortDescription.toString().isNotEmpty),
                      HtmlWidget(postContent: productDetailNew!.shortDescription).paddingOnly(left: 6, right: 10).visible(productDetailNew!.shortDescription.toString().isNotEmpty),
                    ],
                  ),
                ).visible(productDetailNew!.shortDescription.toString().isNotEmpty),
                if (productDetailNew!.categories != null)
                  Container(
                    width: context.width(),
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    decoration: boxDecorationRoundedWithShadow(0, backgroundColor: context.cardColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appLocalization.translate('lbl_category')!, style: boldTextStyle()).paddingOnly(left: 12, right: 12, top: 8),
                        4.height,
                        Wrap(
                            children: productDetailNew!.categories!.map(
                          (e) {
                            return Container(
                              margin: EdgeInsets.only(left: 10, top: 8, bottom: 8),
                              padding: EdgeInsets.only(right: 8, left: 8, bottom: 8, top: 8),
                              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, border: Border.all(width: 0.1, color: context.iconColor)),
                              child: Text(e.name!, style: secondaryTextStyle()),
                            ).onTap(() {
                              ViewAllScreen(e.name, isCategory: true, categoryId: e.id).launch(context);
                            });
                          },
                        ).toList()),
                      ],
                    ),
                  ).visible(productDetailNew!.categories!.isNotEmpty),
                if (productDetailNew!.upSellIds != null) upSaleProductList(productDetailNew!.upSellId!).visible(productDetailNew!.upSellId!.isNotEmpty),
                _review(),
              ],
            ),
          ),
        ],
      );
    } else {
      body = SizedBox();
    }

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: white),
            onPressed: () {
              Navigator.pop(context);
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
          children: [Expanded(child: mFavourite, flex: 1), 16.width, Expanded(child: mCartData, flex: 1)],
        ).paddingOnly(top: 8, bottom: 8, right: 16, left: 16).visible(!mIsGroupedProduct),
      ).visible(productDetailNew != null),
    );
  }
}
