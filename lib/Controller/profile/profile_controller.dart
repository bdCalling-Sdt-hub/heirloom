
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../services/api_client.dart';
import '../../utils/urls.dart';

class ProfileController extends GetxController{
  var savedMoney = ''.obs;
  var isLoading = true.obs;
  var fullName = ''.obs;
  var userName = ''.obs;
  var address = ''.obs;
  var email = ''.obs;
  var ageRange = ''.obs;
  var profileImageUrl = ''.obs;
  var mood = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }



  void fetchProfileData() async {
    try {
      isLoading(true);
      final response = await ApiClient.getData(Urls.getProfile);
      if (response.statusCode == 200) {
        final data = response.body['data'];
        fullName.value = data['name'] ?? '';
        userName.value = data['username'] ?? '';
        address.value = data['address'] ?? '';
        ageRange.value = data['ageRange'] ?? '';
        email.value = data['email'] ?? '';
        mood.value = data['user_mood'] ?? '';
        profileImageUrl.value = data['image'] ?? '';
      } else {
        Get.snackbar('!!!', response.body['message'] ?? 'Failed to load profile data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  RxBool updateProfileLoading = false.obs;
  Future<void> updateProfileData({
    String? updatedName,
    String? updatedAddress,
    String? updatedAgeRange,
    String? updatedUserMood,
    bool? fromSelectAge,
    bool? moodCheckIn,
    File? imageFile,  // optional image file
  }) async {
    try {
      updateProfileLoading(true);

      // Build the fields map - only include non-null and non-empty strings
      Map<String, String> fields = {};
      if (updatedName != null && updatedName.trim().isNotEmpty) {
        fields['name'] = updatedName.trim();
      }
      if (updatedAddress != null && updatedAddress.trim().isNotEmpty) {
        fields['address'] = updatedAddress.trim();
      }
      if (updatedAgeRange != null && updatedAgeRange.trim().isNotEmpty) {
        fields['ageRange'] = updatedAgeRange.trim();
      }
      if (updatedUserMood != null && updatedUserMood.trim().isNotEmpty) {
        fields['user_mood'] = updatedUserMood.trim();
      }

      // Prepare multipart body for image if provided
      List<MultipartBody>? multipartBody;
      if (imageFile != null) {
        multipartBody = [
          MultipartBody('image', imageFile),
        ];
      }

      // Call your patchMultipartData from ApiClient
      final response = await ApiClient.patchMultipartData(
        Urls.updateProfile,
        fields,
        multipartBody: multipartBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Optionally update local state
        if (updatedName != null && updatedName.isNotEmpty) {
          fullName.value = updatedName;
        }
    moodCheckIn==true?Container():    Get.snackbar('Success', response.body['message']);

       moodCheckIn==true?Container(): Get.offAllNamed(fromSelectAge==true?AppRoutes.signInScreen:AppRoutes.customNavBar);
      } else {
        Get.snackbar('!!!', response.body['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      updateProfileLoading(false);
    }
  }


}