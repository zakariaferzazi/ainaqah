class PaymentClass {
  String? paymentMethod;
  int? paymentIndex;
  String? image;
  String? account;
  bool isSelected;

  PaymentClass(
      {this.paymentMethod, this.paymentIndex, this.isSelected = false, this.image, this.account});
}
