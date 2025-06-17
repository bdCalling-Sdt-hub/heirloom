import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heirloom/Controller/profile/profile_controller.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/routes/app_routes.dart';
import 'package:heirloom/utils/app_colors.dart';
import 'package:heirloom/utils/app_icons.dart';
import 'package:heirloom/utils/app_images.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProfileController profileController =ProfileController();
  List<Map<String, dynamic>> moodCategories = [];
  int categoryIndex = 0;
  String? selectedMood;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.fetchProfileData();

    moodCategories = [
      {
        'category': '🌞 Happy',
        'moods': [
          '😄 Peaceful',
          '🤩 Grateful',
          '😊 Hopeful',
          '💪 Inspired',
          '🧘 Peaceful',
          '💕 Loved',
          '💯 Confident',
          '⚡ Energized',
          '💪 Proud',
          '🚀 Motivated',
          '😌 Relaxed',
          '😄 Joyful',
          '😆 Playful',
        ]
      },
      {
        'category': '🌥 Neutral / Mixed',
        'moods': [
          '😌 Calm',
          '🤔 Reflective',
          '🤷 Curious',
          '😑 Bored',
          '😐 Indifferent',
          '🫤 Numb',
          '🤷‍♀️ Uncertain',
          '😴 Distracted',
          '🏃‍♀️ Restless',
        ]
      },
      {
        'category': '🌧 Challenging',
        'moods': [
          '😢 Sad',
          '😰 Anxious',
          '😔 Lonely',
          '😤 Overwhelmed',
          '😠 Frustrated',
          '😡 Angry',
          '😞 Hurt',
          '😓 Stressed',
          '😩 Exhausted',
          '😞 Disappointed',
          '😒 Jealous',
          '😕 Guilty',
          '😨 Fearful',
        ]
      },
      {
        'category': '🌙 Deep / Complex',
        'moods': [
          '😌 Nostalgic',
          '🥺 Sentimental',
          '😔 Melancholy',
          '😢 Vulnerable',
          '😤 Empowered',
          '💪 Resilient',
          '🕵️‍♂️ Detached',
          '😔 Inspired yet tired',
        ]
      }
    ];

  }
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
                    Obx((){return   CustomTextOne(
                      text: "Welcome Back, ${profileController.fullName.value}",
                    );}),
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
                          text: DateFormat('d MMMM, yyyy, hh.mm a').format(DateTime.now()),
                          textDecoration: TextDecoration.underline,
                        ),
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
                              _showMoodCategorySelection();
                            },
                            fontSize: sizeH * 0.015,
                            padding: 0,
                            radius: 10,
                          ),
                        ),
                      ],
                    ),
               Obx((){
                 return      CustomTextTwo(text: "Your mood: ${profileController.mood.value}");

               })
                  ],
                ),
              ),

              // Journal and Legacy Message
              customCard(sizeH, "Journal", AppIcons.journal,(){
                Get.toNamed(AppRoutes.journalScreen);
              }),
              customCard(sizeH, "legacy Message", AppIcons.legecy,(){
                Get.toNamed(AppRoutes.legacyScreen);
              }),
              SizedBox(height: 20.h,)
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

    final List<Map<String, String>> moodCategories = [
      {
        'title': '🌞 Happy',
        'moods': '😄 Peaceful, 🤩 Grateful, 😊 Hopeful, 💪 Inspired, 🧘 Peaceful, 💕 Loved, 💯 Confident, ⚡ Energized, 💪 Proud, 🚀 Motivated, 😌 Relaxed, 😄 Joyful, 😆 Playful'
      },
      {
        'title': '🌥 Neutral / Mixed',
        'moods': '😌 Calm, 🤔 Reflective, 🤷 Curious, 😑 Bored, 😐 Indifferent, 🫤 Numb, 🤷‍♀️ Uncertain, 😴 Distracted, 🏃‍♀️ Restless'
      },
      {
        'title': '🌧 Challenging',
        'moods': '😢 Sad, 😰 Anxious, 😔 Lonely, 😤 Overwhelmed, 😠 Frustrated, 😡 Angry, 😞 Hurt, 😓 Stressed, 😩 Exhausted, 😞 Disappointed, 😒 Jealous, 😕 Guilty, 😨 Fearful'
      },
      {
        'title': '🌙 Deep / Complex',
        'moods': '😌 Nostalgic, 🥺 Sentimental, 😔 Melancholy, 😢 Vulnerable, 😤 Empowered, 💪 Resilient, 🕵️‍♂️ Detached, 😔 Inspired yet tired'
      }
    ];

    final selectedMood = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + size.width, top),
      items: moodCategories.map((category) {
        return PopupMenuItem<String>(
          value: category['title']!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category['title']!),
              SizedBox(height: 5),
              Text(category['moods']!),
            ],
          ),
        );
      }).toList(),
      elevation: 8.0,
    );

    if (selectedMood != null) {
      await profileController.updateProfileData(updatedUserMood: selectedMood, moodCheckIn: true);
      profileController.fetchProfileData();
    }
  }
  // Show the mood category selection
  void _showMoodCategorySelection() async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final double top = offset.dy + size.height;
    final double left = offset.dx + size.width;

    final selectedCategory = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + size.width, top),
      items: moodCategories.map((category) {
        return PopupMenuItem<String>(
          value: category['category'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category['category']),
            ],
          ),
        );
      }).toList(),
      elevation: 8.0,
    );

    if (selectedCategory != null) {
      setState(() {
        this.selectedMood = selectedCategory;
      });
      _showMoodList(selectedCategory);
    }
  }

  // Show mood options based on the selected category
  void _showMoodList(String category) {
    List<String> moods = [];
    moodCategories.forEach((moodCategory) {
      if (moodCategory['category'] == category) {
        moods = List<String>.from(moodCategory['moods']);
      }
    });

    // Display the moods to the user
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select your mood"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: moods.map((mood) {
                return ListTile(
                  title: Text(mood),
                  onTap: () async {
                    await profileController.updateProfileData(
                      updatedUserMood: mood,
                      moodCheckIn: true,
                    );
                    profileController.fetchProfileData();
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

  Widget customCard(double sizeH, String text, icon, Function onTap) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Container(
        width: double.infinity,
        height: sizeH * .1,
        decoration: BoxDecoration(
          color: AppColors.cardColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.fromBorderSide(BorderSide(color: AppColors.cardColor)),
        ),
        child: Center(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  icon,
                  height: sizeH * .05,
                ),
                SizedBox(width: 10.w,),
                CustomTextOne(text: text),
              ],
            ),
          ),
        ),
      ),
    );
  }

