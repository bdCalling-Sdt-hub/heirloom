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
  static  String getConversationMedia (String conversationId,limit,page) =>  '/message/media/$conversationId?limit=$limit&page=$page';
  static  String getConversationListSearch (String search) =>  '/message/get/conversations?searchQ=$search';
  static  String getMessages (String conversationId,limit,page) =>  '/message/$conversationId?limit=$limit&page=$page';
  static const String sendMessage = '/message/send';
  static const String changeAiMode = '/message/aimode';
  static  String report (String receiverId)=> '/report/add/$receiverId';
  static  String unfriend (String receiverId)=> '/friend/unfriend/$receiverId';


  //friend
  static  String getUserList (String conversationId,limit,page) =>  '/common/pepole?limit=$limit&page=$page';
  static  String getUserListSearch (String conversationId,limit,page,search) =>  '/common/pepole?searchQ=$search&limit=$limit&page=$page';
  static const String friendRequest = '/friend/request';


  //family members

  static  String getFamilyRequest (String type,limit,page) =>  '/friend/request?relation=$type&limit=$limit&page=$page';
  static const String relationList = "/friend/list?relation=friend";
  static  String searchRelationList (String search)=> "/friend/list?relation=friend&searchQ=$search";
  static const String updateRelationship = "/friend/request";

  // requested
  static  String getRequest (String relation,limit,page) =>  '/friend/request?relation=$relation&limit=$limit&page=$page';
  static  String actionRequest (String id,status) =>  '/friend/action/$id?status=$status';


  //legacy message
  static  String getLegacyMessage (String limit,page) =>  '/legacy?page=$page&limit=$limit';
  static const String addLegacy = '/legacy/add';
  static const String getFriends = "/friend/list";
  static  String legacyEdit (String legacyId) =>  '/legacy/edit/$legacyId';
  static  String legacyView (String limit,page) =>  '/legacy/triggered?page=$page&limit=$limit';
  static  String deleteLegacy (String legacyId) =>  '/legacy/delete/$legacyId';

}
