import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '/../main.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../utils/AppBarWidget.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String tag = '/ChangePasswordScreen';

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController passwordCont = TextEditingController();
  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newPasswordCont = TextEditingController();

  String userName = '';

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  init() async {
    setState(() {
      userName = getStringAsync(USERNAME);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    void changePwdAPI() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        appStore.setLoading(true);

        var request = {'old_password': oldPasswordCont.text, 'new_password': passwordCont.text, 'username': userName};
        changePassword(request).then((res) async {
          appStore.setLoading(false);
          await setValue(PASSWORD, passwordCont.text.trim());
          hideKeyboard(context);
          toast(res["message"]);
          finish(context);
        }).catchError((error) {
          appStore.setLoading(false);
          toast(error.toString());
        });
      } else {
        toast('Enter Valid Password');
      }
    }

    return Scaffold(
      appBar: mTop(context, appLocalization.translate('lbl_change_pwd'), showBack: true) as PreferredSizeWidget?,
      body: Observer(
        builder: (context) => BodyCornerWidget(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      16.height,
                      EditText(
                          hintText: appLocalization.translate('hint_old_password'),
                          isPassword: true,
                          isSecure: true,
                          mController: oldPasswordCont,
                          validator: (v) {
                            if (v.trim().isEmpty) return appLocalization.translate('error_old_pwd_require');
                            return null;
                          }),
                      16.height,
                      EditText(
                          hintText: appLocalization.translate('lbl_new_pwd'),
                          isPassword: true,
                          isSecure: true,
                          mController: newPasswordCont,
                          validator: (v) {
                            if (v.trim().isEmpty) return appLocalization.translate('error_new_pwd_require');
                            return null;
                          }),
                      16.height,
                      EditText(
                          hintText: appLocalization.translate('hint_confirm_password'),
                          isPassword: true,
                          mController: passwordCont,
                          isSecure: true,
                          validator: (v) {
                            if (v.trim().isEmpty) return appLocalization.translate('error_confirm_pwd_require');
                            if (passwordCont.text != newPasswordCont.text) return appLocalization.translate('error_pwd_match');
                            return null;
                          }),
                      16.height,
                      AppButton(
                        width: context.width(),
                        textStyle: primaryTextStyle(color: white),
                        text: appLocalization.translate('lbl_change_now'),
                        onTap: () {
                          hideKeyboard(context);
                          changePwdAPI();
                        },
                        color: primaryColor,
                      )
                    ],
                  ),
                ),
                mProgress().center().visible(appStore.isLoading)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
