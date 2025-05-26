import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../utils/urls.dart';

class NotificationController extends GetxController {
  var notifications = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var notificationCount = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({int page = 1, bool isLoadMore = false}) async {
    if (isLoadMore) {
      isMoreLoading(true);
    } else {
      isLoading(true);
    }

    try {
      final response = await ApiClient.getData("${Urls.notification}?page=$page");

      if (response.statusCode == 200) {
        final data = response.body;

        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> notificationsData = data['data']?['notifications'] ?? [];
          final List<Map<String, dynamic>> fetchedNotifications = notificationsData.cast<Map<String, dynamic>>();

          if (isLoadMore) {
            notifications.addAll(fetchedNotifications);
          } else {
            notifications.value = fetchedNotifications;
          }

          currentPage.value = data['data']?['pagination']?['currentPage'] ?? 1;
          totalPages.value = data['data']?['pagination']?['totalPages'] ?? 1;
        } else {
          if (!isLoadMore) notifications.clear();
          Get.snackbar('Error', data['message'] ?? 'Failed to load notifications');
        }
      } else {
        Get.snackbar('!!!', 'Failed with status code ${response.statusCode}');
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
      fetchNotifications(page: currentPage.value + 1, isLoadMore: true);
    }
  }


  Future<void> fetchNotificationCountAndLatest() async {

      final response = await ApiClient.getData(Urls.notificationBadge);

      if (response.statusCode == 200) {
        final data = response.body;
        if (data['success'] == true && data['data'] != null) {
          final unreadCount = data['data']['unreadCount'] ?? 0;
          notificationCount.value = unreadCount.toString();

        } else {
          Get.snackbar('!!!', data['message'] ?? 'Failed to fetch notification count/latest');
        }
      } else {
        Get.snackbar('!!!', 'Failed with status code ${response.statusCode}');
      }

  }


}
