class WalletConfigurationResponse {
  String? productTitle;
  String? productImage;
  String? minTopupAmount;
  String? maxTopupAmount;
  String? primary;
  String? topLeft;
  String? footer;
  String? isAutoDeductForPartialPayment;
  String? isEnableWalletTransfer;
  String? minTransferAmount;
  String? transferChargeType;
  String? transferChargeAmount;
  String? cod;
  String? razorpay;

  WalletConfigurationResponse(
      {this.productTitle,
        this.productImage,
        this.minTopupAmount,
        this.maxTopupAmount,
        this.primary,
        this.topLeft,
        this.footer,
        this.isAutoDeductForPartialPayment,
        this.isEnableWalletTransfer,
        this.minTransferAmount,
        this.transferChargeType,
        this.transferChargeAmount,
        this.cod,
        this.razorpay});
}
