class ProductListResponse {
  int? numOfPages;
  List<ProductResponse>? data;

  ProductListResponse({this.numOfPages, this.data});

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      numOfPages: json['num_of_pages'],
      data: json['data'] != null
          ? (json['data'] as List)
              .map((i) => ProductResponse.fromJson(i))
              .toList()
          : null,
    );
  }
}

class ProductResponse {
  int? id;
  var name;
  String? slug;
  String? permalink;
  String? dateCreated;
  String? dateModified;
  String? type;
  String? status;
  bool? featured;
  String? catalogVisibility;
  String? description;
  String? shortDescription;
  String? sku;
  String? price;
  String? regularPrice;
  String? salePrice;
  String? dateOnSaleFrom;
  String? dateOnSaleTo;
  String? priceHtml;
  bool? onSale;
  bool? purchasable;
  int? totalSales;
  bool? virtual;
  bool? downloadable;
  List<Null>? downloads;
  int? downloadLimit;
  int? downloadExpiry;
  String? downloadType;
  String? externalUrl;
  String? buttonText;
  String? taxStatus;
  String? taxClass;
  bool? manageStock;
  int? stockQuantity;
  bool? inStock;
  String? backorders;
  bool? backordersAllowed;
  bool? backOrdered;
  bool? soldIndividually;
  String? weight;
  Dimensions? dimensions;
  bool? shippingRequired;
  bool? shippingTaxable;
  String? shippingClass;
  int? shippingClassId;
  bool? reviewsAllowed;
  String? averageRating;
  int? ratingCount;
  List<int>? relatedIds;
  List<int>? upSellIds;
  List<int>? crossSellIds;
  int? parentId;
  String? purchaseNote;
  List<Categories>? categories;
  List<Null>? tags;
  List<Images>? images;
  List<Attributes>? attributes;
  List<Null>? defaultAttributes;
  List<Null>? variations;
  List<Null>? groupedProducts;
  int? menuOrder;
  bool? isAddedCart;
  bool? isAddedWishList;
  bool mIsInWishList = false;
  Store? store;

