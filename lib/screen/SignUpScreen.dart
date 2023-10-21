import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '/../main.dart';
import '/../network/rest_apis.dart';
import '/../screen/DashBoardScreen.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../utils/AppBarWidget.dart';

class SignUpScreen extends StatefulWidget {
  static String tag = '/SignUpScreen';
  final String? userName;

  SignUpScreen({this.userName});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  signUpApi() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      var request = {
        'first_name': fNameCont.text,
        'last_name': lNameCont.text,
        'user_email': emailCont.text,
        'user_type': null,
        'user_login': widget.userName ?? usernameCont.text,
        'user_pass': widget.userName ?? passwordCont.text
      };

      log("Request" + request.toString());
      appStore.setLoading(true);

      createCustomer(request).then((res) async {
        if (!mounted) return;
        if (widget.userName != null) {
          if (widget.userName!.isNotEmpty) {
            var request = {
              "username": widget.userName,
              "password": widget.userName,
            };

            log("Request" + request.toString());
            signInApi(request);
          } else {
            toast('Register Successfully');
            finish(context);
          }
        } else {
          toast('Register Successfully');
          finish(context);
        }

        appStore.setLoading(false);
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString(), print: true);
      });
    }
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

      if (widget.userName!.isNotEmpty) {
        await setValue(IS_SOCIAL_LOGIN, true);
      }
      appStore.setLoading(false);
      DashBoardScreen().launch(context, isNewTask: true);
    }).catchError((error) {
      print("Error" + error.toString());
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: mTop(context, "", showBack: true) as PreferredSizeWidget?,
        bottomNavigationBar: RichTextWidget(
          textAlign: TextAlign.center,
          list: [
            TextSpan(text: appLocalization.translate('lbl_already_have_account'), style: primaryTextStyle(size: 14)),
            TextSpan(text: "  "),
            TextSpan(text: appLocalization.translate('lbl_sign_in')!, style: primaryTextStyle(color: primaryColor))
          ],
        ).onTap(() {
          finish(context);
        }).paddingAll(16),
        body: BodyCornerWidget(
          child: Stack(
            children: <Widget>[
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      50.height,
                      Text(appLocalization.translate('lbl_create_account')!, style: boldTextStyle(color: primaryColor, size: 26)),
                      24.height,
                      Row(
                        children: [
                          Expanded(
                            child: EditText(
                                hintText: appLocalization.translate('hint_first_name'),
                                isPassword: false,
                                mController: fNameCont,
                                validator: (String? v) {
                                  if (v!.trim().isEmpty) return appLocalization.translate('error_first_name_required');
                                  if (!v.trim().isAlpha()) return appLocalization.translate('error_only_alphabet');
                                  return null;
                                }),
                          ),
                          8.width,
                          Expanded(
                            child: EditText(
                                hintText: appLocalization.translate('hint_last_name'),
                                isPassword: false,
                                mController: lNameCont,
                                validator: (String? v) {
                                  if (v!.trim().isEmpty) return appLocalization.translate('error_last_name_required');
                                  if (!v.trim().isAlpha()) return appLocalization.translate('error_only_alphabet');
                                  return null;
                                }),
                          )
                        ],
                      ),
                      16.height,
                      EditText(
                          hintText: appLocalization.translate('lbl_email'),
                          isPassword: false,
                          mController: emailCont,
                          validator: (String? v) {
                            if (v!.trim().isEmpty) return appLocalization.translate('error_email_required');
                            if (!v.trim().validateEmail()) return appLocalization.translate('error_wrong_email');
                            return null;
                          }),
                      16.height,
                      EditText(
                          hintText: appLocalization.translate('hint_Username'),
                          isPassword: false,
                          mController: usernameCont,
                          validator: (v) {
                            if (v.trim().isEmpty) return appLocalization.translate('error_username_require');
                            return null;
                          }).visible(widget.userName.isEmptyOrNull),
                      16.height,
                      EditText(
                          hintText: appLocalization.translate('hint_password'),
                          isPassword: true,
                          isSecure: true,
                          mController: passwordCont,
                          validator: (v) {
                            if (v.trim().isEmpty) return appLocalization.translate('error_pwd_require');
                            return null;
                          }).visible(widget.userName.isEmptyOrNull),
                      16.height.visible(widget.userName.isEmptyOrNull),
                      EditText(
                          hintText: appLocalization.translate('hint_confirm_password'),
                          isPassword: true,
                          isSecure: true,
                          mController: confirmPasswordCont,
                          validator: (v) {
                            if (v.trim().isEmpty) return appLocalization.translate('error_confirm_pwd_require');
                            if (confirmPasswordCont.text != passwordCont.text) return appLocalization.translate('error_pwd_not_match');
                            return null;
                          }).visible(widget.userName.isEmptyOrNull),
                      30.height,
                      AppButton(
                          width: context.width(),
                          text: appLocalization.translate('lbl_sign_up_link'),
                          textStyle: primaryTextStyle(color: white),
                          color: primaryColor,
                          onTap: () {
                            signUpApi();
                          }),
                      16.height
                    ],
                  ),
                ),
              ),
              Observer(builder: (_) => mProgress().center().visible(appStore.isLoading)),
            ],
          ),
        ),
      ),
    );
  }
}
