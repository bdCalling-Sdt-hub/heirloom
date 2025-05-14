import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../global_widgets/custom_text.dart';
import '../../../global_widgets/custom_text_button.dart';
import '../../../utils/app_colors.dart';
import 'describe_complaint_screen.dart';


class ReportScreen extends StatefulWidget {
  final String receiverId;
  const ReportScreen({super.key, required this.receiverId});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // List of report options
  final List<String> reportOptions = [
    "Hate Speech",
    "Nudity or Sexual Content",
    "Threat",
    "Harassment",
    "Pretending to be something",
    "Fraud Or Scam",
    "Fake Identity",
    "Something Else"
  ];

  // Selected report option
  String? selectedOption;

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
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and subtitle
            CustomTextOne(
              text: 'Find Support or Report User',
              fontSize: 20.sp,
              color: AppColors.textColor,
            ),
            SizedBox(height: 8.h),
            CustomTextTwo(
              text: 'Help us understanding what’s happening',
              fontSize: 14.sp,

            ),
            SizedBox(height: 20.h),

            // List of options
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reportOptions.length,
              itemBuilder: (context, index) {
                final option = reportOptions[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = option;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 6.h),
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.settingCardColor,
                      border: Border.all(
                        color: selectedOption == option
                            ?Colors.grey: AppColors.profileCardColor

                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedOption == option
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: Colors.white,
                        ),
                        SizedBox(width: 12.w),
                        CustomTextTwo(
                          text: option,
                          fontSize: 16.sp,
                          color: AppColors.textColor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),


            // Next Button
            CustomTextButton(
              text: "Next",
              onTap: () {
                if (selectedOption != null) {
                Get.to(()=> DescribeComplaintScreen(
                  selectedOption: selectedOption!,
                  receiverId: widget.receiverId,
                ),);
                } else {
                  Get.snackbar("!!!!!!!", 'Please select a report option');
                }
              },

            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}



