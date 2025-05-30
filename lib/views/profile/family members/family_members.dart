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

import '../../../global_widgets/dialog.dart';
import '../../../global_widgets/relationship_bottomSheet.dart';
class FamilyMembers extends StatefulWidget {
  const FamilyMembers({super.key});

  @override
  State<FamilyMembers> createState() => _FamilyMembersState();
}

class _FamilyMembersState extends State<FamilyMembers> {
  String selectedRelationship = "Brother";
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
                    icon1: InkWell(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              title: "Are you sure you want to delete this Family Request?",
                              subTitle: "This Request will be permanently deleted from your account.",
                              confirmButtonText: "Delete",
                              onCancel: () {
                                Get.back();
                              },
                              onConfirm: ()  {

                              },
                            );
                          },
                        );
                      },
                      child: Image.asset(
                        AppIcons.denied,
                        height: 25.h,
                      ),
                    ),
                    icon2: InkWell(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              title: "Are you certain you would like to add this individual as a member of your family?",
                              subTitle: "This action will associate the individual with your family group. Please confirm your decision.",
                              confirmButtonText: "Confirm",
                              confirmButtonColor: Colors.green,
                              onCancel: () {
                                Get.back();
                              },
                              onConfirm: ()  {

                              },
                            );
                          },
                        );
                      },
                      child: Image.asset(
                        AppIcons.approve,
                        height: 25.h,
                      ),
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
                    relation: "$selectedRelationship (Pending)",
                    icon1: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.penToSquare,
                        color: Colors.white,
                        size: 16.h,
                      ),
                      onPressed: () {
                        Get.bottomSheet(
                          RelationshipBottomSheet(
                            onSelectRelationship: (relationship) {
                              setState(() {
                                selectedRelationship = relationship;
                              });
                            },
                          ),
                        );
                      },
                    ),
                    icon2: IconButton(
                      icon: Icon(Icons.delete_outline,
                          color: Colors.red, size: 20.h),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              title: "Are you sure you want to delete this Family Member?",
                              subTitle: "It will be permanently deleted from your account.",
                              confirmButtonText: "Delete",
                              onCancel: () {
                                Get.back();
                              },
                              onConfirm: () async {

                              },
                            );
                          },
                        );
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
                backgroundImage: NetworkImage(AppImages.model),
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
