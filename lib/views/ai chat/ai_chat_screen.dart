import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_bubbles/chat_bubbles.dart'; // Importing the correct package
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_field.dart';
import 'package:heirloom/utils/app_colors.dart'; // Custom colors
import 'package:heirloom/utils/app_icons.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  _AiChatScreenState createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [
    {
      'sender': 'ai',
      'message': 'Hey Jamil, you are back! I am excited to learn more about you.'
    },
    {'sender': 'user', 'message': 'What would you like to do next?'},
    {'sender': 'ai', 'message': 'Share a memory on a topic that I pick.'},
    {
      'sender': 'user',
      'message': 'Sure! What\'s the category of the memory you want to share?'
    },
    {'sender': 'ai', 'message': 'Childhood.'},
    {
      'sender': 'user',
      'message': 'Got it. You can type a message and tell me something about your childhood.'
    },
  ];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({'sender': 'user', 'message': _controller.text});
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          children: [
            CustomTextTwo(
              text: 'Apr13, 2025 11:03 AM',
              textDecoration: TextDecoration.underline,
            ),
            SizedBox(height: 10.h,),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  bool isUser = message['sender'] == 'user';

                  // Conditionally render the BubbleSpecialThree with tail or not
                  if (isUser) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: BubbleSpecialThree(
                        text: message['message']!,
                        color: AppColors.secondaryColor,
                        tail: true,
                        isSender: true,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                      ),
                    );
                  } else {
                    return Align(

                      alignment: Alignment.centerLeft,
                      child: BubbleSpecialThree(
                        text: message['message']!,
                        color: Colors.grey,
                        tail: true,
                        isSender: false,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                      ),
                    );
                  }
                },
              ),
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
                      validator: (value) {
                        return null;
                      },
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
