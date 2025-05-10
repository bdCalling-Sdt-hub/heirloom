class Urls {

  // Auth Endpoints
  static const String signUp = '/v1/auth/register';

  static const String login = '/v1/auth/login';

  static const String forgetPass = '/v1/auth/forgot-password';
  static const String changePass = '/v1/auth/change-password';

  static const String otpVerify = '/v1/auth/verify-email';
  static  String forgetOtpVerify(String email) =>'/user/verify-forget-otp?email=$email';
  static const String otpResend= '/v1/auth/resend-otp';

  static String updateUser(String userId) => '/users/$userId';

  static String deleteUser(String userId) => '/v1/users/$userId';

  static const String resetPass= '/v1/auth/reset-password';


 //App data
  static const String privacy = '/privacy';
  static const String terms = '/terms';
  static const String about = '/about';
  static  String appData(String type) => '/v1/$type/';




//common
  static const String getProfile = '/v1/users';
  static const String updateProfile = '/v1/users';
  static const String getActivityDetails = '/v1/deals/redeem-history';


  static const String notification = '/notification';
  static const String notificationBadge = '/notification/badge-count';
  static const String payments = '/purchase';

//home
  static const String getHomeDeals = '/v1/deals/homepage-deals';
  static const String exploreHomeDeals = '/v1/category/all';
  static  String productDetails(String productId) => '/v1/deals/get-deals/$productId';
  static  String toggleFavorite(String productId) => '/v1/deals/favourite/$productId';
  static  String redeemDeal(String productId) => '/v1/deals/redeem/$productId';
  static  String staffConfirm(String productId) => '/v1/deals/staff-member-confirm/$productId';
  static  String dealsByCategory(String categoryId) => '/v1/deals/category/$categoryId';

//favourite
  static const String getFavouriteDeals = '/v1/deals/user/favourites';

  //explore
  static const String exploreTrendingPlaces = '/v1/trending-places/getAll';

  //profile
  static const String savedMoney = '/v1/users/total-save';

  //coupon
  static const String getAllCoupons = '/v1/users/coupon/getAll';

}
