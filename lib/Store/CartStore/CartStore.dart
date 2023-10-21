import 'dart:convert';

import '/../models/CartModel.dart';
import '/../models/Countries.dart';
import '/../models/CustomerResponse.dart';
import '/../models/Line_items.dart';
import '/../models/ShippingMethodResponse.dart';
import '/../network/rest_apis.dart';
import '/../utils/Constants.dart';
import '/../utils/SharedPref.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

part 'CartStore.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  @observable
  List<CartModel> cartList = ObservableList<CartModel>();

  @observable
  CartResponse? cartResponse = CartResponse();

  @observable
  List<LineItems> mLineItems = [];

  @observable
  List<Method> shippingMethods = [];

  @observable
  List<Country> countryList = [];

  @observable
  Shipping? shipping;

  @observable
  ShippingMethodResponse? shippingMethodResponse;

  @observable
  bool isOutOfStock = false;

  @observable
  num cartTotalDiscount = 0.0;

  @observable
  num cartTotalAmount = 0.0;

  @observable
  num cartTotalPayableAmount = 0.0;

  @observable
  num cartSavedAmount = 0.0;

  @observable
  num cartTotalCount = 0.0;

  @observable
  var selectedShipment = 0;

  @action
  Future<void> addToMyCart(CartModel data) async {
    var proId = data.proId;
    var quantity = data.quantity;
    log(data.name);
    if (cartList.any((element) => element.proId == data.proId)) {
      if (!await isGuestUser() && await isLoggedIn()) {
        cartList.remove(data);
        var request = {
          "pro_id": proId,
        };

        await removeCartItem(request).then((value) {
          getStoreCartList();
          appStore.setLoading(false);
        }).catchError((error) {
          log(error.toString());
        });
        toast('Item remove from cart');
      } else {
        appStore.decrement(qty: data.quantity.toString().toInt());
        removeFromCartList(data);
      }

      calculateTotal();
    } else {
      if (!await isGuestUser() && await isLoggedIn()) {
        cartList.add(data);
        var request = {
          "pro_id": proId,
          "quantity": quantity,
        };

        await addToCart(request).then((value) {
          getStoreCartList();
          appStore.setLoading(false);
        }).catchError((error) {
          log(error.toString());
        });
        toast('Item added to cart');
      } else {
        addToCartList(data);
      }
      calculateTotal();
    }
  }

  @action
  Future<void> updateToCartItem(req) async {
    updateCartItem(req).then((value) {
      appStore.setLoading(false);
      log(value['message']);
      toast(value['message']);
      getCartListData();
    }).catchError((e) {
      toast(e.toString());
    });
  }

  @action
  void addAllCartItem(List<CartModel> productList) {
    cartList.addAll(productList);
    calculateTotal();
  }

  bool isItemInCart(int id) {
    return cartList.any((element) => element.proId == id.validate());
  }

  @action
  void calculateTotal() {
    cartTotalCount = 0.0;
    cartTotalDiscount = 0.0;
    cartTotalAmount = 0.0;
    for (var i = 0; i < cartList.length; i++) {
      if (cartList[i].stockStatus == "outofstock") {
        isOutOfStock = true;
      }
      var mItem = LineItems();
      mItem.proId = cartList[i].proId;
      mItem.quantity = cartList[i].quantity;
      mLineItems.add(mItem);
      if (cartList[i].onSale) {
        log('price:${cartList[i].salePrice} ${cartList[i].regularPrice}');
        cartTotalCount += double.parse(cartList[i].salePrice) * int.parse(cartList[i].quantity);
        log("cartTotalCount=$cartTotalCount");
        cartTotalAmount += double.parse(cartList[i].regularPrice) * int.parse(cartList[i].quantity);
        log("cartTotalAmount=$cartTotalAmount");
        cartTotalDiscount = cartTotalAmount - cartTotalCount;
        log("cartTotalDiscount=$cartTotalDiscount");
      } else {
        cartTotalCount += double.parse(cartList[i].regularPrice.toString().isNotEmpty ? cartList[i].regularPrice : cartList[i].price) * int.parse(cartList[i].quantity);
        cartTotalAmount += double.parse(cartList[i].regularPrice.toString().isNotEmpty ? cartList[i].regularPrice : cartList[i].price) * int.parse(cartList[i].quantity);
        log(cartList[i].price);
      }
    }
    storeCartData();
  }

  @action
  Future<void> storeCartData() async {
    if (cartList.isNotEmpty) {
      await setValue(CART_ITEM_LIST, jsonEncode(cartList));
    } else {
      await setValue(CART_ITEM_LIST, '');
    }
  }

  @action
  void getCartListData() {
    getCartList().then((value) {
      if (value['data'] != null) {
        Iterable list = value['data'];
        cartList = list.map((model) => CartModel.fromJson(model)).toList();
        log(cartList.first.name);
        cartTotalCount = 0.0;
        cartTotalDiscount = 0.0;
        cartTotalAmount = 0.0;
        mLineItems.clear();
        if (cartList.isEmpty) {
          appStore.setLoading(false);
          appStore.setCount(0);
        } else {
          for (var i = 0; i < cartList.length; i++) {
            if (cartList[i].stockStatus == "outofstock") {
              isOutOfStock = true;
            }
            var mItem = LineItems();
            mItem.proId = cartList[i].proId;
            mItem.quantity = cartList[i].quantity;
            mLineItems.add(mItem);
            if (cartList[i].onSale) {
              cartTotalCount += double.parse(cartList[i].salePrice) * int.parse(cartList[i].quantity);
              cartTotalAmount += double.parse(cartList[i].regularPrice) * int.parse(cartList[i].quantity);
              cartTotalDiscount = cartTotalAmount - cartTotalCount;
            } else {
              cartTotalCount += double.parse(cartList[i].regularPrice.toString().isNotEmpty ? cartList[i].regularPrice : cartList[i].price) * int.parse(cartList[i].quantity);
              cartTotalAmount += double.parse(cartList[i].regularPrice.toString().isNotEmpty ? cartList[i].regularPrice : cartList[i].price) * int.parse(cartList[i].quantity);
            }
          }
        }
      } else {
        appStore.setLoading(false);
      }
    });
  }

  @action
  void addToCartList(CartModel val) {
    print("AddCartModel=>${val.toJson()}");
    cartList.add(val);
    calculateTotal();
  }

  @action
  void removeFromCartList(CartModel val) {
    print("removeCartModel=>${val.toJson()}");
    cartList.removeWhere((element) => element.proId == val.proId);
    calculateTotal();
  }

  @action
  Future<void> clearCart() async {
    cartList.clear();
    cartTotalCount = 0.0;
    cartTotalDiscount = 0.0;
    cartTotalAmount = 0.0;
    storeCartData();
  }

  @action
  void getStoreCartList() {
    getCartListApi().then((value) async {
      if (value.totalQuantity == null && value.data == null) {
        appStore.setCount(0);
        cartList = [];
        calculateTotal();
      } else {
        cartList = ObservableList.of(value.data!);
        appStore.setCount(value.totalQuantity);
        calculateTotal();
      }
    }).catchError((error) {
      log(error.toString());
    });
  }

  @action
  Future<void> fetchShipmentData() async {
    String countries = getStringAsync(COUNTRIES);
    if (countries == '') {
      getCountries().then((value) async {
        appStore.setLoading(false);
        setValue(COUNTRIES, jsonEncode(value));
        fetchShippingMethod(value);
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error);
      });
    } else {
      fetchShippingMethod(jsonDecode(countries));
      appStore.setLoading(false);
      loadShippingMethod();
    }
  }

  @action
  fetchShippingMethod(var value) async {
    appStore.setLoading(true);
    Iterable list = value;
    var countris = list.map((model) => Country.fromJson(model)).toList();
    countryList.addAll(countris);

    if (getStringAsync(SHIPPING).isNotEmpty) {
      if (jsonDecode(getStringAsync(SHIPPING)) != null) {
        shipping = Shipping.fromJson(jsonDecode(getStringAsync(SHIPPING)));
        var mShippingPostcode = shipping!.postcode;
        var mShippingCountry = shipping!.country;
        var mShippingState = shipping!.state;
        String? countryCode = "";
        String? stateCode = "";
        if (mShippingCountry != null && mShippingCountry.isNotEmpty) {
          countryList.forEach((element) {
            if (element.code == mShippingCountry) {
              countryCode = element.code;
              if (mShippingState != null && mShippingState.isNotEmpty) {
                if (element.states != null && element.states!.isNotEmpty) {
                  element.states!.forEach((state) {
                    if (state.code == mShippingState) {
                      stateCode = state.code;
                    }
                  });
                }
              }
            }
          });
        }
        var request = {"country_code": countryCode, "state_code": stateCode, "postcode": mShippingPostcode};
        await getShippingMethod(request).then((value) {
          shippingMethodResponse = ShippingMethodResponse.fromJson(value);
          appStore.setLoading(false);
          loadShippingMethod();
        }).catchError((error) {
          appStore.setLoading(false);
          toast(error.toString());
        });
      }
    }
    appStore.setLoading(false);
  }

  @action
  loadShippingMethod() {
    shippingMethods.clear();
    if (shippingMethodResponse != null && shippingMethodResponse!.data!.methods != null) {
      shippingMethodResponse!.data!.methods!.forEach((method) {
        shippingMethods.add(method);
      });
      if (shippingMethods.isNotEmpty) {
        selectedShipment = 0;
      }
    }
  }
}
