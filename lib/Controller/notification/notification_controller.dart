import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notifications = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() {
    // Simulate fetching data
    notifications.addAll([
      {
        "title": "Congratulations! You Won!",
        "message": "You’ve won a prize in one of your entries! Check your rewards to see what you’ve won!",
        "createdAt": DateTime.now().toString(),
      },
      {
        "title": "New Message",
        "message": "You have a new message from John.",
        "createdAt": DateTime.now().subtract(Duration(minutes: 5)).toString(),
      },
      // Add more data as needed
    ]);
  }
}
