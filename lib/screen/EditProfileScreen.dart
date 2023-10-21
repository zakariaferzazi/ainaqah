import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import '/../main.dart';
import '/../models/Countries.dart';
import '/../models/CustomerResponse.dart';
import '/../network/rest_apis.dart';
import '/../utils/AppBarWidget.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Colors.dart';
import '/../utils/Constants.dart';
import '/../utils/AppImages.dart';
import '/../utils/SharedPref.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';

class EditProfileScreen extends StatefulWidget {
  static String tag = '/EditProfileScreen';

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ScrollController _controller = ScrollController();

  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();

  TextEditingController txtBillingFirstName = TextEditingController();
  TextEditingController txtBillingLastName = TextEditingController();
  TextEditingController txtBillingCompanyName = TextEditingController();
  TextEditingController txtBillingAddress1 = TextEditingController();
  TextEditingController txtBillingAddress2 = TextEditingController();
  TextEditingController txtBillingCity = TextEditingController();
  TextEditingController txtBillingPinCode = TextEditingController();
  TextEditingController txtBillingMobile = TextEditingController();
  TextEditingController txtBillingEmail = TextEditingController();

  TextEditingController txtShippingFirstName = TextEditingController();
  TextEditingController txtShippingLastName = TextEditingController();
  TextEditingController txtShippingCompanyName = TextEditingController();
  TextEditingController txtShippingAddress1 = TextEditingController();
  TextEditingController txtShippingAddress2 = TextEditingController();
  TextEditingController txtShippingCity = TextEditingController();
  TextEditingController txtShippingPinCode = TextEditingController();

  bool isCheckBoxSelected = false;

  List<Country> billingCountryList = [];
  List<CountryState> billingStateList = [];
  List<CountryState> shippingStateList = [];
  List<MetaDataResponse>? mUser;

  File? imageFile;

  String avatar = '';
  int? id;