  ProductResponse(
      {this.id,
      this.name,
      this.slug,
      this.permalink,
      this.dateCreated,
      this.dateModified,
      this.type,
      this.status,
      this.featured,
      this.catalogVisibility,
      this.description,
      this.shortDescription,
      this.sku,
      this.price,
      this.regularPrice,
      this.salePrice,
      this.dateOnSaleFrom,
      this.dateOnSaleTo,
      this.priceHtml,
      this.onSale,
      this.purchasable,
      this.totalSales,
      this.virtual,
      this.downloadable,
      this.downloads,
      this.downloadLimit,
      this.downloadExpiry,
      this.downloadType,
      this.externalUrl,
      this.buttonText,
      this.taxStatus,
      this.taxClass,
      this.manageStock,
      this.stockQuantity,
      this.inStock,
      this.backorders,
      this.backordersAllowed,
      this.backOrdered,
      this.soldIndividually,
      this.weight,
      this.dimensions,
      this.shippingRequired,
      this.shippingTaxable,
      this.shippingClass,
      this.shippingClassId,
      this.reviewsAllowed,
      this.averageRating,
      this.ratingCount,
      this.relatedIds,
      this.upSellIds,
      this.crossSellIds,
      this.parentId,
      this.purchaseNote,
      this.categories,
      this.tags,
      this.images,
      this.attributes,
      this.defaultAttributes,
      this.variations,
      this.groupedProducts,
      this.menuOrder,
      this.isAddedCart,
      this.isAddedWishList});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    permalink = json['permalink'];
    dateCreated = json['date_created'];
    dateModified = json['date_modified'];
    type = json['type'];
    status = json['status'];
    featured = json['featured'];
    catalogVisibility = json['catalog_visibility'];
    description = json['description'];
    shortDescription = json['short_description'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    dateOnSaleFrom = json['date_on_sale_from'];
    dateOnSaleTo = json['date_on_sale_to'];
    priceHtml = json['price_html'];
    onSale = json['on_sale'];
    purchasable = json['purchasable'];
    totalSales = json['total_sales'];
    virtual = json['virtual'];
    downloadable = json['downloadable'];
//    if (json['downloads'] != null) {
//      downloads = new List<Null>();
//      json['downloads'].forEach((v) {
//        downloads.add(new Null.fromJson(v));
//      });
//    }
    downloadLimit = json['download_limit'];
    downloadExpiry = json['download_expiry'];
    downloadType = json['download_type'];
    externalUrl = json['external_url'];
    buttonText = json['button_text'];
    taxStatus = json['tax_status'];
    taxClass = json['tax_class'];
    manageStock = json['manage_stock'];
    stockQuantity = json['stock_quantity'];
    inStock = json['in_stock'];
    backorders = json['backorders'];
    backordersAllowed = json['backorders_allowed'];
    backOrdered = json['backordered'];
    soldIndividually = json['sold_individually'];
    weight = json['weight'];
    dimensions = json['dimensions'] != null
        ? new Dimensions.fromJson(json['dimensions'])
        : null;
    shippingRequired = json['shipping_required'];
    shippingTaxable = json['shipping_taxable'];
    shippingClass = json['shipping_class'];
    shippingClassId = json['shipping_class_id'];
    reviewsAllowed = json['reviews_allowed'];
    averageRating = json['average_rating'];
    ratingCount = json['rating_count'];
    relatedIds = json['related_ids'].cast<int>();
    upSellIds = json['upsell_ids'].cast<int>();
    crossSellIds = json['cross_sell_ids'].cast<int>();
    parentId = json['parent_id'];
    purchaseNote = json['purchase_note'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
//    if (json['tags'] != null) {
//      tags = new List<Null>();
//      json['tags'].forEach((v) {
//        tags.add(new Null.fromJson(v));
//      });
//    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(new Attributes.fromJson(v));
      });
    }

    // if (json['upsell_id'] != null) {
    //   upSellId = <UpsellId>[];
    //   json['upsell_id'].forEach((v) {
    //     upSellId.add(new UpsellId.fromJson(v));
    //   });
    // }
    menuOrder = json['menu_order'];
    isAddedCart = json['is_added_cart'];
    isAddedWishList = json['is_added_wishlist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['permalink'] = this.permalink;
    data['date_created'] = this.dateCreated;
    data['date_modified'] = this.dateModified;
    data['type'] = this.type;
    data['status'] = this.status;
    data['featured'] = this.featured;
    data['catalog_visibility'] = this.catalogVisibility;
    data['description'] = this.description;
    data['short_description'] = this.shortDescription;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['date_on_sale_from'] = this.dateOnSaleFrom;
    data['date_on_sale_to'] = this.dateOnSaleTo;
    data['price_html'] = this.priceHtml;
    data['on_sale'] = this.onSale;
    data['purchasable'] = this.purchasable;
    data['total_sales'] = this.totalSales;
    data['virtual'] = this.virtual;
    data['downloadable'] = this.downloadable;
//    if (this.downloads != null) {
//      data['downloads'] = this.downloads.map((v) => v.toJson()).toList();
//    }
    data['download_limit'] = this.downloadLimit;
    data['download_expiry'] = this.downloadExpiry;
    data['download_type'] = this.downloadType;
    data['external_url'] = this.externalUrl;
    data['button_text'] = this.buttonText;
    data['tax_status'] = this.taxStatus;
    data['tax_class'] = this.taxClass;
    data['manage_stock'] = this.manageStock;
    data['stock_quantity'] = this.stockQuantity;
    data['in_stock'] = this.inStock;
    data['backorders'] = this.backorders;
    data['backorders_allowed'] = this.backordersAllowed;
    data['backordered'] = this.backOrdered;
    data['sold_individually'] = this.soldIndividually;
    data['weight'] = this.weight;
    if (this.dimensions != null) {
      data['dimensions'] = this.dimensions!.toJson();
    }
    data['shipping_required'] = this.shippingRequired;
    data['shipping_taxable'] = this.shippingTaxable;
    data['shipping_class'] = this.shippingClass;
    data['shipping_class_id'] = this.shippingClassId;
    data['reviews_allowed'] = this.reviewsAllowed;
    data['average_rating'] = this.averageRating;
    data['rating_count'] = this.ratingCount;
    data['related_ids'] = this.relatedIds;
    data['upsell_ids'] = this.upSellIds;
    data['cross_sell_ids'] = this.crossSellIds;
    data['parent_id'] = this.parentId;
    data['purchase_note'] = this.purchaseNote;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
//    if (this.tags != null) {
//      data['tags'] = this.tags.map((v) => v.toJson()).toList();
//    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
//    if (this.defaultAttributes != null) {
//      data['default_attributes'] =
//          this.defaultAttributes.map((v) => v.toJson()).toList();
//    }
//    if (this.variations != null) {
//      data['variations'] = this.variations.map((v) => v.toJson()).toList();
//    }
//    if (this.groupedProducts != null) {
//      data['grouped_products'] =
//          this.groupedProducts.map((v) => v.toJson()).toList();
//    }
  /*  if (this.upSellId != null) {
      data['upsell_id'] = this.upSellId!.map((v) => v.toJson()).toList();
    }*/
    data['menu_order'] = this.menuOrder;
    data['is_added_cart'] = this.isAddedCart;
    data['is_added_wishlist'] = this.isAddedWishList;
    return data;
  }
}

