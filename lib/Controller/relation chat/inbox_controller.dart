import 'package:get/get.dart';
import 'package:heirloom/utils/urls.dart';
import '../../services/api_client.dart'; // adjust import as needed

class InboxController extends GetxController {
  var conversations = <Conversation>[].obs;
  var isLoading = true.obs;
  var isLoadingMore = false.obs;

  int currentPage = 1;
  int totalPages = 1;
  final int limit = 10;

  String searchQuery = '';

  @override
  void onInit() {
    fetchConversations(page: 1);
    super.onInit();
  }

  Future<void> fetchConversations({required int page, String search = ''}) async {
    if (page > totalPages) return;

    if (page == 1) {
      conversations.clear();
      searchQuery = search;
    }

    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      // Use search or no search
      final uri = search.isEmpty
          ? Urls.getConversationList(limit.toString(), page)
          : Urls.getConversationListSearch(search);

      final response = await ApiClient.getData(uri);

      if (response.statusCode == 200) {
        final data = response.body['data'];
        final convList = data['conversations'] as List<dynamic>;
        totalPages = data['pagination']['totalPages'] ?? 1;

        final newConversations = convList.map((json) => Conversation.fromJson(json)).toList();

        if (page == 1) {
          conversations.value = newConversations;
        } else {
          conversations.addAll(newConversations);
        }

        currentPage = page;
      } else {
        if (page == 1) conversations.clear();
      }
    } catch (e) {
      if (page == 1) conversations.clear();
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!isLoadingMore.value && currentPage < totalPages) {
      await fetchConversations(page: currentPage + 1, search: searchQuery);
    }
  }

  // Call this method to update search results from UI
  void searchConversations(String search) {
    currentPage = 1;
    totalPages = 1;
    fetchConversations(page: 1, search: search);
  }
}


class Conversation {
  final String id;
  final String lastMessage;
  final String name;
  final String userName;
  final String image;
  final String senderId;
  final DateTime time;
  final bool activeStatus;  // changed to bool

  Conversation({
    required this.id,
    required this.lastMessage,
    required this.name,
    required this.userName,
    required this.image,
    required this.senderId,
    required this.time,
    this.activeStatus = false,
  });

  // Friendly text based on activeStatus bool
  String get activeStatusText => activeStatus ? 'Active now' : 'Offline';

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      name: json['name'] ?? '',
      userName: json['userName'] ?? '',
      image: json['image'] ?? '',
      senderId: json['sender_id'] ?? '',
      time: DateTime.tryParse(json['time'] ?? '') ?? DateTime.now(),
      activeStatus: json['activeStatus'] ?? false,
    );
  }
}


