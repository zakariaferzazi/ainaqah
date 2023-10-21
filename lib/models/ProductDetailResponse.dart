class ProductDetailResponse {
  List<Attribute>? attributes;
  String? averageRating;
  String? buttonText;
  String? catalogVisibility;
  List<Category>? categories;
  List<int>? crossSellIds;
  String? dateCreated;
  String? dateModified;
  String? dateOnSaleFrom;
  String? dateOnSaleTo;
  String? description;
  Dimensions? dimensions;
  int? downloadExpiry;
  int? downloadLimit;
  String? downloadType;
  bool? downloadable;
  String? externalUrl;
  bool? featured;
  int? id;
  List<ImageModel>? images;
  bool? inStock;
  bool? isAddedCart;
  bool? isAddedWishList;
  bool? manageStock;
  int? menuOrder;
  String? name;
  bool? onSale;
  int? parentId;
  String? permalink;
  String? price;
  String? priceHtml;
  bool? purchasable;
  String? purchaseNote;
  int? ratingCount;
  String? regularPrice;
  List<int>? relatedIds;
  bool? reviewsAllowed;
  String? salePrice;
  String? shippingClass;
  int? shippingClassId;
  bool? shippingRequired;
  bool? shippingTaxable;
  String? shortDescription;
  String? sku;
  String? slug;
  bool? soldIndividually;
  String? status;
  Store? store;
  String? taxClass;
  String? taxStatus;
  String? type;
  List<int>? upSellIds;
  List<UpsellId>? upSellId;
  List<int>? variations;
  bool? virtual;
  String? weight;
  VideoData? woofVideoEmbed;

  ProductDetailResponse(
      {this.attributes,
        this.averageRating,
        this.buttonText,
        this.catalogVisibility,
        this.categories,
        this.crossSellIds,
        this.dateCreated,
        this.dateModified,
        this.dateOnSaleFrom,
        this.dateOnSaleTo,
        this.description,
        this.dimensions,
        this.downloadExpiry,
        this.downloadLimit,
        this.downloadType,
        this.downloadable,
        this.externalUrl,
        this.featured,
        this.id,
        this.images,
        this.inStock,
        this.isAddedCart,
        this.isAddedWishList,
        this.manageStock,
        this.menuOrder,
        this.name,
        this.onSale,
        this.parentId,
        this.permalink,
        this.price,
        this.priceHtml,
        this.purchasable,
        this.purchaseNote,
        this.ratingCount,
        this.regularPrice,
        this.relatedIds,
        this.reviewsAllowed,
        this.salePrice,
        this.shippingClass,
        this.shippingClassId,
        this.shippingRequired,
        this.shippingTaxable,
        this.shortDescription,
        this.sku,
        this.slug,
        this.soldIndividually,
        this.status,
        this.store,
        this.taxClass,
        this.taxStatus,
        this.type,
        this.upSellIds,
        this.upSellId,
        this.variations,
        this.virtual,
        this.weight,
        this.woofVideoEmbed});

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      attributes: json['attributes'] != null ? (json['attributes'] as List).map((i) => Attribute.fromJson(i)).toList() : null,
      averageRating: json['average_rating'],
      buttonText: json['button_text'],
      catalogVisibility: json['catalog_visibility'],
      categories: json['categories'] != null ? (json['categories'] as List).map((i) => Category.fromJson(i)).toList() : null,
      crossSellIds: json['cross_sell_ids'] != null ? new List<int>.from(json['cross_sell_ids']) : null,
      dateCreated: json['date_created'],
      dateModified: json['date_modified'],
      dateOnSaleFrom: json['date_on_sale_from'],
      dateOnSaleTo: json['date_on_sale_to'],
      description: json['description'],
      dimensions: json['dimensions'] != null ? Dimensions.fromJson(json['dimensions']) : null,
      downloadExpiry: json['download_expiry'],
      downloadLimit: json['download_limit'],
      downloadType: json['download_type'],
      /* downloadable: json['downloadable'],*/
      externalUrl: json['external_url'],
      featured: json['featured'],
      id: json['id'],
      images: json['images'] != null ? (json['images'] as List).map((i) => ImageModel.fromJson(i)).toList() : null,
      inStock: json['in_stock'],
      isAddedCart: json['is_added_cart'],
      isAddedWishList: json['is_added_wishlist'],
      //manageStock: json['manage_stock'],
      menuOrder: json['menu_order'],
      name: json['name'],
      onSale: json['on_sale'],
      parentId: json['parent_id'],
      permalink: json['permalink'],
      price: json['price'],
      priceHtml: json['price_html'],
      purchasable: json['purchasable'],
      purchaseNote: json['purchase_note'],
      ratingCount: json['rating_count'],
      regularPrice: json['regular_price'],
      relatedIds: json['related_ids'] != null ? new List<int>.from(json['related_ids']) : null,
      reviewsAllowed: json['reviews_allowed'],
      salePrice: json['sale_price'],
      shippingClass: json['shipping_class'],
      shippingClassId: json['shipping_class_id'],
      shippingRequired: json['shipping_required'],
      shippingTaxable: json['shipping_taxable'],
      shortDescription: json['short_description'],
      sku: json['sku'],
      slug: json['slug'],
      soldIndividually: json['sold_individually'],
      status: json['status'],
      store: json['store'] != null ? Store.fromJson(json['store']) : null,
      taxClass: json['tax_class'],
      taxStatus: json['tax_status'],
      type: json['type'],
      upSellIds: json['upsell_ids'] != null ? new List<int>.from(json['upsell_ids']) : null,
      variations: json['variations'] != null ? new List<int>.from(json['variations']) : null,
      virtual: json['virtual'],
      weight: json['weight'],
      upSellId: json['upsell_id'] != null ? (json['upsell_id'] as List).map((i) => UpsellId.fromJson(i)).toList() : null,
      woofVideoEmbed: json['woofv_video_embed'] != null ? VideoData.fromJson(json['woofv_video_embed']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average_rating'] = this.averageRating;
    data['button_text'] = this.buttonText;
    data['catalog_visibility'] = this.catalogVisibility;
    data['date_created'] = this.dateCreated;
    data['date_modified'] = this.dateModified;
    data['date_on_sale_from'] = this.dateOnSaleFrom;
    data['date_on_sale_to'] = this.dateOnSaleTo;
    data['description'] = this.description;
    data['download_expiry'] = this.downloadExpiry;
    data['download_limit'] = this.downloadLimit;
    data['download_type'] = this.downloadType;
    data['downloadable'] = this.downloadable;
    data['external_url'] = this.externalUrl;
    data['featured'] = this.featured;
    data['id'] = this.id;
    data['in_stock'] = this.inStock;
    data['is_added_cart'] = this.isAddedCart;
    data['is_added_wishlist'] = this.isAddedWishList;
    data['manage_stock'] = this.manageStock;
    data['menu_order'] = this.menuOrder;
    data['name'] = this.name;
    data['on_sale'] = this.onSale;
    data['parent_id'] = this.parentId;
    data['permalink'] = this.permalink;
    data['price'] = this.price;
    data['price_html'] = this.priceHtml;
    data['purchasable'] = this.purchasable;
    data['purchase_note'] = this.purchaseNote;
    data['rating_count'] = this.ratingCount;
    data['regular_price'] = this.regularPrice;
    data['reviews_allowed'] = this.reviewsAllowed;
    data['sale_price'] = this.salePrice;
    data['shipping_class'] = this.shippingClass;
    data['shipping_class_id'] = this.shippingClassId;
    data['shipping_required'] = this.shippingRequired;
    data['shipping_taxable'] = this.shippingTaxable;
    data['short_description'] = this.shortDescription;
    data['sku'] = this.sku;
    data['slug'] = this.slug;
    data['sold_individually'] = this.soldIndividually;
    data['status'] = this.status;
    data['tax_class'] = this.taxClass;
    data['tax_status'] = this.taxStatus;
    data['type'] = this.type;
    data['virtual'] = this.virtual;
    data['weight'] = this.weight;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.crossSellIds != null) {
      data['cross_sell_ids'] = this.crossSellIds;
    }

    if (this.dimensions != null) {
      data['dimensions'] = this.dimensions!.toJson();
    }

    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.relatedIds != null) {
      data['related_ids'] = this.relatedIds;
    }
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    if (this.upSellIds != null) {
      data['upsell_ids'] = this.upSellIds;
    }
    if (this.variations != null) {
      data['variations'] = this.variations;
    }
    if (this.woofVideoEmbed != null) {
      data['woofv_video_embed'] = this.woofVideoEmbed!.toJson();
    }
    return data;
  }
}

