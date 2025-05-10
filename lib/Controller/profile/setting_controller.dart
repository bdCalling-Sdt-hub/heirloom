

import '../../global_widgets/toaster.dart';
import '../../helpers/prefs_helper.dart';
import '../../routes/app_routes.dart';
import '../../routes/exports.dart';
import '../../services/api_client.dart';
import '../../utils/app_constant.dart';
import '../../utils/urls.dart';

class SettingController extends GetxController {

  var appContent = ''.obs;
  var isLoadingAppData = false.obs;

  Future<void> fetchAppData(String type) async {
    isLoadingAppData.value = true;
    try {
      final response = await ApiClient.getData(Urls.appData(type));
      if (response.statusCode == 200) {

        appContent.value = response.body['data']['content'] ?? '';
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed to fetch App Data");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoadingAppData.value = false;
    }
  }

  RxBool deleteLoading = false.obs;

  deleteUser(String userId) async {
    deleteLoading.value = true;

    var response = await ApiClient.deleteData(
      Urls.deleteUser(userId),);
    if (response.statusCode == 200 || response.statusCode == 201) {

      PrefsHelper.remove(AppConstants.isLogged);
      PrefsHelper.remove(AppConstants.bearerToken);
      PrefsHelper.remove(AppConstants.userId);
      PrefsHelper.remove(AppConstants.firstTimeOnboarding);
      Get.offAllNamed(AppRoutes.signInScreen);
      ToastMessageHelper.successMessageShowToster(response.body['message']);
      deleteLoading(false);}

    else{
      deleteLoading(false);
      ToastMessageHelper.errorMessageShowToster(response.body['message']);
    }
  }
}