import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/global_widgets/custom_no_data_widget.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/services/api_constants.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Controller/relation chat/friend/friend_controller.dart';
import '../../../global_widgets/custom_chat_title.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../global_widgets/custom_text_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';


class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  final FriendController controller = Get.put(FriendController());

  final TextEditingController searchTEController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        child: Column(
          children: [
            CustomTextField(
              controller: searchTEController,
              hintText: "Search",
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              onChanged: (value) {
                // Debounce can be added here for optimization if needed
                controller.searchUsers(value);
              },
              validator: (value){
                return null;
              },
            ),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.topLeft,
              child: CustomTextOne(text: "Add Friends")
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.users.isEmpty) {
                  return ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            Container(
                              width: 40.r,
                              height: 40.r,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(height: 14.h, color: Colors.white, margin: EdgeInsets.symmetric(vertical: 4.h)),
                                  Container(height: 14.h, width: 150.w, color: Colors.white),
                                ],
                              ),
                            ),
                            Container(width: 30.w, height: 14.h, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (controller.users.isEmpty) {
                  return CustomNoDataWidget(text: "No Users Found");
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!controller.isMoreLoading.value &&
                        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                      controller.loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: controller.users.length + (controller.isMoreLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.users.length) {
                        // Loading indicator at the bottom when loading more
                        return Center(child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: CircularProgressIndicator(),
                        ));
                      }

                      // Inside itemBuilder of ListView.builder:
                      final user = controller.users[index];
                      bool requestSent = user['requestSent'] ?? false;

                      return CustomChatTile(
                        title: user['name'] ?? 'No Name',
                        subTitle: user['username'] ?? '',
                        img: user['image'] != null && user['image'].isNotEmpty
                            ? user['image'].startsWith('http')
                            ? user['image']
                            : '${ApiConstants.imageBaseUrl}${user['image']}'
                            : AppImages.model,
                        time: SizedBox(
                          width: 100.w,
                          child:CustomTextButton(
                            text: requestSent ? "Request Sent" : "Request",
                            onTap: requestSent
                                ? (){}
                                : () async {
                              await controller.sendFriendRequest(user['_id']);
                            },
                            fontSize: 12.sp,
                            padding: 2,
                            color: requestSent ? Colors.transparent : Colors.green,
                            borderColor: AppColors.textFieldBorderColor,
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
