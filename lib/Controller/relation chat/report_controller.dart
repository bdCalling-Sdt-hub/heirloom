import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:heirloom/global_widgets/toaster.dart';
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
    } else {
      Get.snackbar("Failed", response.body["message"]);
    }
  }



  unfriend(String receiverId) async {
    final response = await ApiClient.deleteData(Urls.unfriend(receiverId), );
    if (response.statusCode == 200 || response.statusCode==201) {
      Get.snackbar("Success", response.body["message"]);
      Get.offAllNamed(AppRoutes.customNavBar);
    } else {
      Get.snackbar("Failed", response.body["message"]);
    }
  }
}
