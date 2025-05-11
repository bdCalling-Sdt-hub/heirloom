import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heirloom/global_widgets/custom_text.dart'; // Assuming you have these custom widgets
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/global_widgets/custom_text_field.dart';
import 'package:heirloom/routes/app_routes.dart';
import 'package:heirloom/utils/app_colors.dart';
import 'package:heirloom/utils/app_icons.dart';
import 'package:heirloom/utils/app_images.dart';
import 'package:get/get.dart';

class LegacyScreen extends StatelessWidget {
  const LegacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'Legacy Messages',
        ),

        actions: [
          InkWell(
            onTap: (){
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
        padding: EdgeInsets.all(15.w),
        child: Column(
          children: [
            // Add Legacy Button
            CustomTextButton(text: "Add Legacy", onTap: () {
              Get.toNamed(AppRoutes.addLegacyMessageScreen);
            }),
            SizedBox(height: 20.h),
            // Legacy Message List
            Expanded(
              child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
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
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Recipient info
                                  CustomTextOne(
                                    text: 'Recipient: Sarah',
                                    fontSize: 16.sp,
                                    color: AppColors.textColor.withOpacity(0.5),
                                  ),
                                  SizedBox(height: 10.h),
                                  // Legacy message content
                                  CustomTextTwo(
                                    text:
                                        '"Dear Sarah, I want you to remember our summers at the..."',
                                    fontSize: 14.sp,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 10.h),
                                  // Date info
                                  CustomTextTwo(
                                    text: '20/04/2025',
                                    fontSize: 12.sp,
                                    color: AppColors.textColor.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.edit,
                                    color: Colors.white,
                                    size: 18.h,
                                  ),
                                  onPressed: () {
                                    // Action for editing the legacy message
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.red, size: 20.h),
                                  onPressed: () {
                                    // Action for deleting the legacy message
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
            ),
          ],
        ),
      ),
    );
  }
}
