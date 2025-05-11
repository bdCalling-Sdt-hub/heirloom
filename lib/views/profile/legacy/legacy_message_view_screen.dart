import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heirloom/global_widgets/custom_text.dart'; // Assuming you have these custom widgets
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/utils/app_colors.dart'; // Custom colors
import 'package:get/get.dart';
class LegacyMessageViewScreen extends StatefulWidget {
  const LegacyMessageViewScreen({super.key});

  @override
  _LegacyMessageViewScreenState createState() => _LegacyMessageViewScreenState();
}

class _LegacyMessageViewScreenState extends State<LegacyMessageViewScreen> {
  // Sample legacy messages
  final List<Map<String, String>> legacyMessages = [
    {'sender': 'Al Jamil', 'message': 'I want you to remember our...', 'date': '20/04/2025'},
    {'sender': 'Al Jamil', 'message': 'For Sarah on her birthday', 'date': '20/04/2025'},
    {'sender': 'Al Jamil', 'message': 'I want you to remember...', 'date': '20/04/2025'},
    {'sender': 'Al Jamil', 'message': 'For Sarah on her birthday', 'date': '20/04/2025'},
    {'sender': 'Al Jamil', 'message': 'I want you to remember...', 'date': '20/04/2025'},
  ];

  // A function to show the full message when the eye icon is clicked
  void _viewMessage(String fullMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomTextOne(text: 'Full Message',color: Colors.black,),
          content: SingleChildScrollView(child: CustomTextTwo(text: fullMessage,color: Colors.black,textAlign: TextAlign.start,)),
          actions: [
            CustomTextButton(text: "Close", onTap: (){Get.back();}),
            // TextButton(
            //   onPressed: () => Navigator.pop(context),
            //   child: Text('Close'),
            // ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'Legacy Messages',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: ListView.builder(
          itemCount: legacyMessages.length,
          itemBuilder: (context, index) {
            final legacyMessage = legacyMessages[index];
            final previewMessage = legacyMessage['message']!;
            final fullMessage = "${legacyMessage['message']!} - Full details content goes here.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."; // Example full message

            return Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                color: AppColors.cardColor.withOpacity(0.4),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sender Info
                            CustomTextOne(
                              text: '🎀A Message From ${legacyMessage['sender']}',
                              fontSize: 16.sp,
                
                            ),
                
                
                            // Message Preview
                            CustomTextTwo(
                              text: '"$previewMessage"',
                              fontSize: 14.sp,
                              color: AppColors.textColor,
                            ),
                
                            // Date Info
                            CustomTextTwo(
                              text: legacyMessage['date']!,
                              fontSize: 12.sp,
                              color: AppColors.textColor.withOpacity(0.5)
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.visibility, color: AppColors.secondaryColor),
                        onPressed: () => _viewMessage(fullMessage),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
