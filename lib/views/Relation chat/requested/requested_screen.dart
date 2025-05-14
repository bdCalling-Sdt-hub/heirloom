import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';

import '../../../global_widgets/custom_chat_title.dart';
import '../../../global_widgets/custom_text.dart';
import '../../../utils/app_images.dart';

class RequestedScreen extends StatelessWidget {
  const RequestedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Flexible(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // Bottom Sheet content
                  Get.bottomSheet(
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 10.h,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextOne(text: "Confirm Request"),
                                  IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                              CircleAvatar(
                                radius: 40.r,
                                backgroundImage: NetworkImage(
                                    AppImages.model), // Sample image
                              ),
                              CustomTextOne(
                                text: 'kakashi Hatake',
                              ),
                              CustomTextTwo(
                                text:
                                    'Kakashi is awaiting your response to their connection request.',
                              ),
                              CustomTextTwo(
                                text: 'kakashi wants to contact with you',
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                      child: CustomTextButton(
                                    text: "Reject",
                                    onTap: () {},
                                    color: Colors.red,
                                    padding: 4.r,
                                  )),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Flexible(
                                      child: CustomTextButton(
                                    text: "Accept",
                                    onTap: () {},
                                    color: Colors.green,
                                    padding: 4.r,
                                  )),
                                ],
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: CustomChatTile(
                    title: 'Akik',
                    subTitle: "@devAkik",
                    img: AppImages.model,
                    time: CustomTextTwo(text: "5 min")),
              );
            },
          ),
        ),
      ),
    );
  }
}
