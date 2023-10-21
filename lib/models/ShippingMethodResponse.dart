class ShippingMethodResponse {
  Data? data;
  int? status;

  ShippingMethodResponse({this.data, this.status});

  ShippingMethodResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
  }
}

class Data {
  String? message;
  List<Method>? methods;

  Data({this.message, this.methods});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['methods'] != null) {
      methods = <Method>[];
      json['methods'].forEach((v) {
        methods!.add(new Method.fromJson(v));
      });
    }
  }
}

class Method {
  String? id;
  String? minAmount;
  String? requires;
  String? methodTitle;
  String? methodDescription;
  String? enabled;
  String? title;
  String? taxStatus;
  String? cost;
  String? type;
  int? methodOrder;
  InstanceSettings? instanceSettings;

  Method({this.id, this.minAmount, this.requires, this.methodTitle, this.methodDescription, this.enabled, this.title, this.taxStatus, this.cost, this.type, this.methodOrder, this.instanceSettings});

  factory Method.fromJson(Map<String, dynamic> json) {
    return Method(
        id: json['id'],
        minAmount: json['min_amount'],
        requires: json['requires'],
        methodTitle: json['method_title'],
        methodDescription: json['method_description'],
        enabled: json['enabled'],
        title: json['title'],
        taxStatus: json['tax_status'],
        cost: json['cost'],
        type: json['type'],
        methodOrder: json['method_order'],
        instanceSettings: json['instance_settings'] != null ? InstanceSettings.fromJson(json['instance_settings']) : null);
  }
}

class InstanceSettings {
  String? title;
  String? requires;
  String? minAmount;
  String? ignoreDiscounts;

  InstanceSettings({this.title, this.requires, this.minAmount, this.ignoreDiscounts});

  factory InstanceSettings.fromJson(Map<String, dynamic> json) {
    return InstanceSettings(
      title: json['title'],
      requires: json['requires'],
      minAmount: json['min_amount'],
      ignoreDiscounts: json['ignore_discounts'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['requires'] = this.requires;
    data['min_amount'] = this.minAmount;
    data['ignore_discounts'] = this.ignoreDiscounts;
    return data;
  }
}
