class AddWalletResponse {
  bool? status;
  String? woocommerceRedirect;

  AddWalletResponse({this.status, this.woocommerceRedirect});

  AddWalletResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    woocommerceRedirect = json['woocommerce_redirect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['woocommerce_redirect'] = this.woocommerceRedirect;
    return data;
  }
}
