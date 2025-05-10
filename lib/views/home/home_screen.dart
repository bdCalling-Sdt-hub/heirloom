import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/utils/app_colors.dart';
import 'package:heirloom/utils/app_icons.dart';
import 'package:heirloom/utils/app_images.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: sizeH*.015,
            children: [
              // Welcome message
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: Image.asset(AppImages.homeScreenImage, height: sizeH * .35, width: double.infinity, fit: BoxFit.cover)),
                  Column(
                    children: [
                      CustomTextOne(
                        text: "Welcome Back, Monkey D. Luffy",
                      ),
                      CustomTextTwo(
                        text: "Today’s a good day to preserve memories.",
                        color: AppColors.secondaryColor.withOpacity(0.8),
                      ),
                    ],
                  )
                ],
              ),

              // Daily Snapshot Section
              Container(
                padding: EdgeInsets.all(sizeH * .01),
                decoration: BoxDecoration(
                  color: AppColors.cardColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.fromBorderSide(BorderSide(color: AppColors.cardColor)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextOne(
                          text: "🌤️ DAILY SNAPSHOT",
                          fontSize: sizeH * .018,
                        ),
                        CustomTextTwo(
                          text: "Apr13,2025 11:03 AM",
                          textDecoration: TextDecoration.underline,
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextTwo(
                          text: "How are you feeling today?",
                        ),
                        SizedBox(
                          width: sizeH * .1,
                          child: CustomTextButton(
                            text: "Check-In",
                            onTap: () {
                              _showPopupMenu(context); // Pass context to the popup menu
                            },
                            fontSize: sizeH * 0.015,
                            padding: 0,
                            radius: 10,
                          ),
                        ),
                      ],
                    ),
                    CustomTextTwo(text: "Your mood: 😊 Hopeful")
                  ],
                ),
              ),

              // Journal and Legacy Message
              customCard(sizeH, "Journal", AppIcons.journal),
              customCard(sizeH, "Legecy Message", AppIcons.legecy)
            ],
          ),
        ),
      ),
    );
  }

  // PopupMenu method for showing the menu
  void _showPopupMenu(BuildContext context) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final double top = offset.dy + size.height;
    final double left = offset.dx + size.width;

    final List<String> moodOptions = ['😄 Peaceful', '🤩 Grateful', '😊 Hopeful', '😐 Lonely', '😢 Sad'];

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + size.width, top),
      items: moodOptions.map((mood) {
        return PopupMenuItem<String>(
          value: mood,
          child: Text(mood),
        );
      }).toList(),
      elevation: 8.0,
    ).then((selectedMood) {
      if (selectedMood != null) {
        print('Selected mood: $selectedMood');
      }
    });
  }

  Container customCard(double sizeH, String text, icon) {
    return Container(
      width: double.infinity,
      height: sizeH * .1,
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.fromBorderSide(BorderSide(color: AppColors.cardColor)),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: sizeH * .05,
            ),
            CustomTextOne(text: text),
          ],
        ),
      ),
    );
  }
}
