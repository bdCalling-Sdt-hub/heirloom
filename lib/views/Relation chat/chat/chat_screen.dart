import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/services/api_constants.dart';
import 'package:heirloom/utils/app_constant.dart';
import 'package:heirloom/utils/app_images.dart';
import 'package:heirloom/views/Relation%20chat/chat/profile_about_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Controller/relation chat/chat_controller.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../helpers/prefs_helper.dart';
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
  late final String userName;
  late final String image;
  late final bool activeStatus;
  late final String heroTag;
  late final String heroTagName;

  late final ChatController chatController;

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

String? userId;
  void getId () async{
    userId=await PrefsHelper.getString(AppConstants.userId);

  }
  @override
  void initState() {
    super.initState();
    getId();
    final args = Get.arguments ?? {};
    conversationId = args['conversationId'] ?? '';
    name = args['name'] ?? 'Unknown';
    userName = args['userName'] ?? 'Unknown';
    image = args['image'] ?? AppImages.model;
    activeStatus = args['activeStatus'] ?? false;
    heroTag = args['heroTag'] ?? image;
    heroTagName = args['heroTagName'] ?? name;
    chatController = Get.put(ChatController(conversationId));
    print("==========================id ===============$userId");
    _scrollController.addListener(() {

      if (_scrollController.position.pixels <=
          _scrollController.position.minScrollExtent + 150 &&
          !chatController.isLoadingMore.value &&
          !chatController.isLoading.value) {
        chatController.loadMore();
      }
    });


  }
  String formatDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDate = DateTime(date.year, date.month, date.day);
    final difference = today.difference(msgDate).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Yesterday";
    } else {
      return DateFormat.yMMMMd().format(date); // e.g., May 18, 2025
    }
  }
  Map<String, List<Message>> groupMessagesByDate(List<Message> messages) {
    messages.sort((a, b) => a.time.compareTo(b.time)); // sort ascending by time
    final Map<String, List<Message>> grouped = {};
    for (final msg in messages) {
      final label = formatDateLabel(msg.time);
      if (!grouped.containsKey(label)) {
        grouped[label] = [];
      }
      grouped[label]!.add(msg);
    }
    return grouped;
  }


  Future<void> _sendMessage() async {
    print("==========================id ===============$userId");
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final success = await chatController.sendMessage(text);
    if (success) {
      _controller.clear();
    }
  }

  Future<void> _pickAndSendImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final success = await chatController.sendImageMessage(file);
    // if (!success) Get.snackbar('!!!', 'Failed to send image');
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
              image: image,
              name: name,
              useName: userName,
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
                  backgroundImage: NetworkImage(image),
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
                  CustomTextTwo(text: activeStatus?"Active Now":"Not Active"),
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
                if (chatController.isLoading.value) {
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

                if (chatController.messages.isEmpty) {
                  return const Center(child: CustomTextOne(text: "No messages found"));
                }

                final groupedMessages = groupMessagesByDate(chatController.messages);

                final dateLabels = groupedMessages.keys.toList()
                  ..sort((a, b) {
                    DateTime parseLabel(String label) {
                      if (label == "Today") return DateTime.now();
                      if (label == "Yesterday") return DateTime.now().subtract(const Duration(days: 1));
                      return DateFormat.yMMMMd().parse(label);
                    }
                    return parseLabel(b).compareTo(parseLabel(a));
                  });

                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: dateLabels.length,
                  itemBuilder: (context, dateIndex) {
                    final dateLabel = dateLabels[dateIndex];
                    final msgs = groupedMessages[dateLabel]!;

                    DateTime chipDate;
                    final now = DateTime.now();
                    if (dateLabel == 'Today') {
                      chipDate = now;
                    } else if (dateLabel == 'Yesterday') {
                      chipDate = now.subtract(const Duration(days: 1));
                    } else {
                      chipDate = DateFormat.yMMMMd().parse(dateLabel);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: DateChip(
                            date: chipDate,
                            color: const Color(0x558AD3D5),
                          ),
                        ),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: msgs.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.h),
                          itemBuilder: (context, msgIndex) {
                            final message = msgs[msgIndex];
                            final isUser = message.senderId == userId;

                            Widget messageWidget;

                            if (message.image.isNotEmpty) {
                              messageWidget = Column(
                                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  BubbleNormalImage(
                                    id: message.time.toIso8601String(),
                                    image: Image.network(ApiConstants.imageBaseUrl + message.image),
                                    color: isUser ? AppColors.secondaryColor : Colors.grey,
                                    tail: true,
                                    delivered: message.readBy,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    DateFormat.jm().format(message.time.toLocal()), // formatted time e.g. 7:28 AM
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              messageWidget = Column(
                                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  BubbleNormal(
                                    text: message.content,
                                    isSender: isUser,
                                    color: isUser ? AppColors.secondaryColor : Colors.grey,
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                    ),
                                    tail: true,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    DateFormat.jm().format(message.time.toLocal()),
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Align(
                              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                              child: messageWidget,
                            );
                          },
                        ),

                      ],
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
                    onTap: _pickAndSendImage,
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
                    onTap: (){
                      _sendMessage();
                      _controller.clear();
                    },
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
