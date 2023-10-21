class BuilderResponse {
  Dashboard? dashboard;
  Appsetup? appsetup;

  BuilderResponse({this.dashboard, this.appsetup});

  BuilderResponse.fromJson(Map<String, dynamic> json) {
    dashboard = json['dashboard'] != null ? new Dashboard.fromJson(json['dashboard']) : null;
    appsetup = json['appsetup'] != null ? new Appsetup.fromJson(json['appsetup']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dashboard != null) {
      data['dashboard'] = this.dashboard!.toJson();
    }
    if (this.appsetup != null) {
      data['appsetup'] = this.appsetup!.toJson();
    }
    return data;
  }
}

class Dashboard {
  List<String>? sorting;
  String? layout;
  AppBar? appBar;
  SliderView? sliderView;
  SliderView? category;
  NewProduct? newProduct;
  NewProduct? featureProduct;
  NewProduct? saleProduct;
  NewProduct? dealOfTheDay;
  NewProduct? bestSaleProduct;
  NewProduct? offerProduct;
  NewProduct? suggestionProduct;
  NewProduct? vendor;
  NewProduct? youMayLikeProduct;
  NewProduct? blog;
  SliderView? saleBanner;

  Dashboard(
      {this.sorting,
      this.layout,
      this.appBar,
      this.sliderView,
      this.category,
      this.newProduct,
      this.featureProduct,
      this.saleProduct,
      this.dealOfTheDay,
      this.bestSaleProduct,
      this.offerProduct,
      this.suggestionProduct,
      this.vendor,
      this.youMayLikeProduct,
      this.blog,
      this.saleBanner});

  Dashboard.fromJson(Map<String, dynamic> json) {
    sorting = json['sorting'].cast<String>();
    layout = json['layout'];
    appBar = json['appBar'] != null ? new AppBar.fromJson(json['appBar']) : null;
    sliderView = json['sliderView'] != null ? new SliderView.fromJson(json['sliderView']) : null;
    category = json['category'] != null ? new SliderView.fromJson(json['category']) : null;
    newProduct = json['newProduct'] != null ? new NewProduct.fromJson(json['newProduct']) : null;
    featureProduct = json['feature'] != null ? new NewProduct.fromJson(json['feature']) : null;
    saleProduct = json['saleProduct'] != null ? new NewProduct.fromJson(json['saleProduct']) : null;
    dealOfTheDay = json['dealOfTheDay'] != null ? new NewProduct.fromJson(json['dealOfTheDay']) : null;
    bestSaleProduct = json['bestSaleProduct'] != null ? new NewProduct.fromJson(json['bestSaleProduct']) : null;
    offerProduct = json['offerProduct'] != null ? new NewProduct.fromJson(json['offerProduct']) : null;
    suggestionProduct = json['suggestionProduct'] != null ? new NewProduct.fromJson(json['suggestionProduct']) : null;
    vendor = json['vendor'] != null ? new NewProduct.fromJson(json['vendor']) : null;
    youMayLikeProduct = json['youMayLikeProduct'] != null ? new NewProduct.fromJson(json['youMayLikeProduct']) : null;
    blog = json['blog'] != null ? new NewProduct.fromJson(json['blog']) : null;
    saleBanner = json['saleBanner'] != null ? new SliderView.fromJson(json['saleBanner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sorting'] = this.sorting;
    data['layout'] = this.layout;
    if (this.appBar != null) {
      data['appBar'] = this.appBar!.toJson();
    }
    if (this.sliderView != null) {
      data['sliderView'] = this.sliderView!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.newProduct != null) {
      data['newProduct'] = this.newProduct!.toJson();
    }
    if (this.featureProduct != null) {
      data['feature'] = this.featureProduct!.toJson();
    }
    if (this.saleProduct != null) {
      data['saleProduct'] = this.saleProduct!.toJson();
    }
    if (this.dealOfTheDay != null) {
      data['dealOfTheDay'] = this.dealOfTheDay!.toJson();
    }
    if (this.bestSaleProduct != null) {
      data['bestSaleProduct'] = this.bestSaleProduct!.toJson();
    }
    if (this.offerProduct != null) {
      data['offerProduct'] = this.offerProduct!.toJson();
    }
    if (this.suggestionProduct != null) {
      data['suggestionProduct'] = this.suggestionProduct!.toJson();
    }
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    if (this.youMayLikeProduct != null) {
      data['youMayLikeProduct'] = this.youMayLikeProduct!.toJson();
    }
    if (this.blog != null) {
      data['blog'] = this.blog!.toJson();
    }
    return data;
  }
}

class AppBar {
  String? title;
  Null appBarIcon;
  Null appBarLayout;

  AppBar({this.title, this.appBarIcon, this.appBarLayout});

  AppBar.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    appBarIcon = json['appBarIcon'];
    appBarLayout = json['appBarLayout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['appBarIcon'] = this.appBarIcon;
    data['appBarLayout'] = this.appBarLayout;
    return data;
  }
}

class SliderView {
  bool? enable;

  SliderView({this.enable});

  SliderView.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enable'] = this.enable;
    return data;
  }
}

class NewProduct {
  bool? enable;
  String? title;
  String? viewAll;

  NewProduct({this.enable, this.title, this.viewAll});

  NewProduct.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    title = json['title'];
    viewAll = json['viewAll'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enable'] = this.enable;
    data['title'] = this.title;
    data['viewAll'] = this.viewAll;
    return data;
  }
}

class Productdetailview {
  String? layout;

  Productdetailview({this.layout});

  Productdetailview.fromJson(Map<String, dynamic> json) {
    layout = json['layout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['layout'] = this.layout;
    return data;
  }
}

class Appsetup {
  String? appName;
  String? primaryColor;
  String? secondaryColor;
  String? backgroundColor;
  String? textPrimaryColor;
  String? textSecondaryColor;
  String? consumerKey;
  String? consumerSecret;
  String? appUrl;

  Appsetup({this.appName, this.primaryColor, this.secondaryColor, this.backgroundColor, this.textPrimaryColor, this.textSecondaryColor, this.consumerKey, this.consumerSecret, this.appUrl});

  Appsetup.fromJson(Map<String, dynamic> json) {
    appName = json['appName'];
    primaryColor = json['primaryColor'];
    secondaryColor = json['secondaryColor'];
    backgroundColor = json['backgroundColor'];
    textPrimaryColor = json['textPrimaryColor'];
    textSecondaryColor = json['textSecondaryColor'];
    consumerKey = json['consumerKey'];
    consumerSecret = json['consumerSecret'];
    appUrl = json['appUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appName'] = this.appName;
    data['primaryColor'] = this.primaryColor;
    data['secondaryColor'] = this.secondaryColor;
    data['backgroundColor'] = this.backgroundColor;
    data['textPrimaryColor'] = this.textPrimaryColor;
    data['textSecondaryColor'] = this.textSecondaryColor;
    data['consumerKey'] = this.consumerKey;
    data['consumerSecret'] = this.consumerSecret;
    data['appUrl'] = this.appUrl;
    return data;
  }
}
