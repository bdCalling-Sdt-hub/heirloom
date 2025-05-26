import 'dart:async';

import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../utils/urls.dart';

class JournalController extends GetxController {
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var journals = <Map<String, dynamic>>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  //fetch journal list
  Future<void> fetchJournalData({int page = 1, bool isLoadMore = false}) async {
    if (isLoadMore) {
      isMoreLoading(true);
    } else {
      isLoading(true);
    }

    try {
      final response = await ApiClient.getData("${Urls.getJournal}?page=$page");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.body;
        if (responseData['success'] == true) {
          final List<Map<String, dynamic>> fetchedJournals =
              List<Map<String, dynamic>>.from(responseData['data']);

          if (isLoadMore) {
            journals.addAll(fetchedJournals);
          } else {
            journals.value = fetchedJournals;
          }

          currentPage.value = responseData['pagination']['currentPage'];
          totalPages.value = responseData['pagination']['totalPages'];
        } else {
          Get.snackbar(
              'Error', responseData['message'] ?? 'Failed to fetch journals');
        }
      } else {
        Get.snackbar('Error',
            'Something went wrong! Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
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
      fetchJournalData(page: currentPage.value + 1, isLoadMore: true);
    }
  }

  //add journal
  RxBool addJournalLoading = false.obs;
  createJournal(String title, date, content) async {
    addJournalLoading(true);
    var body = {
      "title": title.toString(),
      "customDate": date.toString(),
      "content": content.toString(),
    };

    var response = await ApiClient.postData(Urls.addJournal, body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Timer(const Duration(seconds: 1), () {
        Get.snackbar("Success", response.body["message"]);
        fetchJournalData(page: 1);
      });

      addJournalLoading(false);
    } else {
      Get.snackbar("!!!", response.body["message"]);
      addJournalLoading(false);
    }
  }


  //update journal
  RxBool updateJournalLoading = false.obs;
  updateJournal(String title, date, content,journalId) async {
    updateJournalLoading(true);
    var body = {
      "title": title.toString(),
      "customDate": date.toString(),
      "content": content.toString(),
    };

    var response = await ApiClient.patch(Urls.updateJournal(journalId), body);

    if (response.statusCode == 200 || response.statusCode == 201) {

      Timer(const Duration(seconds: 1), () {
        Get.snackbar("Success", response.body["message"]);
        fetchJournalData(page: 1);
      });


      updateJournalLoading(false);
    } else {
      Get.snackbar("!!!", response.body["message"]);
      updateJournalLoading(false);
    }
  }

//delete journal
  deleteJournal(String journalId) async {
    var response = await ApiClient.deleteData(Urls.deleteJournal(journalId));
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar("Success", response.body['message']);
      fetchJournalData(page: 1);
    } else {
      Get.snackbar("!!!!", response.body['message']);
    }
  }


  //enhance journal
  RxBool enhanceJournalLoading = false.obs;

  Future<String?> enhanceJournal(String content) async {
    enhanceJournalLoading(true);

    var body = {
      "content": content,
    };

    try {
      var response = await ApiClient.postData(Urls.enhanceJournal, body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data'];
        final reply = data?['reply'] as String?;
        return reply;
      } else {
        Get.snackbar("Error", response.body["message"] ?? "Enhancement failed");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      enhanceJournalLoading(false);
    }
    return null;
  }


  @override
  void onInit() {
    super.onInit();
    fetchJournalData();
  }
}
