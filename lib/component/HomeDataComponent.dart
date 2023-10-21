import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import '/../models/CartModel.dart';
import '/../models/CategoryData.dart';
import '/../models/ProductResponse.dart';
import '/../models/SaleBannerResponse.dart';
import '/../models/SliderModel.dart';
import '/../network/rest_apis.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import '/../utils/SharedPref.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';

List<String?> mSliderImages = [];
List<String?> mSaleBannerImages = [];
List<ProductResponse> mNewestProductModel = [];
List<ProductResponse> mFeaturedProductModel = [];
List<ProductResponse> mDealProductModel = [];
List<ProductResponse> mSellingProductModel = [];
List<ProductResponse> mSaleProductModel = [];
List<ProductResponse> mOfferProductModel = [];
List<ProductResponse> mSuggestedProductModel = [];
List<ProductResponse> mYouMayLikeProductModel = [];
List<VendorResponse> mVendorModel = [];
List<Category> mCategoryModel = [];
List<Widget> data = [];
List<SliderModel> mSliderModel = [];
List<Salebanner> mSaleBanner = [];
List<Widget> pages = [];
CartResponse mCartModel = CartResponse();
List<String?> mQuotes = [];

Random rnd = new Random();

bool isWasConnectionLoss = false;
bool isDone = false;

Future fetchCategoryData() async {
  await getCategories(1, TOTAL_CATEGORY_PER_PAGE).then((res) {
    Iterable mCategory = res;
    mCategoryModel = mCategory.map((model) => Category.fromJson(model)).toList();
  }).catchError((error) {
    log(error);
  });
}

Future fetchDashboardData() async {
  await isNetworkAvailable().then((bool) async {
    if (bool) {
      if (!await isGuestUser() && await isLoggedIn()) {
        // await cartStore.getStoreCartList().then((res) {
        //   mCartModel = CartResponse.fromJson(res);
        //   if (mCartModel.data!.isNotEmpty) {
        //     appStore.setCount(mCartModel.totalQuantity);
        //   }
        // }).catchError((error) {
        //   log(error.toString());
        // });
      }

      await getDashboardApi().then((res) async {
        await setValue(DEFAULT_CURRENCY, parseHtmlString(res['currency_symbol']['currency_symbol']));
        await setValue(CURRENCY_CODE, res['currency_symbol']['currency']);
        await setValue(DASHBOARD_DATA, jsonEncode(res));
        setProductData(res);
        if (res['social_link'] != null) {
          await setValue(WHATSAPP, res['social_link']['whatsapp']);
          await setValue(FACEBOOK, res['social_link']['facebook']);
          await setValue(TWITTER, res['social_link']['twitter']);
          await setValue(INSTAGRAM, res['social_link']['instagram']);
          await setValue(CONTACT, res['social_link']['contact']);
          await setValue(PRIVACY_POLICY, res['social_link']['privacy_policy']);
          await setValue(TERMS_AND_CONDITIONS, res['social_link']['term_condition']);
          await setValue(COPYRIGHT_TEXT, res['social_link']['copyright_text']);
        }
        await setValue(PAYMENTMETHOD, res['payment_method']);
        await setValue(ENABLECOUPON, res['enable_coupons']);
        await setValue(WALLET, res['is_woo_wallet_active']);
      }).catchError((error) {
        appStore.setLoading(false);
      });
      isDone = true;
    } else {
      toast('You are not connected to Internet');
      appStore.setLoading(false);
    }
  });
}

void setProductData(res) async {
  Iterable newest = res['newest'];
  mNewestProductModel = newest.map((model) => ProductResponse.fromJson(model)).toList();

  Iterable featured = res['featured'];
  mFeaturedProductModel = featured.map((model) => ProductResponse.fromJson(model)).toList();

  Iterable deal = res['deal_of_the_day'];
  mDealProductModel = deal.map((model) => ProductResponse.fromJson(model)).toList();

  Iterable selling = res['best_selling_product'];
  mSellingProductModel = selling.map((model) => ProductResponse.fromJson(model)).toList();

  Iterable sale = res['sale_product'];
  mSaleProductModel = sale.map((model) => ProductResponse.fromJson(model)).toList();

  Iterable offer = res['offer'];
  mOfferProductModel = offer.map((model) => ProductResponse.fromJson(model)).toList();

  Iterable suggested = res['suggested_for_you'];
  mSuggestedProductModel = suggested.map((model) => ProductResponse.fromJson(model)).toList();

  Iterable youMayLike = res['you_may_like'];
  mYouMayLikeProductModel = youMayLike.map((model) => ProductResponse.fromJson(model)).toList();

  if (res['vendors'] != null) {
    Iterable vendorList = res['vendors'];
    mVendorModel = vendorList.map((model) => VendorResponse.fromJson(model)).toList();
  }

  if (res['salebanner'] != null) {
    mSaleBannerImages.clear();
    Iterable bannerList = res['salebanner'];
    mSaleBanner = bannerList.map((model) => Salebanner.fromJson(model)).toList();
    mSaleBanner.forEach((s) => mSaleBannerImages.add(s.image));
  }

  mSliderImages.clear();
  Iterable list = res['banner'];
  mSliderModel = list.map((model) => SliderModel.fromJson(model)).toList();
  log("$mSliderModel");
  mSliderModel.forEach((s) => mSliderImages.add(s.image));
}

List<T?> map<T>(List list, Function handler) {
  List<T?> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

Widget mBottom(BuildContext context) {
  var appLocalization = AppLocalizations.of(context)!;

  mQuotes = [
    appLocalization.translate('msg_quote1'),
    appLocalization.translate('msg_quote2'),
    appLocalization.translate('msg_quote3'),
    appLocalization.translate('msg_quote4'),
    appLocalization.translate('msg_quote5'),
    appLocalization.translate('msg_quote6')
  ];

  return Container(
    color: appStore.isDarkModeOn ? Theme.of(context).dividerColor.withOpacity(0.02) : Theme.of(context).cardTheme.color!.withOpacity(0.5),
    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
    child: Column(
      children: [
        Container(width: 40, color: Theme.of(context).dividerColor, height: 4),
        10.height,
        Text("'" + mQuotes[rnd.nextInt(mQuotes.length)]! + "'", style: secondaryTextStyle(), textAlign: TextAlign.center),
      ],
    ),
  );
}
