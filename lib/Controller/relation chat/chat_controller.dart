import 'dart:io';
import 'package:get/get.dart';
import 'package:heirloom/services/api_client.dart';

import '../../../utils/urls.dart';

class ChatController extends GetxController {
  var messages = <Message>[].obs;
  var isLoading = true.obs;
  var isLoadingMore = false.obs;

  int currentPage = 1;
  int totalPages = 1;
  final int limit = 20;

  final String conversationId;

  ChatController(this.conversationId);

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

      final response = await ApiClient.getData(Urls.getMessages(conversationId, limit, page));

      if (response.statusCode == 200) {
        final data = response.body['data'];
        final msgList = data['messages'] as List<dynamic>;
        totalPages = data['pagination']['totalPages'] ?? 1;

        if (page == 1) {
          messages.value = msgList.map((json) => Message.fromJson(json)).toList();
        } else {
          // Prepend older messages at the beginning
          messages.insertAll(0, msgList.map((json) => Message.fromJson(json)));
        }
        currentPage = page;

        // Always keep messages sorted ascending by time
        messages.sort((a, b) => a.time.compareTo(b.time));
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

  Future<bool> sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return false;

    final body = {
      'conversation': conversationId,
      'messages': messageText.trim(),
    };

    final response = await ApiClient.postData(Urls.sendMessage, body);

    if (response.statusCode == 200) {
      // Insert the new message locally without fetching all
      final json = response.body['data']['message']; // Adjust based on API response
      final newMessage = Message.fromJson(json);

      messages.add(newMessage);
      // Sort messages by time ascending
      messages.sort((a, b) => a.time.compareTo(b.time));
      return true;
    }
    return false;
  }

  Future<bool> sendImageMessage(File imageFile) async {
    try {
      final response = await ApiClient.postMultipartData(
        Urls.sendMessage,
        {'conversation': conversationId,},
        multipartBody: [MultipartBody('image', imageFile)],
      );

      if (response.statusCode == 200) {
        final json = response.body['data']['message']; // Adjust based on API response
        final newMessage = Message.fromJson(json);

        messages.add(newMessage);
        // Sort messages by time ascending
        messages.sort((a, b) => a.time.compareTo(b.time));
        return true;
      }
    } catch (_) {}
    return false;
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
