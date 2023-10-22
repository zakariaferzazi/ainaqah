import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import '/../main.dart';
import '/../models/ProductReviewModel.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppBarWidget.dart';
import '/../screen/SignInScreen.dart';
import '/../utils/AdmobUtils.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import '/../utils/SharedPref.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';

class ReviewScreen extends StatefulWidget {
  static String tag = '/ReviewScreen';
  final mProductId;

  ReviewScreen({Key? key, this.mProductId}) : super(key: key);

  @override
  ReviewScreenState createState() => ReviewScreenState();
}

class ReviewScreenState extends State<ReviewScreen> {
  List<ProductReviewModel> mReviewModel = [];
  TextEditingController reviewCont = TextEditingController();

  String mErrorMsg = '';
  String mUserEmail = '';

  double avgRating = 0.0;
  double ratings = 0.0;
  double isUpdate = 0.0;

  bool mIsLoggedIn = false;
  bool mIsGuest = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      fetchData();
      getPrefs();
    });
  }

  void getPrefs() async {
    mIsLoggedIn = await isLoggedIn();
    mIsGuest = await isGuestUser();
    setState(() {});
    if (getBoolAsync(IS_LOGGED_IN)) {
      mUserEmail = getStringAsync(USER_EMAIL);
      log('Email:- $mUserEmail');
    }
  }

  Future fetchData() async {
    appStore.setLoading(true);
    await getProductReviews(widget.mProductId).then((res) {
      if (!mounted) return;
      setState(() {
        appStore.setLoading(false);
        Iterable list = res;
        mReviewModel = list.map((model) => ProductReviewModel.fromJson(model)).toList();

        appStore.mIsUserExistInReview = false;
        mReviewModel.forEachIndexed((element, index) {
          if (element.reviewerEmail!.contains(mUserEmail)) {
            appStore.mIsUserExistInReview = true;
          }
        });
      });
    }).catchError((error) {
      mErrorMsg = error.toString();
      appStore.setLoading(false);
    });
  }

  Future postReviewApi(productId, review, rating) async {
    var request = {
      'product_id': productId,
      'reviewer': getStringAsync(FIRST_NAME) + " " + getStringAsync(LAST_NAME),
      'reviewer_email': getStringAsync(USER_EMAIL),
      'review': review,
      'rating': rating,
    };
    appStore.setLoading(true);
    postReview(request).then((res) {
      if (!mounted) return;
      setState(() {
        appStore.setLoading(false);
        appStore.mIsUserExistInReview = false;
        mReviewModel.clear();
      });
      fetchData();
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error);
    });
  }

  Future updateReviewApi(productId, review, rating, reviewId) async {
    var request = {
      'product_id': productId,
      'reviewer': getStringAsync(USERNAME),
      'reviewer_email': getStringAsync(USER_EMAIL),
      'review': review,
      'rating': rating,
    };
    appStore.setLoading(true);
    updateReview(reviewId, request).then((res) {
      if (!mounted) return;
      setState(() {
        appStore.setLoading(false);
        mReviewModel.clear(); // T
        fetchData();
      });
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error);
    });
  }

  Future deleteReviewApi(reviewId) async {
    if (!accessAllowed) {
      toast(demoPurposeMsg);
      return;
    }
    appStore.setLoading(true);
    deleteReview(reviewId).then((res) {
      if (!mounted) return;
      appStore.mIsUserExistInReview = true;
      appStore.setLoading(false);
      setState(() {
        fetchData();
        toast('Remove Reviewed');
      });
    }).catchError((error) {
      appStore.setLoading(false);
      setState(() {
        fetchData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    void onUpdateSubmit(review, rating, reviewId) async {
      if (accessAllowed) {
        updateReviewApi(widget.mProductId, review, rating, reviewId);
      } else {
        toast(demoPurposeMsg);
      }
    }

    Widget mDialog() {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), backgroundColor: Theme.of(context).cardTheme.color!),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(appLocalization.translate('hint_review')!.toUpperCase(), style: boldTextStyle(size: 16, color: Theme.of(context).textTheme.titleMedium!.color)),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color, size: 22),
                  )
                ],
              ).paddingOnly(left: 16),
              Divider(),
              TextFormField(
                controller: reviewCont,
                maxLines: 8,
                cursorColor: primaryColor!,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                style: primaryTextStyle(color: Theme.of(context).textTheme.titleMedium!.color),
                decoration: InputDecoration(
                  hintText: appLocalization.translate('hint_review'),
                  hintStyle: primaryTextStyle(color: Theme.of(context).textTheme.titleMedium!.color),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.titleMedium!.color!)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.titleMedium!.color!)),
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.titleMedium!.color!)),
                ),
              ).paddingOnly(
                left: 16,
                right: 16,
              ),
              20.height,
              RatingBar(
                initialRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (rating) {
                  ratings = rating;
                },
                ratingWidget: RatingWidget(
                  full: Icon(Icons.star, color: Colors.amber),
                  empty: Icon(Icons.star_outline_outlined, color: Colors.amber),
                  half: Icon(Icons.star, color: Colors.amber),
                ),
              ).center(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: AppButton(
                  width: context.width(),
                  text: appLocalization.translate('lbl_submit'),
                  textStyle: primaryTextStyle(color: white),
                  color: primaryColor,
                  onTap: () {
                    if (!accessAllowed) {
                      toast("Sorry");
                      return;
                    }
                    setState(() {
                      if (ratings == 0) {
                        toast('Please Rate');
                      } else if (reviewCont.text.isEmpty) {
                        toast('Please Review');
                      } else {
                        appStore.setLoading(true);
                        if (accessAllowed) {
                          postReviewApi(widget.mProductId, reviewCont.text, ratings);
                          Navigator.pop(context);
                        } else {
                          toast(demoPurposeMsg);
                        }
                      }
                    });
                  },
                ),
              ).paddingAll(16),
            ],
          ),
        ),
      );
    }

    Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        16.height,
        Observer(
          builder: (_) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(appLocalization.translate("lbl_customer_review")!, style: boldTextStyle()).center(),
              GestureDetector(
                onTap: () async {
                  if (mIsGuest == true) {
                    toast(appLocalization.translate('guest_user_review_msg')!);
                  } else {
                    await checkLogin(context).then((value) {
                      if (value)
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            shape: RoundedRectangleBorder(borderRadius: radius(10)),
                            elevation: 0.0,
                            backgroundColor: Colors.transparent,
                            child: mDialog(),
                          ),
                        );
                    });
                  }
                },
                child: Container(
                  decoration: boxDecorationWithRoundedCorners(border: Border.all(color: primaryColor!), borderRadius: radius(4), backgroundColor: Theme.of(context).cardTheme.color!),
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Text(appLocalization.translate('lbl_rate_now')!, style: primaryTextStyle(color: primaryColor)),
                ),
              ).visible(!appStore.mIsUserExistInReview)
            ],
          ),
        ),
        20.height,
      ],
    ).paddingOnly(left: 16, right: 16);

    Widget mReviewListView = ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(thickness: 6, color: Theme.of(context).textTheme.headlineMedium!.color);
        },
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        reverse: true,
        itemCount: mReviewModel.length,
        itemBuilder: (context, index) {
          return Container(
            width: context.width(),
            margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
                          decoration: BoxDecoration(
                              color: mReviewModel[index].rating == 1
                                  ? redColor
                                  : mReviewModel[index].rating == 2
                                      ? yellowColor
                                      : mReviewModel[index].rating == 3
                                          ? yellowColor
                                          : Color(0xFF66953A),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(mReviewModel[index].rating.toString(), style: primaryTextStyle(color: whiteColor, size: 14)),
                              4.width,
                              Icon(Icons.star_border, size: 16, color: whiteColor),
                            ],
                          ),
                        ),
                        8.width,
                        Text(mReviewModel[index].reviewer!, style: boldTextStyle()),
                        Container(height: 10, color: Theme.of(context).textTheme.titleMedium!.color, width: 2, margin: EdgeInsets.only(left: 8, right: 8)),
                        Text(reviewConvertDate(mReviewModel[index].dateCreated), style: secondaryTextStyle()).expand(),
                      ],
                    ).expand(),
                    mUserEmail == mReviewModel[index].reviewerEmail
                        ? PopupMenuButton<int>(
                            itemBuilder: (context) => [
                              PopupMenuItem(value: 1, child: Text(appLocalization.translate("lbl_update")!)),
                              PopupMenuItem(value: 2, child: Text(appLocalization.translate("lbl_delete")!)),
                            ],
                            initialValue: 0,
                            onSelected: (value) async {
                              reviewCont.text = parseHtmlString(mReviewModel[index].review);
                              ratings = mReviewModel[index].rating!.toDouble();
                              if (value == 1) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: radius(10)),
                                    elevation: 0.0,
                                    backgroundColor: Theme.of(context).cardTheme.color,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), backgroundColor: Theme.of(context).cardTheme.color!),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(appLocalization.translate('hint_review')!, style: boldTextStyle(color: colorAccent, size: 16)),
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, true);
                                                  },
                                                  icon: Icon(Icons.close, color: colorAccent, size: 18),
                                                )
                                              ],
                                            ).paddingOnly(left: 16),
                                            Divider(),
                                            TextFormField(
                                              controller: reviewCont,
                                              maxLines: 5,
                                              minLines: 2,
                                              decoration: InputDecoration(hintText: appLocalization.translate('hint_review')!),
                                            ).paddingOnly(left: 16, right: 16),
                                            20.height,
                                            RatingBar(
                                              initialRating: mReviewModel[index].rating!.toDouble(),
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                              ratingWidget: RatingWidget(
                                                full: Icon(Icons.star, color: Colors.amber),
                                                empty: Icon(Icons.star_outline_outlined, color: Colors.amber),
                                                half: Icon(Icons.star, color: Colors.amber),
                                              ),
                                              onRatingUpdate: (rating) {
                                                ratings = rating;
                                              },
                                            ).paddingOnly(left: 16, right: 16),
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: AppButton(
                                                width: context.width(),
                                                text: appLocalization.translate('lbl_submit'),
                                                textStyle: primaryTextStyle(color: white),
                                                color: primaryColor,
                                                onTap: () {
                                                  if (!accessAllowed) {
                                                    toast("Sorry");
                                                    return;
                                                  }
                                                  setState(() {
                                                    if (!accessAllowed) {
                                                      toast("Sorry");
                                                      return;
                                                    }
                                                    if (ratings == 0) {
                                                      toast('Please Rate');
                                                    } else if (reviewCont.text.isEmpty) {
                                                      toast('Please Review');
                                                    } else {
                                                      onUpdateSubmit(reviewCont.text.toString(), ratings, mReviewModel[index].id);
                                                      finish(context);
                                                    }
                                                  });
                                                },
                                              ),
                                            ).paddingAll(16),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                ConfirmAction? res =
                                    await showConfirmDialogs(context, appLocalization.translate("msg_remove"), appLocalization.translate("lbl_yes"), appLocalization.translate("lbl_cancel"));
                                if (res == ConfirmAction.ACCEPT) {
                                  reviewCont.clear();
                                  setState(() {
                                    appStore.setLoading(true);
                                  });
                                  deleteReviewApi(mReviewModel[index].id);
                                }
                              }
                            },
                          )
                        : Container(),
                  ],
                ),
                4.height,
                Text(parseHtmlString(mReviewModel[index].review), style: primaryTextStyle()),
              ],
            ),
          );
        });

    return WillPopScope(
      onWillPop: () async {
        finish(context, true);
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: mTop(context, appLocalization.translate('lbl_reviews'), showBack: true) as PreferredSizeWidget?,
        // bottomNavigationBar: isMobile
        //     ? Container(
        //         height: 60,
        //         child: AdWidget(
        //           ad: BannerAd(
        //             adUnitId:  getBannerAdUnitId()! ,
        //             size: AdSize.banner,
        //             request: AdRequest(),
        //             listener: BannerAdListener(),
        //           )..load(),
        //         ),
        //       ).visible(enableAds == true)
        //     : SizedBox(),
        body: BodyCornerWidget(
          child: Stack(
            children: <Widget>[
              mReviewModel.isNotEmpty
                  ? SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          body,
                          mReviewListView,
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(MaterialCommunityIcons.emoticon_cry_outline, size: 120, color: context.iconColor),
                          20.height,
                          Text(appLocalization.translate('lbl_no_review')!, style: primaryTextStyle(size: 22), textAlign: TextAlign.center).paddingOnly(left: 20, right: 20),
                          30.height,
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: context.width(),
                            child: AppButton(
                                width: context.width(),
                                text: appLocalization.translate('lbl_give_review'),
                                textStyle: primaryTextStyle(color: white),
                                color: primaryColor,
                                onTap: () {
                                  if (mIsLoggedIn == true) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                        shape: RoundedRectangleBorder(borderRadius: radius(10)),
                                        elevation: 0.0,
                                        backgroundColor: Colors.transparent,
                                        child: mDialog(),
                                      ),
                                    );
                                  } else if (mIsLoggedIn == false) {
                                    SignInScreen().launch(context);
                                  } else if (mIsGuest == false) {
                                    toast("Guest user can't authorized for this action");
                                  }
                                }),
                          ),
                        ],
                      ).visible(!appStore.isLoading),
                    ),
              mProgress().center().visible(appStore.isLoading),
              Text(mErrorMsg, style: primaryTextStyle()).visible(!appStore.isLoading).center().visible(mErrorMsg.isNotEmpty),
            ],
          ),
        ),
      ),
    );
  }
}
