import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'custom_text.dart';

class CustomChatTile extends StatelessWidget {
  final String title, subTitle, img;
  final Widget time;
  const CustomChatTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.img,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(bottom: BorderSide(color: Colors.teal)),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.primaryColor,
              backgroundImage: NetworkImage(img),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextOne(
                    text: title,
                    fontSize: 14.sp,
                    maxLine: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  CustomTextOne(
                    text: subTitle,
                    fontSize: 14.sp,
                    color: AppColors.textColor.withOpacity(0.5),
                    maxLine: 1,
                    fontWeight: FontWeight.w400,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

          time,
          ],
        ),
      ),
    );
  }
}