class VideoData {
  bool? autoplay;
  String? poster;
  String? thumbnail;
  String? url;

  VideoData({this.autoplay, this.poster, this.thumbnail, this.url});

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      autoplay: json['autoplay'],
      poster: json['poster'],
      thumbnail: json['thumbnail'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['autoplay'] = this.autoplay;
    data['poster'] = this.poster;
    data['thumbnail'] = this.thumbnail;
    data['url'] = this.url;
    return data;
  }
}

class Store {
  Address? address;
  int? id;
  String? name;
  String? shopName;
  String? url;

  Store({this.address, this.id, this.name, this.shopName, this.url});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      id: json['id'],
      name: json['name'],
      shopName: json['shop_name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['shop_name'] = this.shopName;
    data['url'] = this.url;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}

class Address {
  String? city;
  String? country;
  String? state;
  String? street_1;
  String? street_2;
  String? zip;

  Address({this.city, this.country, this.state, this.street_1, this.street_2, this.zip});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'],
      country: json['country'],
      state: json['state'],
      street_1: json['street_1'],
      street_2: json['street_2'],
      zip: json['zip'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['street_1'] = this.street_1;
    data['street_2'] = this.street_2;
    data['zip'] = this.zip;
    return data;
  }
}

class Dimensions {
  String? height;
  String? length;
  String? width;

