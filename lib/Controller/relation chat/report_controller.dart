import 'dart:async';

import 'package:get/get.dart';
import 'package:heirloom/routes/app_routes.dart';

import '../../services/api_client.dart';
import '../../utils/urls.dart';

class ReportController extends GetxController {
  /// Call API to report
  report(String title, description, receiverId) async {
    final body = {
      "msgTitle": title,
      "reportMsg": description,
    };

    final response = await ApiClient.postData(Urls.report(receiverId), body);

    if (response.statusCode == 200) {
      Get.snackbar("Success", response.body["message"]);
    } else {}
  }

  unfriend(String receiverId) async {

    final response = await ApiClient.postData(Urls.unfriend(receiverId), {});

    if (response.statusCode == 200) {
      Get.snackbar("Success", response.body["message"]);
      Get.offAllNamed(AppRoutes.customNavBar);
    } else {}
  }
}
