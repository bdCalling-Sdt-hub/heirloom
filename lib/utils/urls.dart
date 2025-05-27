class Urls {

  // Auth Endpoints
  static const String signUp = '/auth/register';

  static const String login = '/auth/login';

  static const String forgetPass = '/auth/forget-password';
  static const String changePass = '/auth/change-password';

  static const String otpVerify = '/auth/verify-otp';
  static  String forgetOtpVerify(String email) =>'/user/verify-forget-otp?email=$email';
  static  String otpResend(String email) => '/auth/resend-otp?email=$email';

  static String updateUser(String userId) => '/users/$userId';

  static String deleteUser(String userId) => '/auth/account-delete?id=$userId';

  static const String resetPass= '/auth/reset-password';


//privacy,about,terms
  static  String appData(String type) => '/$type';




//common
  static const String getProfile = '/auth/my-profile';
  static const String updateProfile = '/auth/profile-update';

//notification

  static const String notification = '/notification';
  static const String notificationBadge = '/notification/badge-count';


//journal
  static const String getJournal = '/journals/get';
  static const String addJournal = '/journals/add';
  static const String enhanceJournal = '/ai/enhance';
  static String deleteJournal(String journalId) => '/journals/delete/$journalId';
  static String updateJournal(String journalId) => '/journals/edit/$journalId';


  //relation chat
  static  String getConversationList (String limit,page) =>  '/message/get/conversations?limit=$limit&page=$page';
  static  String getMessages (String conversationId,limit,page) =>  '/message/$conversationId';

}
