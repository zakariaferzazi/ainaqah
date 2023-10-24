import 'package:nb_utils/nb_utils.dart';

const AppName = 'Ainaqah';

///OneSignalAppID
const mOneSignalAPPKey = '48a4609a-bd27-4df8-9ebd-dc83d1f13992';

///ADMob Id
const bannerAdIdForAndroid = "";
const bannerAdIdForIos = "";
const InterstitialAdIdForAndroid = "";
const interstitialAdIdForIos = "";

/// PAYMENT METHOD ENABLE/DISABLE
const IS_STRIPE = false;
const IS_RAZORPAY = false;
const IS_PAY_STACK = false;
const IS_FLUTTER_WAVE = false;
const IS_PAY_FROM_WALLET = false;

///RazorPay
const razorKey = "rzp_test_CLw7tH3O3P5eQM";

///StripPayment
const stripPaymentKey =
    'sk_test_51GrhA2Bz1ljKAgF9FIJPLupBUCHFCOy5rS6LCnYHSu6Od0Qyx3TElGbxIu8BGRvq14fgidGOYyNkQPivZGnzWoVt004fCZxVdk';
const stripPaymentPublishKey =
    'pk_test_51GrhA2Bz1ljKAgF98fI6WfB2YUn4CewOB0DNQC1pSeXspUc1LlUYs3ou19oPF0ATcqa52FXTYmv6v0mkvPZb9BSD00SUpBj9tI';
const merchantId = "YOUR_App_Identifier";

///FlutterWave
const flutterWavePublicKey = 'FLWPUBK_TEST-eb3edef083c890a7e22dc7eec9e0daa5-X';
const flutterWaveSecretKey = 'FLWSECK_TEST-d2759023efce6198a853b8e2dd3beb55-X';
const flutterWaveEncryptionKey = 'FLWSECK_TEST8497cc2db86c';

///PAY STACK DETAIL
const payStackPublicKey = 'pk_test_c46ddf9def17e34152daa1b6e2eb940dedea41f0';

///Terms&Condition
const TERMS_CONDITION_URL = "https://zakaria.top/privacy-policy.html";
const PRIVACY_POLICY_URL = "https://zakaria.top/privacy-policy.html";

/// SharedPreferences Keys
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const IS_SOCIAL_LOGIN = 'IS_SOCIAL_LOGIN';
const IS_GUEST_USER = 'IS_GUEST_USER';
const THEME_COLOR = 'THEME_COLOR';
const DASHBOARD_DATA = 'DASHBOARD_DATA';
const SLIDER_DATA = 'SLIDER_DATA';
const CROSS_AXIS_COUNT = 'CROSS_AXIS_COUNT';
const CATEGORY_CROSS_AXIS_COUNT = 'CATEGORY_CROSS_AXIS_COUNT';
const msg = 'message';
const CART_DATA = 'CART_DATA';
const WISH_LIST_DATA = 'WISH_LIST_DATA';
const GUEST_USER_DATA = 'GUEST_USER_DATA';
const TOKEN = 'TOKEN';
const USERNAME = 'USERNAME';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_DISPLAY_NAME = 'USER_DISPLAY_NAME';
const USER_ID = 'USER_ID';
const USER_EMAIL = 'USER_EMAIL';
const USER_ROLE = 'USER_ROLE';
const AVATAR = 'AVATAR';
const PASSWORD = 'PASSWORD';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const BILLING = 'BILLING';
const SHIPPING = 'SHIPPING';
const COUNTRIES = 'COUNTRIES';
const LANGUAGE = 'LANGUAGE';
const CARTCOUNT = 'CARTCOUNT';
const WHATSAPP = 'WHATSAPP';
const FACEBOOK = 'FACEBOOK';
const TWITTER = 'TWITTER';
const INSTAGRAM = 'INSTAGRAM';
const CONTACT = 'CONTACT';
const PRIVACY_POLICY = 'PRIVACY_POLICY';
const TERMS_AND_CONDITIONS = 'TERMS_AND_CONDITIONS';
const COPYRIGHT_TEXT = 'COPYRIGHT_TEXT';
const PAYMENTMETHOD = 'PAYMENTMETHOD';
const ENABLECOUPON = 'ENABLECOUPON';
const PAYMENT_METHOD_NATIVE = "native";
const DEFAULT_CURRENCY = 'DEFAULT_CURRENCY';
const CURRENCY_CODE = 'CURRENCY_CODE';
const IS_NOTIFICATION_ON = "IS_NOTIFICATION_ON";
const DETAIL_PAGE_VARIANT = 'DetailPageVariant';
const IS_REMEMBERED = "IS_REMEMBERED";
const IS_DOKAN_ACTIVE = 'IS_DOKAN_ACTIVE';
const PLAYER_ID = 'PLAYER_ID';
const WALLET = 'WALLET';