class Dimensions {
  String? length;
  String? width;
  String? height;

  Dimensions({this.length, this.width, this.height});

  Dimensions.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? slug;

  Categories({this.id, this.name, this.slug});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Images {
  int? id;
  String? dateCreated;
  String? dateModified;
  String? src;
  String? name;
  String? alt;
  int? position;

  Images(
      {this.id,
      this.dateCreated,
      this.dateModified,
      this.src,
      this.name,
      this.alt,
      this.position});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateCreated = json['date_created'];
    dateModified = json['date_modified'];
    src = json['src'];
    name = json['name'];
    alt = json['alt'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date_created'] = this.dateCreated;
    data['date_modified'] = this.dateModified;
    data['src'] = this.src;
    data['name'] = this.name;
    data['alt'] = this.alt;
    data['position'] = this.position;
    return data;
  }
}

class Attributes {
  int? id;
  String? name;
  int? position;
  bool? visible;
  bool? variation;
  List<String>? options;

  Attributes(
      {this.id,
      this.name,
      this.position,
      this.visible,
      this.variation,
      this.options});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    visible = json['visible'];
    variation = json['variation'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['position'] = this.position;
    data['visible'] = this.visible;
    data['variation'] = this.variation;
    data['options'] = this.options;
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

class VendorResponse {
    Address? address;
    String? banner;
    int? bannerId;
    bool? enabled;
    bool? featured;
    String? firstName;
    String? avatar;
    int? avatarId;
    int? id;
    String? lastName;
    String? location;
    String? payment;
    String? phone;
    int? productsPerPage;
    Rating? rating;
    String? registered;
    String? shopUrl;
    bool? showEmail;
    bool? showMoreProductTab;
    Social? social;
    String? storeName;
    StoreOpenClose? storeOpenClose;
    String? storeToc;
    bool? tocEnabled;
    bool? trusted;

    VendorResponse({this.address, this.banner, this.bannerId, this.enabled, this.featured, this.firstName, this.avatar, this.avatarId, this.id, this.lastName, this.location, this.payment, this.phone, this.productsPerPage, this.rating, this.registered, this.shopUrl, this.showEmail, this.showMoreProductTab, this.social, this.storeName, this.storeOpenClose, this.storeToc, this.tocEnabled, this.trusted});

    factory VendorResponse.fromJson(Map<String, dynamic> json) {
        return VendorResponse(
            address: json['address'] != null ? Address.fromJson(json['address']) : null, 
           banner: json['banner'],
            bannerId: json['banner_id'], 
            enabled: json['enabled'], 
            featured: json['featured'], 
            firstName: json['first_name'], 
            avatar: json['gravatar'], 
            avatarId: json['gravatar_id'], 
            id: json['id'], 
            lastName: json['last_name'], 
            location: json['location'], 
            payment: json['payment'], 
            phone: json['phone'], 
            productsPerPage: json['products_per_page'], 
            rating: json['rating'] != null ? Rating.fromJson(json['rating']) : null, 
            registered: json['registered'], 
            shopUrl: json['shop_url'], 
            showEmail: json['show_email'], 
            showMoreProductTab: json['show_more_product_tab'], 
            social: json['social'] != null ? Social.fromJson(json['social']) : null, 
            storeName: json['store_name'], 
            storeOpenClose: json['store_open_close'] != null ? StoreOpenClose.fromJson(json['store_open_close']) : null, 
            storeToc: json['store_toc'], 
            tocEnabled: json['toc_enabled'], 
            trusted: json['trusted'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['banner'] = this.banner;
        data['banner_id'] = this.bannerId;
        data['enabled'] = this.enabled;
        data['featured'] = this.featured;
        data['first_name'] = this.firstName;
        data['gravatar'] = this.avatar;
        data['gravatar_id'] = this.avatarId;
        data['id'] = this.id;
        data['last_name'] = this.lastName;
        data['location'] = this.location;
        data['payment'] = this.payment;
        data['phone'] = this.phone;
        data['products_per_page'] = this.productsPerPage;
        data['registered'] = this.registered;
        data['shop_url'] = this.shopUrl;
        data['show_email'] = this.showEmail;
        data['show_more_product_tab'] = this.showMoreProductTab;
        data['store_name'] = this.storeName;
        data['store_toc'] = this.storeToc;
        data['toc_enabled'] = this.tocEnabled;
        data['trusted'] = this.trusted;
        if (this.address != null) {
            data['address'] = this.address!.toJson();
        }
        if (this.rating != null) {
            data['rating'] = this.rating!.toJson();
        }
        if (this.social != null) {
            data['social'] = this.social!.toJson();
        }
        if (this.storeOpenClose != null) {
            data['store_open_close'] = this.storeOpenClose!.toJson();
        }
        return data;
    }
}

class Rating {
    int? count;
    String? rating;

    Rating({this.count, this.rating});

    factory Rating.fromJson(Map<String, dynamic> json) {
        return Rating(
            count: json['count'], 
            rating: json['rating'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['count'] = this.count;
        data['rating'] = this.rating;
        return data;
    }
}

class StoreOpenClose {
    String? closeNotice;
    bool? enabled;
    String? openNotice;

    StoreOpenClose({this.closeNotice, this.enabled, this.openNotice});

    factory StoreOpenClose.fromJson(Map<String, dynamic> json) {
        return StoreOpenClose(
            closeNotice: json['close_notice'], 
            enabled: json['enabled'], 
            openNotice: json['open_notice'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['close_notice'] = this.closeNotice;
        data['enabled'] = this.enabled;
        data['open_notice'] = this.openNotice;
        return data;
    }
}

class Social {
    String? fb;
    String? flicker;
    String? gPlus;
    String? instagram;
    String? linkDin;
    String? pinterest;
    String? twitter;
    String? youtube;

    Social({this.fb, this.flicker, this.gPlus, this.instagram, this.linkDin, this.pinterest, this.twitter, this.youtube});

    factory Social.fromJson(Map<String, dynamic> json) {
        return Social(
            fb: json['fb'], 
            flicker: json['flickr'], 
            gPlus: json['gplus'], 
            instagram: json['instagram'], 
            linkDin: json['linkedin'], 
            pinterest: json['pinterest'],
            twitter: json['twitter'], 
            youtube: json['youtube'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['fb'] = this.fb;
        data['flickr'] = this.flicker;
        data['gplus'] = this.gPlus;
        data['instagram'] = this.instagram;
        data['linkedin'] = this.linkDin;
        data['pinterest'] = this.pinterest;
        data['twitter'] = this.twitter;
        data['youtube'] = this.youtube;
        return data;
    }
}