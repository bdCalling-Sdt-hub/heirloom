import 'package:get/get.dart';
import 'package:heirloom/utils/urls.dart';
import '../../services/api_client.dart'; // adjust import as needed

class InboxController extends GetxController {
  var conversations = <Conversation>[].obs;
  var isLoading = true.obs;
  var isLoadingMore = false.obs;

  int currentPage = 1;
  int totalPages = 1;
  final int limit = 10; // items per page

  @override
  void onInit() {
    fetchConversations(page: 1);
    super.onInit();
  }

  Future<void> fetchConversations({required int page}) async {
    if (page > totalPages) return; // no more pages

    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final response = await ApiClient.getData(
        Urls.getConversationList(limit.toString(), page)
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        final convList = data['conversations'] as List<dynamic>;
        totalPages = data['pagination']['totalPages'] ?? 1;

        if (page == 1) {
          conversations.value = convList.map((json) => Conversation.fromJson(json)).toList();
        } else {
          // Append new data
          conversations.addAll(convList.map((json) => Conversation.fromJson(json)));
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
      await fetchConversations(page: currentPage + 1);
    }
  }
}

class Conversation {
  final String id;
  final String lastMessage;
  final String name;
  final String image;
  final String senderId;
  final DateTime time;
  final String activeStatus;  // new

  Conversation({
    required this.id,
    required this.lastMessage,
    required this.name,
    required this.image,
    required this.senderId,
    required this.time,
    this.activeStatus = 'Active now',  // default fallback
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    // You may want to compute activeStatus here based on last seen/time fields
    String active = 'Active now'; // or from json['activeStatus'] if exists

    return Conversation(
      id: json['_id'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      senderId: json['sender_id'] ?? '',
      time: DateTime.tryParse(json['time'] ?? '') ?? DateTime.now(),
      activeStatus: active,
    );
  }
}

