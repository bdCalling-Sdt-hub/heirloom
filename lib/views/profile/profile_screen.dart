


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/views/profile/profile_update.dart';
import 'package:heirloom/views/profile/support_screen.dart';

import '../../global_widgets/custom_text.dart';
import '../../global_widgets/dialog.dart';
import '../../helpers/prefs_helper.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_icons.dart';
import 'setting/setting_screen.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;

    return Scaffold(

      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: sizeH*.02,
          children: [


            SizedBox(height: sizeH * .01),
            // Profile picture

              // Show profile picture or a default image
              //String profileImage ="${ApiConstants.imageBaseUrl}/${controller.profile['profilePicture'] }"?? AppImages.model;
               Container(
                width: 120.r,
                height: 120.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10.r,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.5), // Outer blue border
                    width: 2.w,
                  ),
                ),
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(""),  // Load image from network
                ),
              ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: CustomTextOne(
            text: "Akik",

            maxLine: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: CustomTextTwo(
                text: "Akik@gmail.com",

              ),
            ),


            const Divider(
              thickness: 1,
              indent: 40,
              endIndent: 40,
            ),
            SizedBox(height: sizeH * .01),
            // Profile buttons
            _buildProfileOption(
              icon: Image.asset(AppIcons.profile,height: 18.h),
              label: 'Profile Information',
              onTap: ()  {
                 Get.to(()=>  ProfileUpdate());
              },
            ),
            _buildProfileOption(
              icon: Image.asset(AppIcons.home,height: 18.h),
              label: 'Settings',
              onTap: () {
                Get.to( ()=> const SettingScreen());
              },
            ),

            _buildProfileOption(
              icon: Image.asset(AppIcons.home,height: 18.h),
              label: 'Support',
              onTap: ()  {
                Get.to( ()=>  SupportScreen());
              },
            ),

SizedBox(height: sizeH*.02,),
            // Logout button
            _buildProfileOption(
              isTrue: true,
              icon: Image.asset(AppIcons.home,height: 18.h),
              label: 'Logout',
              iconColor: Colors.red,
              labelColor: Colors.red,
              borderColor: Colors.red,
              fillColor: AppColors.textFieldFillColor,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      title: "Are you sure you want to \n LogOut ",
                      onCancel: () {
                        Get.back();
                      },
                      onConfirm: () async{
                        PrefsHelper.remove(AppConstants.isLogged);
                        PrefsHelper.remove(AppConstants.bearerToken);
                        PrefsHelper.remove(AppConstants.userId);
                        PrefsHelper.remove(AppConstants.firstTimeOnboarding);
                        Get.offAllNamed(AppRoutes.signInScreen);
                      },
                    );
                  },
                );
              },

            ),

          ],
        ),
      ),
    );
  }

  // Helper widget to build the profile options
  Widget _buildProfileOption({
    required Widget icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
    Color labelColor = Colors.white,
    Color? fillColor,
    Color borderColor = Colors.white24,
    final bool? isTrue,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric( horizontal: 25.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: fillColor??AppColors.primaryColor.withOpacity(0.2),

              borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: [
              SizedBox(width: 10.w),
              icon,
              SizedBox(width: 20.w),
              CustomTextTwo(text: label),
              const Spacer(),
              isTrue == true
                  ? const Icon(null)
                  : Icon(Icons.arrow_right,  size: 20.h),
              SizedBox(width: 10.w),
            ],
          ),
        ),
      ),
    );
  }



}