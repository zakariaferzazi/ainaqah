import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '/../main.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppBarWidget.dart';
import '/../screen/DashBoardScreen.dart';
import '/../screen/MobileNumberSignInScreen.dart';
import '/../screen/SignUpScreen.dart';
import '/../service/LoginService.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../AppLocalizations.dart';

class SignInScreen extends StatefulWidget {
  static String tag = '/SignInScreen';

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //bool isLoading = false;

  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  init() async {
    // if (Platform.isIOS) {
    //   TheAppleSignIn.onCredentialRevoked!.listen((_) {
    //     print("Credentials revoked");
    //   });
    // }
    if (!getBoolAsync(IS_SOCIAL_LOGIN) && getBoolAsync(IS_REMEMBERED)) {
      usernameCont.text = getStringAsync(USER_EMAIL);
      passwordCont.text = getStringAsync(PASSWORD);
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    void signInApi(req) async {

      appStore.setLoading(true);
      await login(req).then((res) async {
        if (!mounted) return;
        await setValue(USER_ID, res['user_id']);
        await setValue(FIRST_NAME, res['first_name']);
        await setValue(LAST_NAME, res['last_name']);
        await setValue(USER_EMAIL, res['user_email']);
        await setValue(USERNAME, res['user_nicename']);
        await setValue(TOKEN, res['token']);
        await setValue(AVATAR, res['avatar']);
        if (res['profile_image'] != null) {
          await setValue(PROFILE_IMAGE, res['profile_image']);
        }
        await setValue(USER_DISPLAY_NAME, res['user_display_name']);
        await setValue(BILLING, jsonEncode(res['billing']));
        await setValue(SHIPPING, jsonEncode(res['shipping']));

        await setValue(IS_LOGGED_IN, true);
        await setValue(PASSWORD, passwordCont.text.toString());
        //  await saveProfileImage(playerRequest).then((res) async {});
        await setValue(IS_REMEMBERED, getBoolAsync(IS_REMEMBERED));
        appStore.setLoading(false);

        appStore.setBottomNavigationIndex(0);
        DashBoardScreen().launch(context, isNewTask: true);
      }).catchError((error) {
        print("Error" + error.toString());
        toast(error.toString());
        appStore.setLoading(false);
      });
    }

    void socialLogin(req) async {
      appStore.setLoading(true);
      await socialLoginApi(req).then((res) async {
        if (!mounted) return;
        await getCustomer(res['user_id']).then((response) async {
          if (!mounted) return;
          await setValue(IS_SOCIAL_LOGIN, true);
          await setValue(AVATAR, req['photoURL']);
          await setValue(USER_ID, res['user_id']);
          await setValue(FIRST_NAME, res['first_name']);
          await setValue(LAST_NAME, res['last_name']);
          await setValue(USER_EMAIL, res['user_email']);
          await setValue(USERNAME, res['user_nicename']);
          await setValue(TOKEN, res['token']);
          await setValue(USER_DISPLAY_NAME, res['user_display_name']);
          await setValue(BILLING, jsonEncode(res['billing']));
          await setValue(SHIPPING, jsonEncode(res['shipping']));
          await setValue(IS_LOGGED_IN, true);

          appStore.setLoading(false);
          DashBoardScreen().launch(context, isNewTask: true);
        }).catchError((error) {
          appStore.setLoading(false);
          toast(error.toString());
        });
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
    }

    void onGoogleSignInTap() async {
      var service = LoginService();
      await service.signInWithGoogle().then((res) {
        socialLogin(res);
      }).catchError((e) {
        toast(e.toString());
      });
    }

    saveAppleDataWithoutEmail() async {
      await getSharedPref().then((pref) {
        log(getStringAsync('appleEmail'));
        log(getStringAsync('appleGivenName'));
        log(getStringAsync('appleFamilyName'));

        var req = {
          'email': getStringAsync('appleEmail'),
          'firstName': getStringAsync('appleGivenName'),
          'lastName': getStringAsync('appleFamilyName'),
          'photoURL': '',
          'accessToken': '12345678',
          'loginType': 'apple',
        };
        socialLogin(req);
      });
    }

    saveAppleData(result) async {
      await setValue('appleEmail', result.credential.email);
      await setValue('appleGivenName', result.credential.fullName.givenName);
      await setValue('appleFamilyName', result.credential.fullName.familyName);

      log('Email:- ${getStringAsync('appleEmail')}');
      log('appleGivenName:- ${getStringAsync('appleGivenName')}');
      log('appleFamilyName:- ${getStringAsync('appleFamilyName')}');

      var req = {
        'email': result.credential.email,
        'firstName': result.credential.fullName.givenName,
        'lastName': result.credential.fullName.familyName,
        'photoURL': '',
        'accessToken': '12345678',
        'loginType': 'apple',
      };
      socialLogin(req);
    }

    // void appleLogIn() async {
    //   if (await TheAppleSignIn.isAvailable()) {
    //     final AuthorizationResult result = await TheAppleSignIn.performRequests([
    //       AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    //     ]);
    //     switch (result.status) {
    //       case AuthorizationStatus.authorized:
    //         log("Result: $result"); //All the required credentials
    //         if (result.credential!.email == null) {
    //           saveAppleDataWithoutEmail();
    //         } else {
    //           saveAppleData(result);
    //         }
    //         break;
    //       case AuthorizationStatus.error:
    //         log("Sign in failed: ${result.error!.localizedDescription}");
    //         break;
    //       case AuthorizationStatus.cancelled:
    //         log('User cancelled');
    //         break;
    //     }
    //   } else {
    //     toast('Apple SignIn is not available for your device');
    //   }
    // }

    Widget socialButtons = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GoogleLogoWidget(size: 28).onTap(() {
          onGoogleSignInTap();
        }).visible(enableSignWithGoogle == true),
        8.width,
        IconButton(
          onPressed: () {
            MobileNumberSignInScreen().launch(context);
          },
          icon: Icon(MaterialIcons.phone_android, size: 36),
        ).visible(enableSignWithOtp == true),
        8.width,
        // IconButton(
        //   onPressed: () {
        //     // appleLogIn();
        //   },
        //   icon: Icon(Ionicons.ios_logo_apple, size: 36),
        // ).visible(Platform.isIOS && enableSignWithApple == true),
      ],
    );

    return Scaffold(
      appBar: mTop(context, "", showBack: true) as PreferredSizeWidget?,
      bottomNavigationBar: RichTextWidget(
        textAlign: TextAlign.center,
        list: [
          TextSpan(text: appLocalization.translate('lbl_dont_t_have_an_account'), style: primaryTextStyle(size: 14)),
          TextSpan(text: "  "),
          TextSpan(text: appLocalization.translate('lbl_sign_up_link')!, style: primaryTextStyle(color: primaryColor)),
        ],
      ).onTap(() {
        SignUpScreen().launch(context);
      }).paddingAll(16),
      body: BodyCornerWidget(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    50.height,
                    Text(appLocalization.translate('lbl_welcome')!, style: boldTextStyle(color: primaryColor, size: 26)),
                    Text(appLocalization.translate('lbl_back')!, style: primaryTextStyle(color: primaryColor, size: 26)),
                    24.height,
                    EditText(
                      hintText: appLocalization.translate('hint_Username'),
                      isPassword: false,
                      isSecure: false,
                      mController: usernameCont,
                      validator: (v) {
                        if (v.trim().isEmpty) return appLocalization.translate('error_username_require');
                        return null;
                      },
                    ),
                    16.height,
                    EditText(
                      hintText: appLocalization.translate('hint_password'),
                      isPassword: true,
                      mController: passwordCont,
                      isSecure: true,
                      validator: (v) {
                        if (v.trim().isEmpty) return appLocalization.translate('error_pwd_require');
                        return null;
                      },
                    ),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: getBoolAsync(IS_REMEMBERED, defaultValue: false),
                              checkColor: white,
                              activeColor: primaryColor,
                              onChanged: (v) async {
                                log(v);
                                await setValue(IS_REMEMBERED, v);
                                setState(() {});
                              },
                            ),
                            TextButton(
                              onPressed: () async {
                                await setValue(IS_REMEMBERED, !getBoolAsync(IS_REMEMBERED));
                                setState(() {});
                              },
                              child: Text(appLocalization.translate('lbl_remember_me')!, style: secondaryTextStyle()),
                            ),
                          ],
                        ).expand(),
                        TextButton(
                          onPressed: () async {
                            showDialog(context: context, builder: (BuildContext context) => CustomDialog());
                          },
                          child: Text(appLocalization.translate('lbl_forgot_password')!, style: secondaryTextStyle(color: primaryColor)),
                        ),
                      ],
                    ),
                    20.height,
                    AppButton(
                      width: context.width(),
                      textStyle: primaryTextStyle(color: white),
                      text: appLocalization.translate('lbl_sign_in'),
                      onTap: () {
                        hideKeyboard(context);
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          var request = {"username": "${usernameCont.text}", "password": "${passwordCont.text}"};
                          appStore.setLoading(true);
                          signInApi(request);
                        }
                      },
                      color: primaryColor,
                    ),
                    20.height,
                    socialButtons.visible(enableSocialSign == true)
                  ],
                ),
              ),
            ),
            Observer(builder: (context) => mProgress().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  var email = TextEditingController();

  //bool mIsLoading = false;

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    forgotPwdApi() async {
      hideKeyboard(context);
      var request = {'email': email.text};
      forgetPassword(request).then((res) {
        appStore.setLoading(false);
        toast('Successfully Send Email');
        finish(context);
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
      setState(() {});
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: radius(10)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), backgroundColor: Theme.of(context).cardTheme.color!),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(appLocalization.translate('lbl_forgot_password')!, style: boldTextStyle(color: primaryColor, size: 24)).paddingOnly(left: 16, right: 16, top: 16),
                  16.height,
                  EditText(
                      hintText: appLocalization.translate('hint_enter_your_email_id'),
                      isPassword: false,
                      mController: email,
                      validator: (String? v) {
                        if (v!.trim().isEmpty) return appLocalization.translate('error_email_required');
                        if (!v.trim().validateEmail()) return appLocalization.translate('error_wrong_email');
                        return null;
                      }).paddingOnly(left: 16, right: 16, bottom: 8),
                  AppButton(
                      width: context.width(),
                      text: appLocalization.translate('lbl_submit'),
                      textStyle: primaryTextStyle(color: white),
                      color: primaryColor,
                      onTap: () {
                        if (!accessAllowed) {
                          return;
                        }
                        if (email.text.isEmpty) {
                          toast(appLocalization.translate('hint_Email')! + (' ') + appLocalization.translate('error_field_required')!);
                        } else if (!email.text.validateEmail()) {
                          toast(appLocalization.translate('error_wrong_email'));
                        } else {
                          appStore.setLoading(true);
                          forgotPwdApi();
                        }
                      }).paddingAll(16)
                ],
              ),
              Observer(builder: (context) => mProgress().center().visible(appStore.isLoading)),
            ],
          ),
        ),
      ),
    );
  }
}
