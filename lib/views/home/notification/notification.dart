import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Controller/notification/notification_controller.dart';
import '../../../global_widgets/custom_text.dart';
import '../../../utils/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController controller = Get.put(NotificationController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        controller.loadMore();
      }
    });

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
        child: Obx(() {
          if (controller.isLoading.value && controller.notifications.isEmpty) {
            // Show shimmer placeholders during initial loading
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (_, __) => Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade700,
                  highlightColor: Colors.grey.shade500,
                  child: Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),
            );
          }

          if (controller.notifications.isEmpty) {
            return const Center(child: Text('No notifications found.'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: controller.notifications.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.notifications.length) {
                // Show bottom loading indicator when fetching more
                return Obx(() => controller.isMoreLoading.value
                    ? Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                )
                    : const SizedBox.shrink());
              }

              var notification = controller.notifications[index];
              DateTime createdAt = DateTime.parse(notification['createdAt']);
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
                            color: AppColors.cardColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            FontAwesomeIcons.bell,
                            color: Colors.white,
                          ),
                        ),
                        title: CustomTextOne(
                          text: "Notification",
                          fontSize: 14.sp,
                          maxLine: 1,
                          textOverflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextOne(
                              text: notification['msg'] ?? "No Message",
                              color: AppColors.textColor,
                              fontSize: 12.sp,
                              maxLine: 7,
                              textOverflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                            Row(
                              children: [
                                CustomTextOne(
                                  text: formattedDate,
                                  fontSize: 12.sp,
                                  maxLine: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 5.w),
                                CustomTextOne(
                                  text: formattedTime,
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
                    color: AppColors.cardColor,
                    thickness: 1,
                    indent: 20.w,
                    endIndent: 20.w,
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}


