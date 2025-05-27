import 'package:get/get.dart';
import 'package:heirloom/services/api_client.dart';
import '../../../utils/urls.dart'; // your URL constants

class MessagesController extends GetxController {
  var messages = <Message>[].obs;
  var isLoading = true.obs;
  var isLoadingMore = false.obs;

  int currentPage = 1;
  int totalPages = 1;
  final int limit = 20;

  final String conversationId;

  MessagesController(this.conversationId);

  @override
  void onInit() {
    super.onInit();
    fetchMessages(page: 1);
  }

  Future<void> fetchMessages({required int page}) async {
    if (page > totalPages) return;

    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final response = await ApiClient.getData(
       Urls.getMessages(conversationId, limit, page)
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        final msgList = data['messages'] as List<dynamic>;
        totalPages = data['pagination']['totalPages'] ?? 1;

        if (page == 1) {
          messages.value = msgList.map((json) => Message.fromJson(json)).toList();
        } else {
          messages.addAll(msgList.map((json) => Message.fromJson(json)));
        }
        currentPage = page;
      } else {
        if (page == 1) messages.clear();
      }
    } catch (e) {
      if (page == 1) messages.clear();
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!isLoadingMore.value && currentPage < totalPages) {
      await fetchMessages(page: currentPage + 1);
    }
  }
}

class Message {
  final String senderName;
  final String senderId;
  final bool activeStatus;
  final String content;
  final String image;
  final bool readBy;
  final DateTime time;

  Message({
    required this.senderName,
    required this.senderId,
    required this.activeStatus,
    required this.content,
    required this.image,
    required this.readBy,
    required this.time,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderName: json['sender_name'] ?? '',
      senderId: json['sender_id'] ?? '',
      activeStatus: json['activeStatus'] ?? false,
      content: json['content'] ?? '',
      image: json['image'] ?? '',
      readBy: json['readBy'] ?? false,
      time: DateTime.tryParse(json['time'] ?? '') ?? DateTime.now(),
    );
  }
}
