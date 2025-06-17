import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import 'custom_text.dart';
import 'package:get/get.dart';

class RelationshipBottomSheet extends StatelessWidget {
  final Function(String) onSelectRelationship;

  const RelationshipBottomSheet({
    super.key,
    required this.onSelectRelationship,
  });

  @override
  Widget build(BuildContext context) {
    List<String> relationships = [
      "Mother", "Father", "Sister", "Brother", "Son", "Daughter",
      "Grandmother", "Grandfather", "Grandson", "Granddaughter",
      "Aunt", "Uncle", "Cousin", "Best friend", "Friend", "Nephew",
      "Niece", "Mother in law", "Father in law", "Brother in law",
      "Sister in law", "Stepmother", "Stepfather", "Stepbrother",
      "Stepsister"
    ];

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.profileCardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextOne(
                text: 'Relationship',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ))
            ],
          ),
          SizedBox(height: 10.h),
          // List of relationships
          Expanded(
            child: ListView.builder(
              itemCount: relationships.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: InkWell(
                    onTap: () {
                      onSelectRelationship(relationships[index]);
                      Get.back();
                    },
                    child: CustomTextTwo(
                      text: relationships[index],
                      textAlign: TextAlign.start,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
