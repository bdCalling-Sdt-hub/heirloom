import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../utils/urls.dart';
import '../../../services/api_constants.dart';  // For friendRequest endpoint

class FriendController extends GetxController {
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var users = <Map<String, dynamic>>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var searchQuery = ''.obs;

  final int limit = 20;

  Future<void> fetchUsers({int page = 1, bool isLoadMore = false}) async {
    if (isLoadMore) {
      isMoreLoading(true);
    } else {
      isLoading(true);
      if (!isLoadMore) {
        users.clear();
      }
    }

    try {
      final String url;
      if (searchQuery.value.isEmpty) {
        url = Urls.getUserList('', limit, page);
      } else {
        url = Urls.getUserListSearch('', limit, page, searchQuery.value);
      }

      final response = await ApiClient.getData(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (data['success'] == true) {
          List<Map<String, dynamic>> fetchedUsers = List<Map<String, dynamic>>.from(data['data']['friend']);

          if (isLoadMore) {
            users.addAll(fetchedUsers);
          } else {
            users.value = fetchedUsers;
          }

          currentPage.value = data['data']['pagination']['currentPage'] ?? 1;
          totalPages.value = data['data']['pagination']['totalPages'] ?? 1;
        } else {
          Get.snackbar('!!!', data['message'] ?? 'Failed to fetch users');
        }
      } else {
        Get.snackbar('!!!', 'Error code: ${response.statusCode}');
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
      fetchUsers(page: currentPage.value + 1, isLoadMore: true);
    }
  }

  void searchUsers(String query) {
    searchQuery.value = query;
    fetchUsers(page: 1);
  }

  /// Send friend request API
  Future<void> sendFriendRequest(String receiverId) async {
    try {
      final body = {'reciveBy': receiverId,"relation":"friend"};

      final response = await ApiClient.postData(Urls.friendRequest, body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        if (data['success'] == true) {
          Get.snackbar('Success', data['message'] ?? 'Request sent');

          // Update the local user's requestSent flag
          final index = users.indexWhere((u) => u['_id'] == receiverId);
          if (index != -1) {
            users[index]['requestSent'] = true;
            users.refresh();
          }
        } else {
          Get.snackbar('!!!', data['message'] ?? 'Request failed');
        }
      } else {
        Get.snackbar('!!!', 'Error code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }
}
