import 'dart:convert';

import 'package:ainaqah/main.dart';

import '/../models/WishListResponse.dart';
import '/../network/rest_apis.dart';
import '/../utils/Constants.dart';
import '/../utils/SharedPref.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'WishListStore.g.dart';

class WishListStore = _WishListStore with _$WishListStore;

abstract class _WishListStore with Store {
  @observable
  List<WishListResponse> wishList = ObservableList<WishListResponse>();

  @action
  Future<void> addToWishList(WishListResponse data) async {
    if (wishList.any((element) => element.proId == data.proId)) {
      if (!await isGuestUser() && await isLoggedIn()) {
        wishList.remove(data);

        await removeWishList({'pro_id': data.proId}).then((value) {
          getWishlistItem();
          toast(value["message"], print: true);
        }).catchError((e) {
          log(e.toString());
        });
      } else {
        wishList.removeWhere((element) => element.proId == data.proId);
        toast("Product Deleted From Wishlist");
      }
    } else {
      if (!await isGuestUser() && await isLoggedIn()) {
        wishList.add(data);
        var request = {'pro_id': data.proId};
        await addWishList(request).then((value) {
          getWishlistItem();
          toast(value["message"], print: true);
        }).catchError((e) {
          log(e.toString());
        });
      } else {
        wishList.add(data);
        toast("Product Successfully Added To Wishlist");
      }
    }
    storeWishlistData();
  }

  bool isItemInWishlist(int id) {
    return wishList.any((element) => element.proId == id);
  }

  @action
  Future<void> storeWishlistData() async {
    if (wishList.isNotEmpty) {
      await setValue(WISHLIST_ITEM_LIST, jsonEncode(wishList));
      log(getStringAsync(WISHLIST_ITEM_LIST));
    } else {
      await setValue(WISHLIST_ITEM_LIST, '');
    }
  }

  @action
  void addAllWishListItem(List<WishListResponse> productList) {
    wishList.addAll(productList);
  }

  @action
  Future<void> getWishlistItem() async {
    appStore.setLoading(true);
    getWishList().then((value) {
      wishList = ObservableList.of(value);
      appStore.setLoading(false);
    }).catchError((e) {
      log(e.toString());
    });
  }

  @action
  Future<void> clearWishlist() async {
    wishList.clear();
    storeWishlistData();
  }
}
