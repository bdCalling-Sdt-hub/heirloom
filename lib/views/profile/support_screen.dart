
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global_widgets/custom_text.dart';
import '../../utils/app_colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: "Support",
          color: AppColors.textColor,
          fontSize: 18.sp,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10.h,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/animations/supportAnimation.json',
                  fit: BoxFit.cover,
                ),
              ),

              CustomTextTwo(
                text:
                "If you face any kind of problem with our service feel free to contact us.",
              ),
              SizedBox(height: 20.h),

              // InkWell(
              //   onTap: () async {
              //     final Uri url = Uri.parse('tel:(609)327-7992');
              //     if (await launchUrl(url)) {
              //       await launchUrl(url);
              //     } else {
              //       debugPrint('Could not launch phone dialer');
              //     }
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(
              //         Icons.phone,
              //         color: AppColors.primaryColor,
              //       ),
              //       SizedBox(width: 10.w),
              //       CustomTextTwo(text: "(609)327-7992"),
              //     ],
              //   ),
              // ),

              InkWell(
                onTap: () async {
                  final Uri emailUrl = Uri(
                    scheme: 'mailto',
                    path: 'jotter@gmail.com',
                    query: 'subject=Support Inquiry&body=Hello, I need assistance with...',
                  );
                  if (await launchUrl(emailUrl)) {
                    await launchUrl(emailUrl);
                  } else {
                    debugPrint('Could not launch email client');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 10.w),
                    CustomTextTwo(text: "coupKart@gmail.com"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
