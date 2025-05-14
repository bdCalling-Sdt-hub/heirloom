import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../global_widgets/custom_text.dart';
import '../../../global_widgets/custom_text_button.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../utils/app_colors.dart';

class DescribeComplaintScreen extends StatefulWidget {
  final String selectedOption;
  final String receiverId;

  const DescribeComplaintScreen({required this.selectedOption, super.key, required this.receiverId});

  @override
  State<DescribeComplaintScreen> createState() =>
      _DescribeComplaintScreenState();
}

class _DescribeComplaintScreenState extends State<DescribeComplaintScreen> {
  final TextEditingController complaintController = TextEditingController();
  // ProfileAboutController controller =ProfileAboutController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'Report',
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and subtitle
              CustomTextOne(
                text: 'Find Support or Report User',
                fontSize: 20.sp,
                color: AppColors.textColor,
              ),
        
              CustomTextTwo(
                  text: 'Help us understand what’s happening',
                  fontSize: 14.sp,
              ),
        
        
              // Selected option
              Card(
                color: AppColors.settingCardColor,
                child: Padding(
                  padding:  EdgeInsets.all(12.h),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.radio_button_checked,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5.w,),
                      CustomTextTwo(
                        text: widget.selectedOption,
                        fontSize: 16.sp,
                        color: AppColors.textColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              const CustomTextTwo(text: 'Describe the issue'),
              // Complaint Text Field
              CustomTextField(
                controller: complaintController,
                hintText: "Type your message...",
                maxLine: 5,
                borderRadio: 12,
              ),
              SizedBox(height: 20.h),
        
              // Submit Button
              CustomTextButton(
                text: "Submit",
                onTap: () {
                  if (complaintController.text.isNotEmpty) {
                    print('Complaint Submitted: ${complaintController.text}');
                  //  controller.submitReport(widget.selectedOption,complaintController.text,widget.receiverId);
                    Get.back();
                  } else {
                    // Handle empty complaint
                    Get.snackbar("!!!!!", 'Please describe your complaint');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}