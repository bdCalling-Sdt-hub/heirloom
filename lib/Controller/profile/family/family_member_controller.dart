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

// You can implement the update request status method as needed for approving/rejecting requests
// Future<void> updateRequestStatus(String friendId, String status) async {
//   try {
//     final response = await ApiClient.postData(
//         Urls.updateFamilyRequestStatus,
//         {
//           'friendId': friendId,
//           'status': status
//         }
//     );
//
//     if (response.statusCode == 200) {
//       Get.snackbar('Success', 'Request updated successfully');
//     } else {
//       Get.snackbar('Error', response.body['message']);
//     }
//   } catch (e) {
//     Get.snackbar('Error', 'Failed to update request status: $e');
//   }
// }
}
