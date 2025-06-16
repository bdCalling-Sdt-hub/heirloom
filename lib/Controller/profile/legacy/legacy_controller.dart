import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../utils/urls.dart';
import 'package:intl/intl.dart';

class LegacyController extends GetxController {
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var legacyMessages = <Map<String, dynamic>>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  final int limit = 10;

  Future<void> fetchLegacyMessages({int page = 1, bool isLoadMore = false}) async {
    if (isLoadMore) {
      isMoreLoading(true);
    } else {
      isLoading(true);
      if (!isLoadMore) legacyMessages.clear();
    }

    try {
      final url = Urls.getLegacyMessage(limit.toString(), page.toString());
      final response = await ApiClient.getData(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (data['success'] == true) {
          List<Map<String, dynamic>> fetchedLegacy = List<Map<String, dynamic>>.from(data['data']['legacy']);

          if (isLoadMore) {
            legacyMessages.addAll(fetchedLegacy);
          } else {
            legacyMessages.value = fetchedLegacy;
          }

          currentPage.value = data['data']['pagination']['currentPage'] ?? 1;
          totalPages.value = data['data']['pagination']['totalPages'] ?? 1;
        } else {
          Get.snackbar('!!!', data['message'] ?? 'Failed to fetch legacy messages');
        }
      } else {
        Get.snackbar('!!!', 'Error code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('!!!', 'An error occurred: $e');
    } finally {
      if (isLoadMore) {
        isMoreLoading(false);
      } else {
        isLoading(false);
      }
    }
  }

  void loadMore() {
    if (currentPage.value < totalPages.value && !isMoreLoading.value) {
      fetchLegacyMessages(page: currentPage.value + 1, isLoadMore: true);
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchLegacyMessages();
  }


  /// Add new legacy message
  Future<bool> addLegacyMessage({
    required List<String> recipients,
    required String triggerDateIso,
    required String message,
  }) async {
    final body = {
      "recipients": recipients,
      "triggerDate": triggerDateIso,
      "messages": message,
    };

    try {
      final response = await ApiClient.postData(Urls.addLegacy, body);

      if (response.statusCode == 200 || response.statusCode == 201) {


        Timer(const Duration(seconds: 1), () {
          Get.snackbar('Success', response.body['message'] ?? 'Legacy message added');
          fetchLegacyMessages();
        });
        return true;
      } else {
        Get.snackbar('!!!', response.body['message'] ?? 'Failed to add legacy message');
      }
    } catch (e) {
      Get.snackbar('!!!', 'An error occurred: $e');
    }
    return false;
  }

  /// Edit existing legacy message
  Future<bool> editLegacyMessage({
    required String legacyId,
    required List<String> recipients,
    required String triggerDateIso,
    required String message,
  }) async {
    final body = jsonEncode({
      "recipients": recipients,
      "triggerDate": triggerDateIso,
      "messages": message,
    });

    try {
      final url = Urls.legacyEdit(legacyId);
      final response = await ApiClient.patch(
        url,
        body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {

        Timer(const Duration(seconds: 1), () {
          Get.snackbar('Success', response.body['message'] ?? 'Legacy message updated');
          fetchLegacyMessages();
        });

        return true;

      } else {
        Get.snackbar('!!!', response.body['message'] ?? 'Failed to update legacy message');
      }
    } catch (e) {
      Get.snackbar('!!!', 'An error occurred: $e');
    }
    return false;
  }

  var friends = <Map<String, dynamic>>[].obs;
  var isFriendsLoading = false.obs;

  /// Fetch friends list (with optional search)
  Future<void> fetchFriends({String search = ''}) async {
    isFriendsLoading(true);

    try {
      // If your API supports search param, add it here
      final url = Urls.getFriends + (search.isNotEmpty ? "?search=$search" : "");

      final response = await ApiClient.getData(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (data['success'] == true) {
          final List<Map<String, dynamic>> fetchedFriends =
          List<Map<String, dynamic>>.from(data['data']['friend'] ?? []);
          friends.value = fetchedFriends;
        } else {
          Get.snackbar('!!!', data['message'] ?? 'Failed to fetch friends');
        }
      } else {
        Get.snackbar('!!!!', 'Error code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isFriendsLoading(false);
    }
  }


///get triggered legacy message
  var triggeredLegacyMessages = <Map<String, dynamic>>[].obs;
  var triggeredCurrentPage = 1.obs;
  var triggeredTotalPages = 1.obs;
  var isTriggeredLoading = false.obs;
  var isTriggeredMoreLoading = false.obs;

  Future<void> fetchTriggeredLegacyMessages({int page = 1, bool isLoadMore = false}) async {
    if (isLoadMore) {
      isTriggeredMoreLoading(true);
    } else {
      isTriggeredLoading(true);
      if (!isLoadMore) triggeredLegacyMessages.clear();
    }

    try {
      final url = Urls.legacyView(limit.toString(), page.toString());
      final response = await ApiClient.getData(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (data['success'] == true) {
          List<Map<String, dynamic>> fetchedLegacy =
          List<Map<String, dynamic>>.from(data['data']['legacy'] ?? []);

          if (isLoadMore) {
            triggeredLegacyMessages.addAll(fetchedLegacy);
          } else {
            triggeredLegacyMessages.value = fetchedLegacy;
          }

          triggeredCurrentPage.value = data['data']['pagination']['currentPage'] ?? 1;
          triggeredTotalPages.value = data['data']['pagination']['totalPages'] ?? 1;
        } else {
          Get.snackbar('!!!', data['message'] ?? 'Failed to fetch triggered legacy messages');
        }
      } else {
        Get.snackbar('!!!', 'Error code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      if (isLoadMore) {
        isTriggeredMoreLoading(false);
      } else {
        isTriggeredLoading(false);
      }
    }
  }

  void loadMoreTriggeredLegacyMessages() {
    if (triggeredCurrentPage.value < triggeredTotalPages.value && !isTriggeredMoreLoading.value) {
      fetchTriggeredLegacyMessages(page: triggeredCurrentPage.value + 1, isLoadMore: true);
    }
  }


  ///delete legacy Message
  Future<bool> deleteLegacyMessage(String legacyId) async {
    try {
      final url = Urls.deleteLegacy(legacyId);
      final response = await ApiClient.deleteData(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', response.body['message'] ?? 'Legacy message deleted');
        fetchLegacyMessages();
        return true;
      } else {
        Get.snackbar('!!!', response.body['message'] ?? 'Failed to delete legacy message');
      }
    } catch (e) {
      Get.snackbar('!!!', 'An error occurred: $e');
    }
    return false;
  }


}