  Country? selectedBillingCountry;
  CountryState? selectedBillingState;
  Country? selectedShippingCountry;
  CountryState? selectedShippingState;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    avatar = getStringAsync(PROFILE_IMAGE);
    if (!await isGuestUser()) {
      getCustomerData();
    } else {
      getCustomerInfo();
    }
    Timer(
      Duration(seconds: 1),
      () => _controller.jumpTo(_controller.position.minScrollExtent),
    );
  }

  Future<void> getCustomerInfo() async {
    appStore.setLoading(true);

    if (getStringAsync(GUEST_USER_DATA).isNotEmpty) {
      CustomerData mUserData = CustomerData.fromJson(jsonDecode(getStringAsync(GUEST_USER_DATA)));
      txtFirstName.text = mUserData.firstName!;
      txtLastName.text = mUserData.lastName!;
      txtEmail.text = mUserData.email;
      txtBillingFirstName.text = mUserData.billing!.firstName!;
      txtBillingLastName.text = mUserData.billing!.lastName!;
      txtBillingAddress1.text = mUserData.billing!.address1!;
      txtBillingAddress2.text = mUserData.billing!.address2!;
      txtBillingCity.text = mUserData.billing!.city!;
      txtBillingPinCode.text = mUserData.billing!.postcode!;
      txtBillingMobile.text = mUserData.billing!.phone!;
      txtBillingEmail.text = mUserData.billing!.email!;
      txtShippingFirstName.text = mUserData.shipping!.firstName!;
      txtShippingLastName.text = mUserData.shipping!.lastName!;
      txtShippingAddress1.text = mUserData.shipping!.address1!;
      txtShippingAddress2.text = mUserData.shipping!.address2!;
      txtShippingCity.text = mUserData.shipping!.city!;
      txtShippingPinCode.text = mUserData.shipping!.postcode!;
      isCheckBoxSelected = false;
      await setValue(FIRST_NAME, mUserData.shipping!.firstName);
      await setValue(LAST_NAME, mUserData.shipping!.lastName);
    }

    await getCountries().then((value) async {
      await setValue(COUNTRIES, jsonEncode(value));
      setCountryStatePrefData(value);
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error);
    });
    setState(() {});
  }

  setCountryStatePrefData(List<dynamic> value) {
    var txtBillingCountry, txtBillingState, txtShippingCountry, txtShippingState;
    if (getStringAsync(GUEST_USER_DATA).isNotEmpty) {
      CustomerData mUserData = CustomerData.fromJson(jsonDecode(getStringAsync(GUEST_USER_DATA)));
      txtBillingCountry = mUserData.billing!.country;
      txtBillingState = mUserData.billing!.state;
      txtShippingCountry = mUserData.shipping!.country;
      txtShippingState = mUserData.shipping!.state;
    }

    Iterable list = value;
    var countries = list.map((model) => Country.fromJson(model)).toList();
    setState(() {
      appStore.setLoading(false);
      billingCountryList.addAll(countries);
      if (billingCountryList.isNotEmpty) {
        selectedBillingCountry = billingCountryList[0];
        selectedShippingCountry = billingCountryList[0];
        if (txtBillingCountry != null || txtShippingCountry != null) {
          billingCountryList.forEach((element) {
            if (txtBillingCountry != null && txtBillingCountry.toString().isNotEmpty && element.code == txtBillingCountry) {
              selectedBillingCountry = element;
            }
            if (txtShippingCountry != null && txtShippingCountry.toString().isNotEmpty && element.code == txtShippingCountry) {
              selectedShippingCountry = element;
            }
          });
        }
        billingStateList.clear();
        shippingStateList.clear();
        billingStateList.addAll(selectedBillingCountry!.states!);
        shippingStateList.addAll(selectedShippingCountry!.states!);
        selectedBillingState = billingStateList.isNotEmpty ? billingStateList[0] : null;
        selectedShippingState = shippingStateList.isNotEmpty ? shippingStateList[0] : null;

        if (txtBillingState != null) {
          billingStateList.forEach((element) {
            if (txtBillingState != null && txtBillingState.toString().isNotEmpty && element.name == txtBillingState) {
              selectedBillingState = element;
            }
          });
        }

        if (txtShippingState != null) {
          shippingStateList.forEach((element) {
            if (txtShippingState != null && txtShippingState.toString().isNotEmpty && element.name == txtShippingState) {
              selectedShippingState = element;
            }
          });
        }
      }
    });
  }

  Future getCustomerData() async {
    id = getIntAsync(USER_ID);

    appStore.setLoading(true);

    await getCustomer(id).then((res) async {
      appStore.setLoading(false);
      if (!mounted) return;
      txtFirstName.text = res['first_name'];
      txtLastName.text = res['last_name'];
      txtEmail.text = res['email'];
      txtBillingFirstName.text = res['billing']['first_name'];
      txtBillingLastName.text = res['billing']['last_name'];
      txtBillingCompanyName.text = res['billing']['company'];
      txtBillingAddress1.text = res['billing']['address_1'];
      txtBillingAddress2.text = res['billing']['address_2'];
      txtBillingCity.text = res['billing']['city'];
      txtBillingPinCode.text = res['billing']['postcode'];

      txtBillingMobile.text = res['billing']['phone'];
      txtBillingEmail.text = res['billing']['email'];

      txtShippingFirstName.text = res['shipping']['first_name'];
      txtShippingLastName.text = res['shipping']['last_name'];
      txtShippingCompanyName.text = res['shipping']['company'];
      txtShippingAddress1.text = res['shipping']['address_1'];
      txtShippingAddress2.text = res['shipping']['address_2'];
      txtShippingCity.text = res['shipping']['city'];
      txtShippingPinCode.text = res['shipping']['postcode'];

      isCheckBoxSelected = false;
      await setValue(FIRST_NAME, res['first_name']);
      await setValue(LAST_NAME, res['last_name']);

      await getCountries().then((value) async {
        await setValue(COUNTRIES, jsonEncode(value));
        setCountryStateData(value, res);
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error);
      });
      setState(() {});
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
      log("Error1: " + error.toString());
    });
  }

  setCountryStateData(List<dynamic> value, res) {
    var txtBillingCountry = res['billing']['country'];
    var txtBillingState = res['billing']['state'];
    var txtShippingCountry = res['shipping']['country'];
    var txtShippingState = res['shipping']['state'];

    Iterable list = value;
    var countries = list.map((model) => Country.fromJson(model)).toList();
    setState(() {
      appStore.setLoading(false);
      billingCountryList.addAll(countries);
      if (billingCountryList.isNotEmpty) {
        selectedBillingCountry = billingCountryList[0];
        selectedShippingCountry = billingCountryList[0];
        if (txtBillingCountry != null || txtShippingCountry != null) {
          billingCountryList.forEach((element) {
            if (txtBillingCountry != null && txtBillingCountry.toString().isNotEmpty && element.code == txtBillingCountry) {
              selectedBillingCountry = element;
            }
            if (txtShippingCountry != null && txtShippingCountry.toString().isNotEmpty && element.code == txtShippingCountry) {
              selectedShippingCountry = element;
            }
          });
        }
        billingStateList.clear();
        shippingStateList.clear();
        billingStateList.addAll(selectedBillingCountry!.states!);
        shippingStateList.addAll(selectedShippingCountry!.states!);
        selectedBillingState = billingStateList.isNotEmpty ? billingStateList[0] : null;
        selectedShippingState = shippingStateList.isNotEmpty ? shippingStateList[0] : null;

        if (txtBillingState != null) {
          billingStateList.forEach((element) {
            if (txtBillingState != null && txtBillingState.toString().isNotEmpty && element.code == txtBillingState) {
              selectedBillingState = element;
            }
          });
        }

        if (txtShippingState != null) {
          shippingStateList.forEach((element) {
            if (txtShippingState != null && txtShippingState.toString().isNotEmpty && element.code == txtShippingState) {
              selectedShippingState = element;
            }
          });
        }
      }
    });
  }

  void fillShipping() {
    if (isCheckBoxSelected) {
      txtShippingFirstName.text = txtBillingFirstName.text;
      txtShippingLastName.text = txtBillingLastName.text;
      txtShippingCompanyName.text = txtBillingCompanyName.text;
      txtShippingAddress1.text = txtBillingAddress1.text;
      txtShippingAddress2.text = txtBillingAddress2.text;
      txtShippingCity.text = txtBillingCity.text;
      txtShippingPinCode.text = txtBillingPinCode.text;
      selectedShippingCountry = selectedBillingCountry;
      shippingStateList.clear();
      shippingStateList.addAll(selectedShippingCountry!.states!);
      selectedShippingState = shippingStateList.isNotEmpty ? selectedBillingState : null;
    } else {
      txtShippingFirstName.text = '';
      txtShippingLastName.text = '';
      txtShippingCompanyName.text = '';
      txtShippingAddress1.text = '';
      txtShippingAddress2.text = '';
      txtShippingCity.text = '';
      txtShippingPinCode.text = '';
    }
    log(txtShippingFirstName.text);

    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    saveUser() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        appStore.setLoading(true);
        hideKeyboard(context);

        var mBilling = Billing();
        mBilling.firstName = txtBillingFirstName.text;
        mBilling.lastName = txtBillingLastName.text;
        mBilling.company = txtBillingCompanyName.text;
        mBilling.address1 = txtBillingAddress1.text;
        mBilling.address2 = txtBillingAddress2.text;
        mBilling.city = txtBillingCity.text;
        mBilling.postcode = txtBillingPinCode.text;
        mBilling.country = selectedBillingCountry != null ? selectedBillingCountry!.code.toString() : "";
        mBilling.state = selectedBillingState != null ? selectedBillingState!.code.toString() : "";
        mBilling.email = txtBillingEmail.text;
        mBilling.phone = txtBillingMobile.text;

        var mShipping = Shipping();
        mShipping.firstName = txtShippingFirstName.text;
        mShipping.lastName = txtShippingLastName.text;
        mShipping.company = txtShippingCompanyName.text;
        mShipping.address1 = txtShippingAddress1.text;
        mShipping.address2 = txtShippingAddress2.text;
        mShipping.city = txtShippingCity.text;
        mShipping.postcode = txtShippingPinCode.text;
        mShipping.country = selectedShippingCountry != null ? selectedShippingCountry!.code.toString() : "";
        mShipping.state = selectedShippingState != null ? selectedShippingState!.code.toString() : "";

        if (await isGuestUser()) {
          appStore.setLoading(false);
          var mCustomer = CustomerData();
          mCustomer.firstName = "Guest";
          mCustomer.email = "Guest@gmail.com";
          mCustomer.lastName = "Guest";
          mCustomer.billing = mBilling;
          mCustomer.shipping = mShipping;
          await removeKey(GUEST_USER_DATA);
          await setValue(GUEST_USER_DATA, jsonEncode(mCustomer));
          await removeKey(SHIPPING);
          await setValue(BILLING, jsonEncode(mBilling));
          await setValue(SHIPPING, jsonEncode(mShipping));
          toast(appLocalization.translate("toast_txt_profile_saved"));
          finish(context, true);
        } else {
          var request = {
            'email': txtEmail.text,
            'first_name': txtFirstName.text,
            'last_name': txtLastName.text,
            'billing': mBilling,
            'shipping': mShipping,
          };

          await updateCustomer(id, request).then((res) async {
            if (!mounted) return;
            appStore.setLoading(false);

            await setValue(FIRST_NAME, txtFirstName.text);
            await setValue(LAST_NAME, txtLastName.text);
            await setValue(USER_EMAIL, txtEmail.text);
            log("FIRST_NAME:" + FIRST_NAME);
            log("LAST_NAME:" + LAST_NAME);
            log("USER_EMAIL:" + USER_EMAIL);

            await setValue(BILLING, jsonEncode(mBilling));
            await setValue(SHIPPING, jsonEncode(mShipping));
            toast(appLocalization.translate("toast_txt_profile_saved"), print: true);
            finish(context, true);
          }).catchError((error) {
            toast(error.toString(), print: true);
            appStore.setLoading(false);
          });
        }
      }
    }

    Future<void> uploadImg() async {
      if (imageFile != null) {
        ConfirmAction? res = await showConfirmDialogs(
          context,
          appLocalization.translate("msg_image_confirmation"),
          appLocalization.translate("lbl_yes"),
          appLocalization.translate("lbl_no"),
        );

        if (res == ConfirmAction.ACCEPT) {
          appStore.setLoading(true);
          var base64Image = base64Encode(imageFile!.readAsBytesSync());
          log(base64Image);
          if (!await isGuestUser()) {
            await updateProfile(
              file: imageFile != null ? File(imageFile!.path) : null,
            ).then((res) async {
              if (!mounted) return;
              appStore.setLoading(false);
            }).catchError((error) {
              appStore.setLoading(false);
              toast('Failed');
              toast(error.toString());
            });
          } else {
            appStore.setLoading(false);
            toast("Successfully image set");
          }
        }
      }
    }

    imgFromCamera() async {
      File image = File((await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 100))!.path);

      setState(() {
        imageFile = image;
      });
      uploadImg();
    }

    imgFromGallery() async {
      File image = File((await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50))!.path);

      setState(() {
        imageFile = image;
      });
      uploadImg();
    }

    void showPicker(context) {
      showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).cardTheme.color,
          builder: (BuildContext bc) {
            return Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library, color: Theme.of(context).iconTheme.color),
                      title: Text(appLocalization.translate('lbl_photo_library')!),
                      onTap: () {
                        imgFromGallery();
                        finish(context);
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera, color: Theme.of(context).iconTheme.color),
                    title: Text(appLocalization.translate('lbl_camera')!),
                    onTap: () {
                      imgFromCamera();
                      finish(context);
                    },
                  ),
                ],
              ),
            );
          });
    }

    Widget profileImage = ClipRRect(
      borderRadius: radius(100),
      child: imageFile == null
          ? avatar.isEmpty
              ? Image.asset(User_Profile, width: 100, height: 100, fit: BoxFit.cover)
              : commonCacheImageWidget(avatar, width: 100, height: 100, fit: BoxFit.cover)
          : Image.file(imageFile!, width: 100, height: 100, fit: BoxFit.cover),
    );

    return Scaffold(
      appBar: mTop(context, appLocalization.translate('lbl_edit_profile'), showBack: true) as PreferredSizeWidget?,
      body: BodyCornerWidget(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              controller: _controller,
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        profileImage,
                        15.height,
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, border: Border.all(color: Theme.of(context).textTheme.titleMedium!.color!, width: 1), color: Theme.of(context).scaffoldBackgroundColor),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, size: 20, color: Theme.of(context).textTheme.titleMedium!.color),
                            onPressed: (() {
                              showPicker(context);
                            }),
                          ),
                        ).visible(!getBoolAsync(IS_SOCIAL_LOGIN))
                      ],
                    ).center(),
                    8.height,
                    Text(appLocalization.translate("lbl_add_personal_detail")!, style: boldTextStyle(size: 18)),
                    16.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SimpleEditText(
                            mController: txtFirstName,
                            hintText: appLocalization.translate('hint_first_name'),
                            validator: (String? v) {
                              if (v!.trim().isEmpty) return appLocalization.translate('hint_first_name')! + (' ') + appLocalization.translate('error_field_required')!;
                            },
                          ),
                        ),
                        16.width,
                        Expanded(
                          child: SimpleEditText(
                            mController: txtLastName,
                            hintText: appLocalization.translate('hint_last_name'),
                            validator: (String? v) {
                              if (v!.trim().isEmpty) return appLocalization.translate('hint_last_name')! + (' ') + appLocalization.translate('error_field_required')!;
                            },
                          ),
                        )
                      ],
                    ),
                    SimpleEditText(
                      mController: txtEmail,
                      hintText: appLocalization.translate('lbl_email'),
                      validator: (String? v) {
                        if (v!.trim().isEmpty) return appLocalization.translate('lbl_email')! + (' ') + appLocalization.translate('error_field_required')!;
                        if (!v.trim().validateEmail()) return appLocalization.translate('error_wrong_email');
                      },
                    ),
                    Divider(thickness: 6, color: Theme.of(context).textTheme.headlineMedium!.color),
                    Text(appLocalization.translate("lbl_add_billing_address")!, style: boldTextStyle(size: 18)),
                    16.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SimpleEditText(
                            mController: txtBillingFirstName,
                            hintText: appLocalization.translate('hint_first_name'),
                            validator: (String? v) {
                              if (v!.trim().isEmpty) return appLocalization.translate('hint_first_name')! + (' ') + appLocalization.translate('error_field_required')!;
                              if (!v.trim().isAlpha()) return appLocalization.translate('error_only_alphabet');
                            },
                          ),
                        ),
                        16.width,
                        Expanded(
                          child: SimpleEditText(
                            mController: txtBillingLastName,
                            hintText: appLocalization.translate('hint_last_name'),
                            validator: (String? v) {
                              if (v!.trim().isEmpty) return appLocalization.translate('hint_last_name')! + (' ') + appLocalization.translate('error_field_required')!;
                              if (!v.trim().isAlpha()) return appLocalization.translate('error_only_alphabet');
                            },
                          ),
                        ),
                      ],
                    ),
                    SimpleEditText(
                      mController: txtBillingAddress1,
                      hintText: appLocalization.translate('hint_add1'),
                      validator: (String? v) {
                        if (v!.trim().isEmpty) return appLocalization.translate('hint_add1')! + (' ') + appLocalization.translate('error_field_required')!;
                      },
                    ),
                    SimpleEditText(
                      mController: txtBillingAddress2,
                      hintText: appLocalization.translate('hint_add2'),
                      validator: (String? v) {
                        if (v!.trim().isEmpty) return appLocalization.translate('hint_add2')! + (' ') + appLocalization.translate('error_field_required')!;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SimpleEditText(
                            mController: txtBillingCity,
                            hintText: appLocalization.translate('hint_city'),
                            validator: (String? v) {
                              if (v!.trim().isEmpty) return appLocalization.translate('hint_city')! + (' ') + appLocalization.translate('error_field_required')!;
                            },
                          ),
                        ),
                        16.width,
                        Expanded(
                          child: SimpleEditText(
                            mController: txtBillingPinCode,
                            keyboardType: TextInputType.number,
                            hintText: appLocalization.translate('hint_pin_code'),
                            validator: (String? v) {
                              if (v!.trim().isEmpty) return appLocalization.translate('hint_pin_code')! + (' ') + appLocalization.translate('error_field_required')!;
                              if (!v.trim().isDigit()) return appLocalization.translate('error_only_alphabet');
                            },
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: boxDecorationWithRoundedCorners(border: Border.all(width: 0.2), backgroundColor: context.cardColor),
                          child: DropdownButton(
                            dropdownColor: context.cardColor,
                            value: selectedBillingCountry,
                            isExpanded: true,
                            underline: SizedBox(),
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedBillingCountry = value;
                                billingStateList.clear();
                                billingStateList.addAll(selectedBillingCountry!.states!);
                                selectedBillingState = selectedBillingCountry!.states!.isNotEmpty ? billingStateList[0] : null;
                                if (isCheckBoxSelected) {
                                  selectedShippingCountry = selectedBillingCountry;
                                  shippingStateList.clear();
                                  shippingStateList.addAll(selectedShippingCountry!.states!);
                                  selectedShippingState = selectedShippingCountry!.states!.isNotEmpty ? selectedBillingState : null;
                                }
                              });
                            },
                            items: billingCountryList.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    value.name != null && value.name.toString().isNotEmpty ? value.name : "NA",
                                    style: primaryTextStyle(color: Theme.of(context).textTheme.titleMedium!.color),
                                  ).paddingOnly(left: 16, right: 16, top: 8, bottom: 8),
                                ),
                              );
                            }).toList(),
                          ),
                        ).expand(),
                        16.width,
                        Container(
                          decoration: boxDecorationWithRoundedCorners(border: Border.all(width: 0.2), backgroundColor: context.cardColor),
                          child: selectedBillingState != null
                              ? DropdownButton(
                                  dropdownColor: context.cardColor,
                                  value: selectedBillingState,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      selectedBillingState = value;
                                      if (isCheckBoxSelected) {
                                        selectedShippingState = selectedBillingState;
                                      }
                                    });
                                  },
                                  items: billingStateList.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          value.name != null && value.name.toString().isNotEmpty ? value.name : "NA",
                                          style: primaryTextStyle(color: Theme.of(context).textTheme.titleMedium!.color),
                                        ).paddingOnly(left: 16, right: 16, top: 8, bottom: 8),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : Text("NA", style: primaryTextStyle(color: Theme.of(context).textTheme.titleMedium!.color)).paddingOnly(top: 12, bottom: 12).center(),
                        ).expand()
                      ],
                    ).visible(billingCountryList.isNotEmpty),
                    16.height,
                    SimpleEditText(
                      mController: txtBillingMobile,
                      keyboardType: TextInputType.number,
                      hintText: appLocalization.translate('hint_mobile_no'),
                      validator: (String? v) {
                        if (v!.trim().isEmpty) return appLocalization.translate('hint_mobile_no')! + (' ') + appLocalization.translate('error_field_required')!;
                      },
                    ),
                    SimpleEditText(
                      mController: txtBillingEmail,
                      hintText: appLocalization.translate('lbl_email'),
                      validator: (String? v) {
                        if (v!.trim().isEmpty) return appLocalization.translate('lbl_email')! + (' ') + appLocalization.translate('error_field_required')!;
                        if (!v.trim().validateEmail()) return appLocalization.translate('error_wrong_email');
                      },
                    ),
                    Divider(thickness: 6, color: Theme.of(context).textTheme.headlineMedium!.color),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(appLocalization.translate("lbl_add_shipping_detail")!, style: boldTextStyle(size: 18)).expand(),
                        Row(
                          children: [
                            Text(appLocalization.translate('lbl_same')!, style: secondaryTextStyle(color: Theme.of(context).textTheme.titleSmall!.color, size: 16)),
                            Icon(isCheckBoxSelected == true ? Icons.check_box : Icons.check_box_outline_blank, color: isCheckBoxSelected == true ? context.cardColor : greyColor, size: 30).onTap(() {
                              isCheckBoxSelected = !isCheckBoxSelected;
                              fillShipping();
                              setState(() {});
                            })
                          ],
                        )
                      ],
                    ),
                    16.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SimpleEditText(
                            mController: txtShippingFirstName,
                            hintText: appLocalization.translate('hint_first_name'),
                            validator: (String? v) {
                              if (v!.trim().isEmpty) return appLocalization.translate('hint_first_name')! + (' ') + appLocalization.translate('error_field_required')!;
                              if (!v.trim().isAlpha()) return appLocalization.translate('error_only_alphabet');
                            },
                          ),
                        ),
                        16.width,
                        Expanded(
                          child: SimpleEditText(
                            mController: txtShippingLastName,
                            hintText: appLocalization.translate('hint_last_name'),
                            validator: (String? v) {
                              if (v!.trim().isEmpty) return appLocalization.translate('hint_last_name')! + (' ') + appLocalization.translate('error_field_required')!;
                              if (!v.trim().isAlpha()) return appLocalization.translate('error_only_alphabet');
                            },
                          ),
                        )
                      ],
                    ),
                    SimpleEditText(
                      mController: txtShippingAddress1,
                      hintText: appLocalization.translate('hint_add1'),
                      validator: (String? v) {
                        if (v!.trim().isEmpty) return appLocalization.translate('hint_add1')! + (' ') + appLocalization.translate('error_field_required')!;
                      },
                    ),
                    SimpleEditText(
                      mController: txtShippingAddress2,
                      hintText: appLocalization.translate('hint_add2'),
                      validator: (String? v) {
                        if (v!.trim().isEmpty) return appLocalization.translate('hint_add2')! + (' ') + appLocalization.translate('error_field_required')!;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SimpleEditText(
                            mController: txtShippingCity,
                            hintText: appLocalization.translate('hint_city'),
                            validator: (String? v) {
                              if (v!.trim().isEmpty) return appLocalization.translate('hint_city')! + (' ') + appLocalization.translate('error_field_required')!;
                            },
                          ),
                        ),
                        16.width,
                        Expanded(
                          child: SimpleEditText(
                            mController: txtShippingPinCode,
                            hintText: appLocalization.translate('hint_pin_code'),
                            validator: (String? v) {
                              if (v!.trim().isEmpty) return appLocalization.translate('hint_pin_code')! + (' ') + appLocalization.translate('error_field_required')!;
                              if (!v.trim().isDigit()) return appLocalization.translate('error_only_alphabet');
                            },
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: boxDecorationWithRoundedCorners(border: Border.all(width: 0.2), backgroundColor: context.cardColor),
                          child: DropdownButton(
                            value: selectedShippingCountry,
                            isExpanded: true,
                            dropdownColor: context.cardColor,
                            underline: SizedBox(),
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedShippingCountry = value;
                                shippingStateList.clear();
                                shippingStateList.addAll(selectedShippingCountry!.states!);
                                selectedShippingState = selectedShippingCountry!.states!.isNotEmpty ? shippingStateList[0] : null;
                              });
                            },
                            items: billingCountryList.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    value.name != null && value.name.toString().isNotEmpty ? value.name : "NA",
                                    style: primaryTextStyle(color: Theme.of(context).textTheme.titleMedium!.color),
                                  ).paddingOnly(left: 16, right: 16, top: 8, bottom: 8),
                                ),
                              );
                            }).toList(),
                          ),
                        ).expand(),
                        16.width,
                        Container(
                          decoration: boxDecorationWithRoundedCorners(border: Border.all(width: 0.2), backgroundColor: context.cardColor),
                          child: selectedShippingState != null
                              ? DropdownButton(dropdownColor: context.cardColor,
                                  value: selectedShippingState,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      selectedShippingState = value;
                                    });
                                  },
                                  items: shippingStateList.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          value.name != null && value.name.toString().isNotEmpty ? value.name : "NA",
                                          textAlign: TextAlign.center,
                                          style: primaryTextStyle(),
                                        ).paddingOnly(left: 16, right: 16, top: 8, bottom: 8),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : Text("NA", style: primaryTextStyle(color: Theme.of(context).textTheme.titleMedium!.color)).paddingOnly(top: 12, bottom: 12).center(),
                        ).expand()
                      ],
                    ).visible(billingCountryList.isNotEmpty),
                  ],
                ),
              ),
            ),
            Observer(builder: (context) => mProgress().center().visible(appStore.isLoading))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: AppButton(
          width: context.width(),
          textStyle: primaryTextStyle(color: white),
          text: appLocalization.translate("lbl_save"),
          color: isHalloween ? mChristmasColor : primaryColor,
          onTap: () {
            saveUser();
          },
        ).paddingAll(16),
      ),
    );
  }
}
