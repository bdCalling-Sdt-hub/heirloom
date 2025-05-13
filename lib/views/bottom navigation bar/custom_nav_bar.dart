import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/global_widgets/app_logo.dart';
import 'package:heirloom/routes/app_routes.dart';
import 'package:heirloom/utils/app_images.dart';
import 'package:heirloom/views/ai%20chat/ai_chat_screen.dart';
import 'package:heirloom/views/home/home_screen.dart';
import 'package:heirloom/views/profile/profile_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';
import '../Relation chat/chat_tabBar_screen.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [

HomeScreen(),
AiChatScreen(),
    ChatTabBarScreen(),
ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: AppLogo(img: AppImages.appLogo2,height: 30.h,),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Get.toNamed(AppRoutes.notificationScreen);
          }, icon: Badge.count(count: 2, child: Icon(Icons.notifications)))
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical:Platform.isIOS? 0 : 10.h),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            child: BottomNavigationBar(
              elevation: 0,
fixedColor: Colors.blue,

useLegacyColorScheme: true,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.navBarColor,
              // selectedItemColor: Colors.purple,  // Highlight active icon
              unselectedItemColor: Colors.white.withOpacity(0.6), // Dim inactive icons
              selectedFontSize: 0,
              unselectedFontSize: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(AppIcons.home, width: 28.w, height: 28.h),
                  activeIcon: Image.asset(AppIcons.homeFill, width: 30.w, height: 30.h),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(AppIcons.aiChat, width: 28.w, height: 28.h),
                  activeIcon: Image.asset(AppIcons.aiChatFill, width: 28.w, height: 28.h),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(AppIcons.relation, width: 28.w, height: 28.h),
                  activeIcon: Image.asset(AppIcons.relationFill, width: 28.w, height: 28.h),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(AppIcons.profile, width: 28.w, height: 28.h),
                  activeIcon: Image.asset(AppIcons.profileFill, width: 28.w, height: 28.h),
                  label: '',
                ),
              ],
            )

          ),
        ),
      ),
    );
  }
}
