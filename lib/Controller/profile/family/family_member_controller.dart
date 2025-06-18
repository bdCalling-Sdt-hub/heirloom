import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../utils/urls.dart';

class FamilyMemberController extends GetxController {
  var isLoading = true.obs;
  var familyInRequests = <Map<String, dynamic>>[].obs;
  var familyOutRequests = <Map<String, dynamic>>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  final int limit = 10;
  var friends = <Map<String, dynamic>>[].obs;
  var selectedFriend = Rxn<Map<String, dynamic>>();
  var selectedRelationship = "Relationship".obs;
  var isUpdating = false.obs;
  var selectedFriends = <Map<String, dynamic>>[].obs;
  var selectedFriendIds = <String>[].obs;



  // Fetch requests (incoming or outgoing)
  Future<void> fetchFamilyRequests(String type) async {
    try {
      isLoading(true);
      final response = await ApiClient.getData(
          Urls.getFamilyRequest(type, limit.toString(), currentPage.value.toString())
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];

        if (type == 'familyin') {
          familyInRequests.value = List<Map<String, dynamic>>.from(data['friend'] ?? []);
        } else {
          familyOutRequests.value = List<Map<String, dynamic>>.from(data['friend'] ?? []);
        }

        currentPage.value = data['pagination']?['currentPage'] ?? 1;
        totalPages.value = data['pagination']?['totalPages'] ?? 1;
      } else {
        Get.snackbar('Error', response.body['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch requests: $e');
    } finally {
      isLoading(false);
    }
  }


  var searchController = TextEditingController().obs;
  Timer? _searchTimer;

  @override
  void onInit() {
    super.onInit();
   // fetchFriends();
    // Listen to search text changes
    searchController.value.addListener(_onSearchChanged);
  }
  @override
  void onClose() {
    _searchTimer?.cancel();
    searchController.value.dispose();
    super.onClose();
  }

  void _onSearchChanged() {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      fetchFriends(search: searchController.value.text);
    });
  }

  Future<void> fetchFriends({String search = ''}) async {
    try {
      isLoading(true);
      final url = search.isNotEmpty
          ? Urls.searchRelationList(search)
          : Urls.relationList;

      final response = await ApiClient.getData(url);

      if (response.statusCode == 200 && response.body['success'] == true) {
        friends.value = List<Map<String, dynamic>>.from(response.body['data']['friend'] ?? []);
      } else {
        Get.snackbar('!!!', response.body['message'] ?? 'Failed to fetch friends');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch friends: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateRelationship() async {
    if (selectedFriendIds.isEmpty) {
      Get.snackbar('!!!', 'Please select at least one friend');
      return;
    }

    if (selectedRelationship.value == "Relationship") {
      Get.snackbar('!!!', 'Please select a relationship');
      return;
    }

    try {
      isUpdating(true);
      final response = await ApiClient.postData(
        Urls.updateRelationship,
        {
          'reciveBy': selectedFriendIds.join(','),
          'relation': selectedRelationship.value,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', response.body['message'] );

      } else {
        Get.snackbar('!!!', response.body['message'] ?? 'Failed to update relationship');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update relationship: $e');
    } finally {
      isUpdating(false);
      // Clear selections after update
      selectedFriendIds.clear();
      selectedRelationship.value = "Relationship";
    }
  }

  void selectFriend(Map<String, dynamic> friend) {
    selectedFriend.value = friend;
  }

  void setRelationship(String relationship) {
    selectedRelationship.value = relationship;
  }

  void toggleFriendSelection(String friendId) {
    if (selectedFriendIds.contains(friendId)) {
      selectedFriendIds.remove(friendId);
    } else {
      selectedFriendIds.add(friendId);
    }
  }




}
