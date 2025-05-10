import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../Controller/notification/notification_controller.dart';
import '../../../global_widgets/custom_text.dart';
import '../../../utils/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'Notifications',
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (controller.notifications.isEmpty) {
                return Center(child: CircularProgressIndicator()); // Show a loading indicator if data is empty
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.notifications.length,
                itemBuilder: (context, index) {
                  var notification = controller.notifications[index];
                  DateTime createdAt = DateTime.parse(notification['createdAt']!);
                  String formattedTime = DateFormat.jm().format(createdAt);
                  String formattedDate = DateFormat.yMMMd().format(createdAt);

                  return Column(
                    children: [
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: ListTile(
                            leading: Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                              ),
                            ),
                            title: CustomTextOne(
                              text: notification['title'] ?? "No Title",
                              color: Colors.black,
                              fontSize: 14.sp,
                              maxLine: 1,
                              textOverflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextOne(
                                  text: notification['message'] ?? "No Message",
                                  color: AppColors.textColor,
                                  fontSize: 12.sp,
                                  maxLine: 3,
                                  textOverflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                                Row(
                                  children: [
                                    CustomTextOne(
                                      text: formattedDate,
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      maxLine: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(width: 5.w),
                                    CustomTextOne(
                                      text: formattedTime,
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      maxLine: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: AppColors.primaryColor,
                        thickness: 1,
                        indent: 20.w,
                        endIndent: 20.w,
                      ),
                    ],
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
