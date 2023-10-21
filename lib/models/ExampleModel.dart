import '/../utils/AppImages.dart';

class ExampleModel {
  final String title;
  final String url;
  final String consumerKey;
  final String consumerSecret;
  final String primaryColor;
  final String img;

  ExampleModel(this.title, this.url, this.consumerKey, this.consumerSecret, this.primaryColor, this.img);
}

List<ExampleModel> mExampleList = [
  ExampleModel("Default", "https://meetmighty.com/mobile/mightystore/wp-json/", "ck_035956c26811892f2504f67224e5d3af9a4840c4", "cs_e14522a17c14e8c6ed74426ffe03505bb9628ede", "#4358DD", ic_dashBoard_variant_1),
  ExampleModel("Grocery Store", "https://meetmighty.com/mobile/mightygrocery/wp-json/", "ck_8539e9b3c3d0d9421bd7f78d2fc3e81308c6280f", "cs_5af6894375a069ea109624ebfa70704c32061d79", "#5F9F0D", ic_dashBoard_variant_2),
  ExampleModel("Health Nutrition", "https://meetmighty.com/mobile/health-nutrition/wp-json/", "ck_a37e1e0bce7c4c396f9de2c49694c8e45d9a0735", "cs_bd607cb0c2936c8611d33153be31c234899e6f55", "#D50D56", ic_dashBoard_variant_3),
  ExampleModel("Watch Store", "https://meetmighty.com/mobile/smartwatch/wp-json/", "ck_976c28e62b5a3263c3d47cfd3adc4e2ce7bee5ae", "cs_b1b46ecc9dd856e61854f0f2981e93d0b6c9f903", "#ab978e", ic_dashBoard_variant_7),
  ExampleModel("Mobile Cover", "https://meetmighty.com/mobile/mobile-cover/wp-json/", "ck_e2ecde165e5b00eeb59b63debf634d256ce3e75e", "cs_6591d78e75cf58b434aa2650c3adfab0953d56b2", "#2d4026", ic_dashBoard_variant_6),
  ExampleModel("Energy Drink", "https://meetmighty.com/mobile/energy-drink/wp-json/", "ck_0b97d5272edef3d2050c899bc2371b567dae6cdb", "cs_84159ee279847e3a4809d9c323be5e802d7f0abb", "#2B256F", ic_dashBoard_variant_5),
  ExampleModel("Pharmacy", "https://meetmighty.com/mobile/mightypharmacy/wp-json/", "ck_1bb8981890525ff4dadd4ab7d294a33df3c1a887", "cs_d6732475bfcf0d82d17af8ebaa4fb7da68afa753", "#0d3f66", ic_dashBoard_variant_4),
  ExampleModel("Cycle Store", "https://meetmighty.com/mobile/cycle-store/wp-json/", "ck_f42a347680a78fdbb46e7202f0c0b94e400b336f", "cs_c7f08b0308f7708606a0fc6a5cef4e4f626638d5", "#080808", ic_dashBoard_variant_8),

];
