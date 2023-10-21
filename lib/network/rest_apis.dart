import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '/../models/CartModel.dart';
import '/../models/ProductResponse.dart';
import '/../models/WalletResponse.dart';
import '/../models/WishListResponse.dart';
import '/../utils/Constants.dart';
import '/../utils/SharedPref.dart';
import 'package:nb_utils/nb_utils.dart';
import 'NetworkUtils.dart';
import 'mighty_api.dart';

Future createCustomer(request) async {
  return handleResponse(await MightyAPI().postAsync('store/api/v1/auth/registration', request));
}

Future login(request) async {
  return handleResponse(await MightyAPI().postAsync('jwt-auth/v1/token', request));
}

Future getProductDetail(int? productId) async {
  if (!await isGuestUser() && await isLoggedIn()) {
    return handleResponse(await MightyAPI().getAsync('store/api/v1/woocommerce/get-product-details?product_id=$productId', requireToken: true));
  } else {
    return handleResponse(await MightyAPI().getAsync('store/api/v1/woocommerce/get-product-details?product_id=$productId', requireToken: false));
  }
}

Future searchProduct(request) async {
  if (!await isGuestUser() && await isLoggedIn()) {
    return handleResponse(await MightyAPI().postAsync('store/api/v1/woocommerce/get-product', request, requireToken: true));
  } else {
    return handleResponse(await MightyAPI().postAsync('store/api/v1/woocommerce/get-product', request, requireToken: false));
  }
}

Future getProductAttribute() async {
  return handleResponse(await MightyAPI().getAsync('store/api/v1/woocommerce/get-product-attributes'));
}

Future updateCustomer(id, request) async {
  return handleResponse(await MightyAPI().postAsync('wc/v3/customers/$id', request));
}

Future forgetPassword(request) async {
  return handleResponse(await MightyAPI().postAsync('store/api/v1/customer/forget-password', request));
}

Future getCustomer(id) async {
  return handleResponse(await MightyAPI().getAsync('wc/v3/customers/$id'));
}

Future getCategories(page, total) async {
  return handleResponse(await MightyAPI().getAsync('wc/v3/products/categories?page=$page&per_page=$total&parent=0'));
}

Future getSubCategories(parent, page) async {
  return handleResponse(await MightyAPI().getAsync('wc/v3/products/categories?page=$page&parent=$parent'));
}

Future getAllCategories(category, page, total) async {
  return handleResponse(await MightyAPI().getAsync('wc/v3/products?category=$category&page=$page&per_page=$total'));
}

Future<List<WishListResponse>> getWishList() async {
  Iterable it = (await handleResponse(await MightyAPI().getAsync('store/api/v1/wishlist/get-wishlist/', requireToken: true)));
  return it.map((e) => WishListResponse.fromJson(e)).toList();
}

Future saveProfileImage(request) async {
  return handleResponse(await MightyAPI().postAsync('store/api/v2/customer/save-profile-image', request, requireToken: true));
}

Future changePassword(request) async {
  return handleResponse(await MightyAPI().postAsync('store/api/v1/customer/change-password', request, requireToken: true));
}

Future getDashboardApi() async {
  if (!await isGuestUser() && await isLoggedIn()) {
    return handleResponse(await MightyAPI().getAsync('store/api/v1/woocommerce/get-dashboard?per_page=$TOTAL_DASHBOARD_ITEM', requireToken: true));
  } else {
    return handleResponse(await MightyAPI().getAsync('store/api/v1/woocommerce/get-dashboard?per_page=$TOTAL_DASHBOARD_ITEM', requireToken: false));
  }
}

Future addWishList(request) async {
  return handleResponse(await MightyAPI().postAsync('store/api/v1/wishlist/add-wishlist/', request, requireToken: true));
}

Future removeWishList(request) async {
  return handleResponse(await MightyAPI().postAsync('store/api/v1/wishlist/delete-wishlist/', request, requireToken: true));
}

Future addToCart(request) async {
  return handleResponse(await MightyAPI().postAsync('store/api/v1/cart/add-cart/', request, requireToken: true));
}

Future removeCartItem(request) async {
  return handleResponse(await MightyAPI().postAsync('store/api/v1/cart/delete-cart/', request, requireToken: true));
}

Future getCartList() async {
  return handleResponse(await MightyAPI().getAsync('store/api/v1/cart/get-cart/', requireToken: true));
}

Future<CartResponse> getCartListApi() async {
  return CartResponse.fromJson(await handleResponse(await MightyAPI().getAsync('store/api/v1/cart/get-cart/', requireToken: true)));
}

Future updateCartItem(request) async {
  return handleResponse(await MightyAPI().postAsync('store/api/v1/cart/update-cart/', request, requireToken: true));
}

Future getCouponList() async {
  return handleResponse(await MightyAPI().getAsync('wc/v3/Coupons'));
}

Future getProductReviews(id) async {
  return handleResponse(await MightyAPI().getAsync('wc/v3/products/reviews?product=$id'));
}

Future postReview(request) async {
  return handleResponse(await MightyAPI().postAsync('wc/v3/products/reviews', request));
}

Future updateReview(id1, request) async {
  return handleResponse(await MightyAPI().postAsync('wc/v3/products/reviews/$id1', request));
}

Future createOrderApi(request) async {
  return handleResponse(await MightyAPI().postAsync('wc/v3/orders', request));
}

Future deleteReview(id1) async {
  return handleResponse(await MightyAPI().deleteAsync('wc/v3/products/reviews/$id1'));
}


