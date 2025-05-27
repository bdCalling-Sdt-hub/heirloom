import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/routes/app_routes.dart';
import 'package:heirloom/services/api_constants.dart';
import 'package:heirloom/utils/app_images.dart';
import 'package:heirloom/views/Relation%20chat/chat/profile_about_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Controller/relation chat/chat_controller.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final String conversationId;
  late final String name;
  late final String image;
  late final String activeStatus;
  late final String heroTag;
  late final String heroTagName;

  late final MessagesController messagesController;

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    conversationId = args['conversationId'] ?? '';
    name = args['name'] ?? 'Unknown';
    image = args['image'] ?? AppImages.model;
    activeStatus = args['activeStatus'] ?? 'Active now';
    heroTag = args['heroTag'] ?? image;
    heroTagName = args['heroTagName'] ?? name;

    messagesController = Get.put(MessagesController(conversationId));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 150 &&
          !messagesController.isLoadingMore.value &&
          !messagesController.isLoading.value) {
        messagesController.loadMore();
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        // Optionally, you can send to backend here
        messagesController.messages.insert(
          0,
          Message(
            senderName: name,
            senderId: conversationId,
            activeStatus: true,
            content: _controller.text,
            image: '',
            readBy: false,
            time: DateTime.now(),
          ),
        );
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: InkWell(
          onTap: () {
            Get.to(ProfileAboutScreen(
              image:ApiConstants.imageBaseUrl+image,
              name: name,
              useName: '@${name.replaceAll(' ', '').toLowerCase()}',
              conversationId: conversationId,
            ));
          },
          child: Row(
            children: [
              Hero(
                tag: heroTag,
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.primaryColor,
                  backgroundImage: NetworkImage(ApiConstants.imageBaseUrl + image),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: heroTagName,
                    child: Material(
                      color: Colors.transparent,
                      child: CustomTextOne(
                        key: ValueKey(heroTagName),
                        text: name,
                      ),
                    ),
                  ),
                  CustomTextTwo(text: activeStatus),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (messagesController.isLoading.value) {
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
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (messagesController.messages.isEmpty) {
                  return const Center(child: CustomTextOne(text: "No messages found"));
                }

                return ListView.separated(
                  controller: _scrollController,
                  reverse: true, // latest messages at bottom
                  itemCount: messagesController.messages.length + (messagesController.isLoadingMore.value ? 1 : 0),
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    if (index == messagesController.messages.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final message = messagesController.messages[index];
                    final isUser = message.senderId == conversationId;

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 280.w),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: isUser ? AppColors.secondaryColor : Colors.grey,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          message.content,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      AppIcons.image,
                      height: 30.h,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: CustomTextField(
                      controller: _controller,
                      validator: (value) => null,
                      hintText: 'Type your message',
                      borderRadio: 16.r,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  InkWell(
                    onTap: _sendMessage,
                    child: Image.asset(
                      AppIcons.send,
                      height: 30.h,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

