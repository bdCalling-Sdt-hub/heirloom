import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/routes/app_routes.dart';
import 'package:heirloom/utils/app_colors.dart';
import 'package:heirloom/utils/app_icons.dart';
import 'package:heirloom/utils/app_images.dart';
import 'package:get/get.dart';
class FamilyMembers extends StatelessWidget {
  const FamilyMembers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'Family Members',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextButton(
              text: "Add Family Member",
              onTap: () {
                Get.toNamed(AppRoutes.addFamilyMemberScreen);
              },
              color: Colors.transparent,
              borderColor: AppColors.textFieldBorderColor,
              textColor: AppColors.secondaryColor,
            ),
            // "Review Family Members" Section
            SizedBox(height: 15.h),
            CustomTextTwo(
              text: 'Review Family Members',
            ),

            Flexible(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return buildFamilyMemberOption(
                    name: "Kakashi hatake",
                    relation: "Brother",
                    widthSize: 10.w,
                    icon1: Image.asset(
                      AppIcons.denied,
                      height: 25.h,
                    ),
                    icon2: Image.asset(
                      AppIcons.approve,
                      height: 25.h,
                    ),
                  );
                },
              ),
            ),

            // "Family Members You Added" Section
            CustomTextTwo(
              text: 'Family Members You Added',
            ),
            Flexible(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return buildFamilyMemberOption(
                    name: "Ronoroa Zoro",
                    relation: "Brother (Pending)",
                    icon1: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.penToSquare,
                        color: Colors.white,
                        size: 16.h,
                      ),
                      onPressed: () {

                      },
                    ),
                    icon2: IconButton(
                      icon: Icon(Icons.delete_outline,
                          color: Colors.red, size: 20.h),
                      onPressed: () {

                      },
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

  // Helper widget to build family member review options (approve/deny)
  Widget buildFamilyMemberOption({
    required String name,
    required String relation,
    required Widget icon1,
    required Widget icon2,
    double? widthSize,
  }) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Container(
          padding: EdgeInsets.all(8.h),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(bottom: BorderSide(color: Colors.teal)),
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor
                    .withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
                offset:
                    Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primaryColor,
                backgroundImage: AssetImage(AppImages.model),
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextOne(
                    text: name,
                    fontSize: 14.sp,
                  ),
                  CustomTextTwo(
                    text: relation,
                    fontSize: 14.sp,
                    color: AppColors.textColor.withOpacity(0.5),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [icon1, SizedBox(width: widthSize), icon2],
              )
            ],
          ),
        ));
  }
}
