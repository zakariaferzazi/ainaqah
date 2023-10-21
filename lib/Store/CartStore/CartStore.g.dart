// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CartStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CartStore on _CartStore, Store {
  final _$cartListAtom = Atom(name: '_CartStore.cartList');

  @override
  List<CartModel> get cartList {
    _$cartListAtom.reportRead();
    return super.cartList;
  }

  @override
  set cartList(List<CartModel> value) {
    _$cartListAtom.reportWrite(value, super.cartList, () {
      super.cartList = value;
    });
  }

  final _$cartResponseAtom = Atom(name: '_CartStore.cartResponse');

  @override
  CartResponse? get cartResponse {
    _$cartResponseAtom.reportRead();
    return super.cartResponse;
  }

  @override
  set cartResponse(CartResponse? value) {
    _$cartResponseAtom.reportWrite(value, super.cartResponse, () {
      super.cartResponse = value;
    });
  }

  final _$mLineItemsAtom = Atom(name: '_CartStore.mLineItems');

  @override
  List<LineItems> get mLineItems {
    _$mLineItemsAtom.reportRead();
    return super.mLineItems;
  }

  @override
  set mLineItems(List<LineItems> value) {
    _$mLineItemsAtom.reportWrite(value, super.mLineItems, () {
      super.mLineItems = value;
    });
  }

  final _$shippingMethodsAtom = Atom(name: '_CartStore.shippingMethods');

  @override
  List<Method> get shippingMethods {
    _$shippingMethodsAtom.reportRead();
    return super.shippingMethods;
  }

  @override
  set shippingMethods(List<Method> value) {
    _$shippingMethodsAtom.reportWrite(value, super.shippingMethods, () {
      super.shippingMethods = value;
    });
  }

  final _$countryListAtom = Atom(name: '_CartStore.countryList');

  @override
  List<Country> get countryList {
    _$countryListAtom.reportRead();
    return super.countryList;
  }

  @override
  set countryList(List<Country> value) {
    _$countryListAtom.reportWrite(value, super.countryList, () {
      super.countryList = value;
    });
  }

  final _$shippingAtom = Atom(name: '_CartStore.shipping');

  @override
  Shipping? get shipping {
    _$shippingAtom.reportRead();
    return super.shipping;
  }

  @override
  set shipping(Shipping? value) {
    _$shippingAtom.reportWrite(value, super.shipping, () {
      super.shipping = value;
    });
  }

  final _$shippingMethodResponseAtom =
      Atom(name: '_CartStore.shippingMethodResponse');

  @override
  ShippingMethodResponse? get shippingMethodResponse {
    _$shippingMethodResponseAtom.reportRead();
    return super.shippingMethodResponse;
  }

  @override
  set shippingMethodResponse(ShippingMethodResponse? value) {
    _$shippingMethodResponseAtom
        .reportWrite(value, super.shippingMethodResponse, () {
      super.shippingMethodResponse = value;
    });
  }

  final _$isOutOfStockAtom = Atom(name: '_CartStore.isOutOfStock');

  @override
  bool get isOutOfStock {
    _$isOutOfStockAtom.reportRead();
    return super.isOutOfStock;
  }

  @override
  set isOutOfStock(bool value) {
    _$isOutOfStockAtom.reportWrite(value, super.isOutOfStock, () {
      super.isOutOfStock = value;
    });
  }

  final _$cartTotalDiscountAtom = Atom(name: '_CartStore.cartTotalDiscount');

  @override
  num get cartTotalDiscount {
    _$cartTotalDiscountAtom.reportRead();
    return super.cartTotalDiscount;
  }

  @override
  set cartTotalDiscount(num value) {
    _$cartTotalDiscountAtom.reportWrite(value, super.cartTotalDiscount, () {
      super.cartTotalDiscount = value;
    });
  }

  final _$cartTotalAmountAtom = Atom(name: '_CartStore.cartTotalAmount');

  @override
  num get cartTotalAmount {
    _$cartTotalAmountAtom.reportRead();
    return super.cartTotalAmount;
  }

  @override
  set cartTotalAmount(num value) {
    _$cartTotalAmountAtom.reportWrite(value, super.cartTotalAmount, () {
      super.cartTotalAmount = value;
    });
  }

  final _$cartTotalPayableAmountAtom =
      Atom(name: '_CartStore.cartTotalPayableAmount');

  @override
  num get cartTotalPayableAmount {
    _$cartTotalPayableAmountAtom.reportRead();
    return super.cartTotalPayableAmount;
  }

  @override
  set cartTotalPayableAmount(num value) {
    _$cartTotalPayableAmountAtom
        .reportWrite(value, super.cartTotalPayableAmount, () {
      super.cartTotalPayableAmount = value;
    });
  }

  final _$cartSavedAmountAtom = Atom(name: '_CartStore.cartSavedAmount');

  @override
  num get cartSavedAmount {
    _$cartSavedAmountAtom.reportRead();
    return super.cartSavedAmount;
  }

  @override
  set cartSavedAmount(num value) {
    _$cartSavedAmountAtom.reportWrite(value, super.cartSavedAmount, () {
      super.cartSavedAmount = value;
    });
  }

  final _$cartTotalCountAtom = Atom(name: '_CartStore.cartTotalCount');

  @override
  num get cartTotalCount {
    _$cartTotalCountAtom.reportRead();
    return super.cartTotalCount;
  }

  @override
  set cartTotalCount(num value) {
    _$cartTotalCountAtom.reportWrite(value, super.cartTotalCount, () {
      super.cartTotalCount = value;
    });
  }

  final _$selectedShipmentAtom = Atom(name: '_CartStore.selectedShipment');

  @override
  int get selectedShipment {
    _$selectedShipmentAtom.reportRead();
    return super.selectedShipment;
  }

  @override
  set selectedShipment(int value) {
    _$selectedShipmentAtom.reportWrite(value, super.selectedShipment, () {
      super.selectedShipment = value;
    });
  }

  final _$addToMyCartAsyncAction = AsyncAction('_CartStore.addToMyCart');

  @override
  Future<void> addToMyCart(CartModel data) {
    return _$addToMyCartAsyncAction.run(() => super.addToMyCart(data));
  }

  final _$updateToCartItemAsyncAction =
      AsyncAction('_CartStore.updateToCartItem');

  @override
  Future<void> updateToCartItem(dynamic req) {
    return _$updateToCartItemAsyncAction.run(() => super.updateToCartItem(req));
  }

  final _$storeCartDataAsyncAction = AsyncAction('_CartStore.storeCartData');

  @override
  Future<void> storeCartData() {
    return _$storeCartDataAsyncAction.run(() => super.storeCartData());
  }

  final _$clearCartAsyncAction = AsyncAction('_CartStore.clearCart');

  @override
  Future<void> clearCart() {
    return _$clearCartAsyncAction.run(() => super.clearCart());
  }

  final _$fetchShipmentDataAsyncAction =
      AsyncAction('_CartStore.fetchShipmentData');

  @override
  Future<void> fetchShipmentData() {
    return _$fetchShipmentDataAsyncAction.run(() => super.fetchShipmentData());
  }

  final _$fetchShippingMethodAsyncAction =
      AsyncAction('_CartStore.fetchShippingMethod');

  @override
  Future fetchShippingMethod(dynamic value) {
    return _$fetchShippingMethodAsyncAction
        .run(() => super.fetchShippingMethod(value));
  }

  final _$_CartStoreActionController = ActionController(name: '_CartStore');

  @override
  void addAllCartItem(List<CartModel> productList) {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.addAllCartItem');
    try {
      return super.addAllCartItem(productList);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void calculateTotal() {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.calculateTotal');
    try {
      return super.calculateTotal();
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getCartListData() {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.getCartListData');
    try {
      return super.getCartListData();
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addToCartList(CartModel val) {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.addToCartList');
    try {
      return super.addToCartList(val);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFromCartList(CartModel val) {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.removeFromCartList');
    try {
      return super.removeFromCartList(val);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getStoreCartList() {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.getStoreCartList');
    try {
      return super.getStoreCartList();
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic loadShippingMethod() {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.loadShippingMethod');
    try {
      return super.loadShippingMethod();
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cartList: ${cartList},
cartResponse: ${cartResponse},
mLineItems: ${mLineItems},
shippingMethods: ${shippingMethods},
countryList: ${countryList},
shipping: ${shipping},
shippingMethodResponse: ${shippingMethodResponse},
isOutOfStock: ${isOutOfStock},
cartTotalDiscount: ${cartTotalDiscount},
cartTotalAmount: ${cartTotalAmount},
cartTotalPayableAmount: ${cartTotalPayableAmount},
cartSavedAmount: ${cartSavedAmount},
cartTotalCount: ${cartTotalCount},
selectedShipment: ${selectedShipment}
    ''';
  }
}
