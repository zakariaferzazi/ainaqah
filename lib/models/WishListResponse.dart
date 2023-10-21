class WishListResponse {
  int? proId;
  String? name;
  String? sku;
  String? price;
  String? regularPrice;
  String? salePrice;
  int? stockQuantity;
  bool? inStock;
  String? thumbnail;
  String? full;
  List<String>? gallery;
  String? createdAt;

  WishListResponse(
      {this.proId,
        this.name,
        this.sku,
        this.price,
        this.regularPrice,
        this.salePrice,
        this.stockQuantity,
        this.inStock,
        this.thumbnail,
        this.full,
        this.gallery,
        this.createdAt});

  WishListResponse.fromJson(Map<String, dynamic> json) {
    proId = json['pro_id'];
    name = json['name'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    stockQuantity = json['stock_quantity'];
    inStock = json['in_stock'];
    thumbnail = json['thumbnail'];
    full = json['full'];
    gallery = json['gallery'].cast<String>();
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pro_id'] = this.proId;
    data['name'] = this.name;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['stock_quantity'] = this.stockQuantity;
    data['in_stock'] = this.inStock;
    data['thumbnail'] = this.thumbnail;
    data['full'] = this.full;
    data['gallery'] = this.gallery;
    data['created_at'] = this.createdAt;
    return data;
  }
}