//Start AppSetup
const APP_NAME = 'appName';
const PRIMARY_COLOR = 'primaryColor';
const SECONDARY_COLOR = 'secondaryColor';
const TEXT_PRIMARY_COLOR = 'textPrimaryColor';
const TEXT_SECONDARY_COLOR = 'textSecondaryColor';
const BACKGROUND_COLOR = 'backgroundColor';
const CONSUMER_KEY = 'ck_8138d831c5e08bffab3eb98d6f4b768697267022';
const CONSUMER_SECRET = 'cs_f109ae5f25e905e763d6d6b13157e31370d67b16';
const APP_URL = 'https://ainaqah.com/wp-json/';
//End AppSetup

//Date Format
const orderDateFormat = 'dd-MM-yyyy';
const reviewDateFormat = 'dd MMM yy  hh:mm a';
const CreateDateFormat = 'MMM dd, yyyy';

const accessAllowed = true;
const demoPurposeMsg = 'This action is not allowed in demo app.';

const COMPLETED = "completed";
const REFUNDED = "refunded";
const CANCELED = "cancelled";
const TRASH = "trash";
const FAILED = "failed";
const SUCCESS = 'Success';

/* Theme Mode Type */
const ThemeModeLight = 0;
const ThemeModeDark = 1;
const ThemeModeSystem = 2;

const defaultLanguage = 'en';

const VideoTypeCustom = 'custom_url';
const VideoTypeYouTube = 'youtube';
const VideoTypeIFrame = 'iframe';

const enableSignWithGoogle = true;
const enableSignWithApple = true;
const enableSignWithOtp = true;
const enableSocialSign = true;
const enableAdsLoading = true;
const enableAds = true;

const enableBlog = true;
const enableMultiDemo = true;
const enableDashboardVariant = true;

bool get enableTeraWallet => getBoolAsync(WALLET);

// Set per page item
const TOTAL_ITEM_PER_PAGE = 50;
const TOTAL_CATEGORY_PER_PAGE = 50;
const TOTAL_SUB_CATEGORY_PER_PAGE = 50;
const TOTAL_DASHBOARD_ITEM = 4;
const TOTAL_BLOG_ITEM = 6;

const WISHLIST_ITEM_LIST = 'WISHLIST_ITEM_LIST';
const CART_ITEM_LIST = 'CART_ITEM_LIST';

const DASHBOARD_PAGE_VARIANT = 'DashboardPageVariant';
const PRODUCT_DETAIL_VARIANT = 'ProductDetailVariant';

const streamRefresh = "streamRefresh";

// Set theme
bool get isHalloween => getBoolAsync(HALLOWEEN_ENABLE);
const HALLOWEEN_ENABLE = 'halloween_enable';

// Halloween Theme
const base_URL = "https://ainaqah.com/wp-json/";
const consumerKey = "ck_8138d831c5e08bffab3eb98d6f4b768697267022";
const consumerSecret = "cs_f109ae5f25e905e763d6d6b13157e31370d67b16";
