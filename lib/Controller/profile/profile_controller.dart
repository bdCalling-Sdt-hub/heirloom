
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../services/api_client.dart';
import '../../utils/urls.dart';

class ProfileController extends GetxController{
  var savedMoney = ''.obs;
  var isLoading = true.obs;
  var fullName = ''.obs;
  var email = ''.obs;
  var activities = <Map<String, dynamic>>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
    fetchActivityDetails();
  }



  void fetchProfileData() async {
    try {
      isLoading(true);
      final response = await ApiClient.getData(Urls.getProfile);

      if (response.statusCode == 200) {
        final data = response.body['data'];
        fullName.value = data['fullName'] ?? '';
        email.value = data['email'] ?? '';
      } else {
       // Get.snackbar('!!!!', response.body['message'] ?? 'Failed to load profile data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfileData(String updatedName) async {
    try {
      isLoading(true);
      final response = await ApiClient.patch(Urls.updateProfile, {'fullName': updatedName});

      if (response.statusCode == 200) {
        fullName.value = updatedName;
        Get.snackbar('Success', 'Profile updated successfully');
        Get.offAllNamed(AppRoutes.customNavBar);
      } else {
        Get.snackbar('!!!!', response.body['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }


  // New method to fetch activity details
  void fetchActivityDetails() async {
    try {
      isLoading(true);
      final response = await ApiClient.getData(Urls.getActivityDetails);

      if (response.statusCode == 200) {
        var data = response.body['data'] as List;
        activities.value = data.map((activity) => activity as Map<String, dynamic>).toList();
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading(false);
    }
  }
}