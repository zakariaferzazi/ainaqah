class CartResponse {
  int? totalQuantity;
  List<CartModel>? data;

  CartResponse({this.totalQuantity, this.data});

  CartResponse.fromJson(Map<String, dynamic> json) {
    totalQuantity = json['total_quantity'];
    if (json['data'] != null) {
      data = <CartModel>[];
      json['data'].forEach((v) {
        data!.add(new CartModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_quantity'] = this.totalQuantity;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartModel {
  var cartId;
  var proId;
  var name;
  var sku;
  var price;
  var onSale;
  var regularPrice;
  var salePrice;
  var stockQuantity;
  var stockStatus;
  var thumbnail;
  var full;
  List<String?>? gallery;
  var createdAt;
  var quantity;

  CartModel(
      {this.cartId,
      this.proId,
      this.name,
      this.sku,
      this.price,
      this.onSale,
      this.regularPrice,
      this.salePrice,
      this.stockQuantity,
      this.stockStatus,
      this.thumbnail,
      this.full,
      this.gallery,
      this.createdAt,
      this.quantity});

  CartModel.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    proId = json['pro_id'];
    name = json['name'];
    sku = json['sku'];
    price = json['price'];
    onSale = json['on_sale'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    stockQuantity = json['stock_quantity'];
    stockStatus = json['stock_status'];
    thumbnail = json['thumbnail'];
    full = json['full'];
    gallery = json['gallery'].cast<String>();
    createdAt = json['created_at'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.cartId;
    data['pro_id'] = this.proId;
    data['name'] = this.name;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['on_sale'] = this.onSale;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['stock_quantity'] = this.stockQuantity;
    data['stock_status'] = this.stockStatus;
    data['thumbnail'] = this.thumbnail;
    data['full'] = this.full;
    data['gallery'] = this.gallery;
    data['created_at'] = this.createdAt;
    data['quantity'] = this.quantity;
    return data;
  }
}
