import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/global_widgets/custom_text_field.dart';
import 'package:heirloom/utils/app_colors.dart';
import 'package:get/get.dart';

import '../../../global_widgets/relationship_bottomSheet.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  String selectedRelationship = "Relationship";

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchTEController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "Add Family Member"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextOne(
              text: "Tag Someone",
            ),
            SizedBox(height: 15.h),
            CustomTextField(
              controller: searchTEController,
              hintText: 'Search or select recipient',
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            InkWell(
              onTap: () {
                // Open the bottom sheet with relationships and pass the callback to update the relationship
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
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.buttonSecondColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextOne(
                      text: selectedRelationship,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            CustomTextButton(
              text: "Save",
              onTap: () {},
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
