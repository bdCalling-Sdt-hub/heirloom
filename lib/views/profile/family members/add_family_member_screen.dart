import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/global_widgets/custom_text_field.dart';
import 'package:heirloom/utils/app_colors.dart';
import 'package:get/get.dart';

import '../../../Controller/profile/family/family_member_controller.dart';
import '../../../global_widgets/relationship_bottomSheet.dart';
import '../../../services/api_constants.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final FamilyMemberController controller = Get.put(FamilyMemberController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "Add Family Member"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextOne(text: "Tag Someone"),
            SizedBox(height: 15.h),
            Obx(() => CustomTextField(
              controller: controller.searchController.value,
              hintText: 'Search or select recipient',
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Icon(Icons.search, color: Colors.white),
              ),
            )),
            SizedBox(height: 30.h),

            // Relationship selector
            InkWell(
              onTap: () {
                Get.bottomSheet(
                  RelationshipBottomSheet(
                    onSelectRelationship: (relationship) {
                      controller.setRelationship(relationship);
                    },
                  ),
                );
              },
              child: Obx(() => Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.buttonSecondColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextOne(
                      text: controller.selectedRelationship.value,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
              )),
            ),
            SizedBox(height: 20.h),

            // Friends list with checkboxes
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.friends.isEmpty) {
                  return Center(child: CustomTextTwo(text: "No friends found"));
                }

                return ListView.builder(
                  itemCount: controller.friends.length,
                  itemBuilder: (context, index) {
                    final friend = controller.friends[index];
                    final friendId = friend['userId'] as String;
                    final isSelected = controller.selectedFriendIds.contains(friendId);

                    return Card(
                      color: isSelected
                          ? AppColors.settingCardColor
                          : AppColors.profileCardColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage("${ApiConstants.imageBaseUrl}${friend['image']}"),
                          radius: 20.r,
                          onBackgroundImageError: (_, __) => Icon(Icons.person),
                        ),
                        title: CustomTextOne(
                          text: friend['name'] ?? 'Unknown',
                          textAlign: TextAlign.start,
                        ),
                        subtitle: CustomTextTwo(
                          text: '@${friend['username']}',
                          textAlign: TextAlign.start,
                        ),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (value) => controller.toggleFriendSelection(friendId),
                          activeColor: AppColors.secondaryColor,
                          checkColor: Colors.white,
                        ),
                        onTap: () {
                          controller.toggleFriendSelection(friendId);
                          controller.fetchFriends();
                        },
                      ),
                    );
                  },
                );
              }),
            ),

            // Save button with validation
            Obx(() {
              final isButtonEnabled = controller.selectedFriendIds.isNotEmpty &&
                  controller.selectedRelationship.value != "Relationship" &&
                  !controller.isUpdating.value;

              return CustomTextButton(
                text: controller.isUpdating.value ? "Saving..." : "Save",
                onTap: isButtonEnabled ? controller.updateRelationship : (){},
              );
            }),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class FriendListItem extends StatelessWidget {
  final Map<String, dynamic> friend;
  final bool isSelected;
  final VoidCallback onSelect;

  const FriendListItem({
    super.key,
    required this.friend,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? AppColors.primaryColor.withOpacity(0.2) : AppColors.profileCardColor,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage("${ApiConstants.imageBaseUrl}${friend['image']}"),
          radius: 20.r,
          onBackgroundImageError: (_, __) => Icon(Icons.person),
        ),
        title: CustomTextOne(
          text: friend['name'] ?? 'Unknown',
          textAlign: TextAlign.start,
        ),
        subtitle: CustomTextTwo(
          text: '@${friend['username']}',
          textAlign: TextAlign.start,
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (value) => onSelect(),
          activeColor: AppColors.secondaryColor,
          checkColor: Colors.white,
        ),
        onTap: onSelect,
      ),
    );
  }
}