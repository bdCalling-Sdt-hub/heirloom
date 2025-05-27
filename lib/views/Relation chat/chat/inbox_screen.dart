import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/utils/app_constant.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Controller/relation chat/inbox_controller.dart';
import '../../../global_widgets/custom_chat_title.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../routes/app_routes.dart';


class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final TextEditingController searchTEController = TextEditingController();
  final InboxController chatController = Get.put(InboxController());
  final ScrollController _scrollController = ScrollController();
  String? userId;
   getUserId() async{
    userId= await AppConstants.userId;
  }
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 150 &&
          !chatController.isLoadingMore.value &&
          !chatController.isLoading.value) {
        chatController.loadMore();
      }
    });
  }

  @override
  void dispose() {
    searchTEController.dispose();
    _scrollController.dispose();
    super.dispose();
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
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                if (chatController.isLoading.value) {
                  // Show shimmer loading
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

                if (chatController.conversations.isEmpty) {
                  return const Center(child: CustomTextOne(text: "No conversations found"));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await chatController.fetchConversations(page: 1,);
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: chatController.conversations.length + (chatController.isLoadingMore.value ? 1 : 0),
                    separatorBuilder: (context, index) => Divider(color: Colors.transparent),
                    itemBuilder: (context, index) {
                      if (index == chatController.conversations.length) {
                        // Show loading indicator at bottom when loading more
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final conv = chatController.conversations[index];


                      return InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.chatScreen, arguments: {
                            'conversationId': conv.id,
                            'name': conv.name,
                            'image': conv.image,
                            'activeStatus': conv.activeStatus,
                            'heroTag': "avatar_${conv.id}",
                            'heroTagName': "title_${conv.name}",
                          });
                        },
                        child: CustomChatTile(
                          title: conv.name.isEmpty ? "Unknown" : conv.name,
                          subTitle: conv.lastMessage.isEmpty ? "No message yet." : conv.lastMessage,
                          img: conv.image.isEmpty ? AppImages.model : conv.image,
                          time: Text(
                            _formatTime(conv.time),
                            style: TextStyle(color: AppColors.textColor.withOpacity(0.5), fontSize: 12.sp),
                          ),
                          heroTag: "avatar_${conv.id}",

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

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
