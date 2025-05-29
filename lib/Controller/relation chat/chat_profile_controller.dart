import 'package:get/get.dart';
import 'package:heirloom/services/api_client.dart';
import '../../../utils/urls.dart';
import '../../services/api_constants.dart';

class ChatProfileController extends GetxController {
  final String conversationId;

  var mediaImages = <String>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  int currentPage = 1;
  int totalPages = 1;
  final int limit = 20;
  var isAiTwinEnabled = false.obs;
  ChatProfileController(this.conversationId);

  @override
  void onInit() {
    super.onInit();
    fetchMediaImages(page: 1);
  }

  Future<void> fetchMediaImages({required int page}) async {
    if (page > totalPages) return;

    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final response = await ApiClient.getData(Urls.getConversationMedia(conversationId, limit, page));

      if (response.statusCode == 200) {
        final data = response.body['data'];
        final mediaList = data['media'] as List<dynamic>;
        totalPages = data['pagination']['totalPages'] ?? 1;

        // Filter out empty strings & prepend base url
        final filtered = mediaList.whereType<String>().where((url) => url.isNotEmpty).map((url) => ApiConstants.imageBaseUrl + url).toList();

        if (page == 1) {
          mediaImages.value = filtered;
        } else {
          mediaImages.addAll(filtered);
        }
        currentPage = page;
      } else {
        if (page == 1) mediaImages.clear();
      }
    } catch (e) {
      if (page == 1) mediaImages.clear();
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!isLoadingMore.value && currentPage < totalPages) {
      await fetchMediaImages(page: currentPage + 1);
    }
  }

  /// Call API to toggle AI twin mode
  Future<bool> toggleAiMode(bool status) async {
    final body = {
      "conversationId": conversationId,
      "status": status,
    };

    final response = await ApiClient.postData(Urls.changeAiMode, body);

    if (response.statusCode == 200) {
      isAiTwinEnabled.value = status;
      return true;
    } else {
      return false;
    }
  }
}