Future getOrders() async {
  return handleResponse(await MightyAPI().getAsync('store/api/v1/woocommerce/get-customer-orders', requireToken: true));
}
Future getOrdersTracking(orderId) async {
  return handleResponse(await MightyAPI().getAsync('wc/v3/orders/$orderId/notes'));
}

Future createOrderNotes(orderId, request) async {
  return handleResponse(await MightyAPI().postAsync('wc/v3/orders/$orderId/notes', request));
}

Future cancelOrder(orderId, request) async {
  return handleResponse(await MightyAPI().postAsync('wc/v3/orders/$orderId', request));
}

Future getCheckOutUrl(request) async {
  return handleResponse(await MightyAPI().postAsync('store/api/v1/woocommerce/get-checkout-url', request, requireToken: true));
}

Future clearCartItems() async {
  return handleResponse(await MightyAPI().getAsync('store/api/v1/cart/clear-cart/', requireToken: true));
}

Future getCountries() async {
  return handleResponse(await MightyAPI().getAsync('wc/v3/data/countries', requireToken: false));
}

Future getStripeClientSecret(request) async {
  return handleResponse(await MightyAPI().postAsync('store/api/v1/woocommerce/get-stripe-client-secret', request, requireToken: true));
}

Future getShippingMethod(request) async {
  return handleResponse(await MightyAPI().postAsync('store/api/v1/woocommerce/get-shipping-methods', request, requireToken: false));
}

Future deleteOrder(id1) async {
  return handleResponse(await MightyAPI().deleteAsync('wc/v3/orders/$id1'));
}

Future getVendor() async {
  return handleResponse(await MightyAPI().getAsync('store/api/v1/woocommerce/get-vendors'));
}

Future getVendorProfile(id) async {
  return handleResponse(await MightyAPI().getAsync('dokan/v1/stores/$id'));
}

Future getVendorProduct(id) async {
  if (!await isGuestUser() && await isLoggedIn()) {
    return handleResponse(await MightyAPI().getAsync('store/api/v1/woocommerce/get-vendor-products?vendor_id=$id', requireToken: true));
  } else {
    return handleResponse(await MightyAPI().getAsync('store/api/v1/woocommerce/get-vendor-products?vendor_id=$id', requireToken: false));
  }
}

Future socialLoginApi(request) async {
  log(jsonEncode(request));
  return handleResponse(await MightyAPI().postAsync('store/api/v1/customer/social_login', request));
}

Future getBlogList(page, total) async {
  return handleResponse(await MightyAPI().getAsync('store/api/v1/blog/get-blog-list?paged=$page&posts_per_page=$total'));
}

Future getBlogDetail(id) async {
  return handleResponse(await MightyAPI().getAsync('store/api/v1/blog/get-blog-detail?post_id=$id'));
}

Future getTrackingInfo(id) async {
  return handleResponse(await MightyAPI().getAsync('wc-ast/v3/orders/$id/shipment-trackings/'));
}

Future getSaleInfo(startDate, endDate) async {
  return handleResponse(await MightyAPI().getAsync('store/api/v1/woocommerce/get-sale-product?start_date=$startDate&end_date=$endDate'));
}

Future<bool> updateProfile({File? file, String? toastMessage, bool showToast = true}) async {
  var multiPartRequest = MultipartRequest('POST', Uri.parse('${getStringAsync(APP_URL)}${'store/api/v2/customer/save-profile-image'}'));

  if (file != null) multiPartRequest.files.add(await MultipartFile.fromPath('profile_image', file.path));

  var header = {
    "Authorization": "Bearer ${getStringAsync(TOKEN)}",
  };
  multiPartRequest.headers.addAll(header);

  log(multiPartRequest.fields);
  Response response = await Response.fromStream(await multiPartRequest.send());
  log(response.body);

  if (response.statusCode.isSuccessful()) {
    Map<String, dynamic> res = jsonDecode(response.body);

    await setValue(PROFILE_IMAGE, res['store_profile_image']);
    if (showToast) toast(toastMessage ?? res['message']);

    return true;
  } else {
    toast(errorSomethingWentWrong);
    return false;
  }
}

Future<List<WalletResponse>> getWalletBalance(int? id) async {
  Iterable it = await (handleResponse(await MightyAPI().getAsync('wp/v2/wallet/$id', requireToken: true)));
  return it.map((e) => WalletResponse.fromJson(e)).toList();
}

Future addTransaction(request) async {
  return handleResponse(await MightyAPI().postAsync('wp/v2/wallet/${getIntAsync(USER_ID)}', request, requireToken: true));
}

Future<List<ProductResponse>> getPrivateProduct() async {
  Iterable it = await (handleResponse(await MightyAPI().getAsync('wc/v3/products?status=private')));
  return it.map((e) => ProductResponse.fromJson(e)).toList();
}

Future getBalance() async {
  String value = await handleResponse(await MightyAPI().getAsync('wp/v2/current_balance/${getIntAsync(USER_ID)}', requireToken: true));
  return value;
}

Future getWalletConfiguration() async {
  // WalletConfigurationResponse value = await handleResponse(await MightyAPI().getAsync('store/api/v1/wallet/get-wallet-configuration',requireToken: true));
  // print("valueee"+value.productTitle!);
  return handleResponse(await MightyAPI().getAsync('store/api/v1/wallet/get-wallet-configuration',requireToken: true));
// return value;
}

Future addWallet(request) async {
  return handleResponse(await MightyAPI().postAsync('store/api/v1/wallet/add-to-wallet', request, requireToken: true));
}

Future deleteAccountApi() async{
  return handleResponse(await MightyAPI().postAsync('store/api/v1/customer/delete-account',{}, requireToken: true));
}
