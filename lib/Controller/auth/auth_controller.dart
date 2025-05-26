
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../global_widgets/toaster.dart';
import '../../helpers/prefs_helper.dart';
import '../../routes/app_routes.dart';
import '../../services/api_client.dart';
import '../../utils/app_constant.dart';
import '../../utils/urls.dart';
import '../../views/auth/otp_verification_screen.dart';

class AuthController extends GetxController {

  RxBool signUpLoading = false.obs;

  ///===============Sing up ================<>
  handleSignUp(String email,password,name,gender) async {
    signUpLoading(true);
    var body = {
      "username": name.toString(),
      "email": email.toString(),
      "password": password.toString(),
      "gender": gender.toString()
    };
print("=================================$body");
    var response = await ApiClient.postData(
      Urls.signUp,
      body,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("==========bearer token save done : ${response.body['data']['token']}");
      PrefsHelper.setString(AppConstants.bearerToken, response.body['data']['token']);
      Get.to(()=>OtpVerificationScreen(email: email,isFormForget: false,));
      ToastMessageHelper.successMessageShowToster(response.body["message"]);

      signUpLoading(false);
    } else {
      ToastMessageHelper.errorMessageShowToster(response.body["message"]);
      signUpLoading(false);
    }
  }

  ///************************************************************************///

  ///===============Verify Otp================<>
  RxBool verifyLoading = false.obs;

  verifyOtp(String otpCode,bool isFormForget) async {
    verifyLoading(true);
    var body = {"otp": otpCode.toString()};
print("==================================$body");
    var response = await ApiClient.postData(
        Urls.otpVerify, body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.successMessageShowToster("${response.body["message"]}");
      debugPrint("==========bearer token save done : ${response.body['token']}");
      await PrefsHelper.setString(AppConstants.bearerToken, response.body['data']['token']);
      if (isFormForget) {
        Get.toNamed(AppRoutes.resetPassScreen);
      } else {
        Get.toNamed(AppRoutes.selectAgeScreen);
      }
      verifyLoading(false);
    }else {
      ToastMessageHelper.errorMessageShowToster("${response.body["message"]}");
      verifyLoading(false);
    }
  }


  ///===============Resend================<>
  RxBool resendLoading = false.obs;

  reSendOtp(String email) async {
    resendLoading(true);
    var body = {};
    var response = await ApiClient.postData(
        Urls.otpResend(email), body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.successMessageShowToster("${response.body["message"]}");
      await PrefsHelper.setString(AppConstants.bearerToken, response.body['data']['token']);

      resendLoading(false);
    }else{
      ToastMessageHelper.errorMessageShowToster("${response.body["message"]}");
      resendLoading(false);
    }
  }


  ///************************************************************************///
  ///===============Log in================<>
  RxBool logInLoading = false.obs;
  handleLogIn(String email, String password) async {

    logInLoading.value = true;
    var body = {
      "email": email,
      "password": password,
    };
    var response = await ApiClient.postData(
        Urls.login, body,);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.successMessageShowToster(response.body['message']);
       PrefsHelper.setString(AppConstants.bearerToken, response.body['data']['token']);
       PrefsHelper.setString(AppConstants.userId, response.body['data']['user']['_id']);
      PrefsHelper.setString(AppConstants.isLogged, "true");
      Get.offAllNamed(AppRoutes.customNavBar);

      logInLoading(false);}

  else{


      logInLoading(false);
      ToastMessageHelper.errorMessageShowToster(response.body['message']);
    }
  }

  ///************************************************************************///

  ///===============Forgot Password================<>
  RxBool forgotLoading = false.obs;

  handleForgot(String email,) async {
    forgotLoading(true);
    var body = {"email": email};

    var response = await ApiClient.postData(
        Urls.forgetPass, body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      await PrefsHelper.setString(AppConstants.bearerToken, response.body['data']['token']);
      ToastMessageHelper.successMessageShowToster(response.body['message']);
      Get.to(OtpVerificationScreen(
        isFormForget: true,
      ));
      forgotLoading(false);
    }  else {
      ToastMessageHelper.errorMessageShowToster(response.body['message']);
      forgotLoading(false);
    }
  }
  ///===============Change Password================<>

  RxBool changePasswordLoading = false.obs;

  changePassword(String oldPassword,newPassword,confirmPassword) async {
    changePasswordLoading(true);
    var body = {

      "oldPassword": oldPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };

    var response = await ApiClient.postData(
        Urls.changePass, body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.offAllNamed(AppRoutes.customNavBar);
      ToastMessageHelper.successMessageShowToster(response.body['message']);

      changePasswordLoading(false);
    } else {
      changePasswordLoading(false);
    }
  }




  ///===============Set Password================<>
  RxBool setPasswordLoading = false.obs;
  resetPassword(String password,) async {
    setPasswordLoading(true);
    var body = {"password": password};

    var response =
    await ApiClient.postData(Urls.resetPass,body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.successMessageShowToster(response.body['message']);
      Get.offAllNamed(AppRoutes.passwordChangedUi);
      setPasswordLoading(false);
    }  else {
      ToastMessageHelper.errorMessageShowToster(response.body['message']);
      setPasswordLoading(false);
    }
  }




}