  Dimensions({this.height, this.length, this.width});

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      height: json['height'],
      length: json['length'],
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['length'] = this.length;
    data['width'] = this.width;
    return data;
  }
}

class Attribute {
  var id;
  var name;
  var position;
  var visible;
  var variation;
  List<String>? options;
  String? option;

  Attribute({this.id, this.name, this.position, this.visible, this.variation, this.option, this.options});

//  Attributes.fromJson(Map<String, dynamic> json) {
//    id = json['id'];
//    name = json['name'];
//    position = json['position'];
//    visible = json['visible'];
//    variation = json['variation'];
//    options = json['options'] != null
//        ? new List<String>.from(json['options'])
//        : null;
//  }
  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      visible: json['visible'],
      variation: json['variation'],
      option: json['option'],
      options: json['options'] != null ? new List<String>.from(json['options']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['position'] = this.position;
    data['visible'] = this.visible;
    data['variation'] = this.variation;
    data['option'] = this.option;
    if (this.options != null) {
      data['options'] = this.options;
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? slug;

  Category({this.id, this.name, this.slug});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class ImageModel {
  String? alt;
  String? dateCreated;
  String? dateModified;
  int? id;
  String? name;
  int? position;
  String? src;

  ImageModel({this.alt, this.dateCreated, this.dateModified, this.id, this.name, this.position, this.src});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      alt: json['alt'],
      dateCreated: json['date_created'],
      dateModified: json['date_modified'],
      id: json['id'],
      name: json['name'],
      position: json['position'],
      src: json['src'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alt'] = this.alt;
    data['date_created'] = this.dateCreated;
    data['date_modified'] = this.dateModified;
    data['id'] = this.id;
    data['name'] = this.name;
    data['position'] = this.position;
    data['src'] = this.src;
    return data;
  }
}

class UpsellId {
  int? id;
  List<ImageX>? images;
  String? name;
  String? price;
  String? regularPrice;
  String? salePrice;
  String? slug;

  UpsellId({this.id, this.images, this.name, this.price, this.regularPrice, this.salePrice, this.slug});

  factory UpsellId.fromJson(Map<String, dynamic> json) {
    return UpsellId(
      id: json['id'],
      images: json['images'] != null ? (json['images'] as List).map((i) => ImageX.fromJson(i)).toList() : null,
      name: json['name'],
      price: json['price'],
      regularPrice: json['regular_price'],
      salePrice: json['sale_price'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['slug'] = this.slug;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageX {
  String? alt;
  String? dateCreated;
  String? dateModified;
  int? id;
  String? name;
  int? position;
  String? src;

  ImageX({this.alt, this.dateCreated, this.dateModified, this.id, this.name, this.position, this.src});

  factory ImageX.fromJson(Map<String, dynamic> json) {
    return ImageX(
      alt: json['alt'],
      dateCreated: json['date_created'],
      dateModified: json['date_modified'],
      id: json['id'],
      name: json['name'],
      position: json['position'],
      src: json['src'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alt'] = this.alt;
    data['date_created'] = this.dateCreated;
    data['date_modified'] = this.dateModified;
    data['id'] = this.id;
    data['name'] = this.name;
    data['position'] = this.position;
    data['src'] = this.src;
    return data;
  }
}
