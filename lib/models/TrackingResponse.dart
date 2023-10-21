import '/../models/CategoryData.dart';

class TrackingResponse {
  String? trackingId;
  String? trackingProvider;
  String? trackingLink;
  String? trackingNumber;
  String? dateShipped;
  Links? lLinks;

  TrackingResponse(
      {this.trackingId,
        this.trackingProvider,
        this.trackingLink,
        this.trackingNumber,
        this.dateShipped,
        this.lLinks});

  TrackingResponse.fromJson(Map<String, dynamic> json) {
    trackingId = json['tracking_id'];
    trackingProvider = json['tracking_provider'];
    trackingLink = json['tracking_link'];
    trackingNumber = json['tracking_number'];
    dateShipped = json['date_shipped'];
    lLinks = json['_links'] != null ? new Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tracking_id'] = this.trackingId;
    data['tracking_provider'] = this.trackingProvider;
    data['tracking_link'] = this.trackingLink;
    data['tracking_number'] = this.trackingNumber;
    data['date_shipped'] = this.dateShipped;
    if (this.lLinks != null) {
      data['_links'] = this.lLinks!.toJson();
    }
    return data;
  }
}

class Links {
  List<Self>? self;
  List<Collection>? collection;
  List<Up>? up;

  Links({this.self, this.collection, this.up});

  Links.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = <Self>[];
      json['self'].forEach((v) {
        self!.add(new Self.fromJson(v));
      });
    }
    if (json['collection'] != null) {
      collection = <Collection>[];
      json['collection'].forEach((v) {
        collection!.add(new Collection.fromJson(v));
      });
    }
    if (json['up'] != null) {
      up = <Up>[];
      json['up'].forEach((v) {
        up!.add(new Up.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.self != null) {
      data['self'] = this.self!.map((v) => v.toJson()).toList();
    }
    if (this.collection != null) {
      data['collection'] = this.collection!.map((v) => v.toJson()).toList();
    }
    if (this.up != null) {
      data['up'] = this.up!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Self {
  String? href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}
