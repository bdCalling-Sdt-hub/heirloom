import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../utils/urls.dart';

class RequestedController extends GetxController {
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var requests = <Map<String, dynamic>>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  final int limit = 10;
  var relation = 'friend';

  Future<void> fetchRequests({int page = 1, bool isLoadMore = false}) async {
    if (isLoadMore) {
      isMoreLoading(true);
    } else {
      isLoading(true);
      if (!isLoadMore) requests.clear();
    }

    try {
      final url = Urls.getRequest(relation, limit, page);
      final response = await ApiClient.getData(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (data['success'] == true) {
          List<Map<String, dynamic>> fetchedRequests = List<Map<String, dynamic>>.from(data['data']['friend']);

          if (isLoadMore) {
            requests.addAll(fetchedRequests);
          } else {
            requests.value = fetchedRequests;
          }

          currentPage.value = data['data']['pagination']['currentPage'] ?? 1;
          totalPages.value = data['data']['pagination']['totalPages'] ?? 1;
        } else {
          Get.snackbar('!!!', data['message'] ?? 'Failed to fetch requests');
        }
      } else {
        Get.snackbar('!!!', '${response.body['message']}');
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
      fetchRequests(page: currentPage.value + 1, isLoadMore: true);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }



  /// Call API to accept or reject a request
  Future<void> actionRequest(String id, String status) async {
    try {
      final url = Urls.actionRequest(id, status);
      final ApiClient apiClient=ApiClient();
      final response = await apiClient.putData(url,{});

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (data['success'] == true) {
          Get.snackbar('Success', data['message'] ?? 'Action successful');

          requests.removeWhere((r) => r['_id'] == id);
          requests.refresh();
        } else {
          Get.snackbar('!!!', data['message'] ?? 'Action failed');
        }
      } else {
        Get.snackbar('!!!', 'Error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

}
