import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:heirloom/global_widgets/custom_no_data_widget.dart';

import '../../../Controller/profile/legacy/legacy_controller.dart';
import '../../../global_widgets/custom_text.dart';
import '../../../global_widgets/custom_text_button.dart';
import '../../../global_widgets/dialog.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import 'add_legacy_message_screen.dart';

class LegacyScreen extends StatelessWidget {
  LegacyScreen({super.key});

  final LegacyController controller = Get.put(LegacyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: 'Legacy Messages'),
        actions: [
          InkWell(
            onTap: () {
              // Navigate to add legacy message screen
              Get.toNamed(AppRoutes.legacyMessageViewScreen);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Image.asset(
                AppIcons.activity,
                height: 20.h,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.h),
        child: Column(
          children: [
            CustomTextButton(
                text: "Add Legacy Message",
                onTap: () {
                  Get.toNamed(AppRoutes.addLegacyMessageScreen);
                }),
            SizedBox(height: 20.h),
            Expanded(
              // <-- Wrap ListView with Expanded
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.legacyMessages.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.legacyMessages.isEmpty) {
                  return CustomNoDataWidget(text: "No Legacy Messages Found");
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (!controller.isMoreLoading.value &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      controller.loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: controller.legacyMessages.length +
                        (controller.isMoreLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.legacyMessages.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final legacy = controller.legacyMessages[index];
                      final recipients =
                          legacy['recipients'] as List<dynamic>? ?? [];

                      final recipientNames = recipients
                          .map((r) => (r['name'] ?? 'Unknown'))
                          .join(', ');

                      return Padding(
                        padding: EdgeInsets.only(bottom: 15.h),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          color: AppColors.cardColor.withOpacity(0.4),
                          elevation: 4,
                          child: Padding(
                            padding: EdgeInsets.all(15.w),
                            child: Row(
                              children: [
                                Expanded(
                                  // Use Expanded instead of Flexible here for text column
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextOne(
                                        text: 'Recipient: $recipientNames',
                                        fontSize: 15.sp,
                                        color: AppColors.textColor
                                            .withOpacity(0.5),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(height: 10.h),
                                      CustomTextOne(
                                        text: '"${legacy['message'] ?? ''}"',
                                        fontSize: 14.sp,
                                        maxLine: 3, // corrected property
                                        textOverflow: TextOverflow
                                            .ellipsis, // corrected property
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(height: 10.h),
                                      CustomTextTwo(
                                        text: controller
                                            .formatDate(legacy['time']),
                                        fontSize: 12.sp,
                                        color: AppColors.textColor
                                            .withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.penToSquare,
                                        color: Colors.white,
                                        size: 18.h,
                                      ),
                                      onPressed: () {
                                        Get.to(() => AddLegacyMessageScreen(existingLegacy: legacy));
                                      },
                                    ),

                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red, size: 20.h),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialog(
                                              title: "Are you sure you want to delete this Legacy Message?",
                                              subTitle: "This Legacy Message will be permanently deleted from your account.",
                                              confirmButtonText: "Delete",
                                              onCancel: () {
                                                Get.back();
                                              },
                                              onConfirm: () async {
                                                Get.back();
                                                bool success = await controller.deleteLegacyMessage(legacy['_id']);
                                                if (success) {
                                                  // Optionally additional UI feedback
                                                }
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
