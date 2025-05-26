import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/utils/app_images.dart';
import 'package:heirloom/views/profile/profile_update.dart';

import '../../Controller/profile/profile_controller.dart';
import '../../global_widgets/custom_text.dart';
import '../../global_widgets/dialog.dart';
import '../../helpers/prefs_helper.dart';
import '../../routes/app_routes.dart';
import '../../services/api_constants.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_icons.dart';
import 'setting/setting_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final ProfileController profileController = Get.put(ProfileController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: sizeH * .015,
          children: [
            // SizedBox(height: sizeH * .01),
            // Profile picture

            // Show profile picture or a default image

       Obx((){return    CircleAvatar(
         radius: 45.r,  // half of 90
         backgroundImage: profileController.profileImageUrl.value.isNotEmpty
             ? CachedNetworkImageProvider(
           ApiConstants.imageBaseUrl + profileController.profileImageUrl.value,
         )
             : AssetImage(AppImages.model) as ImageProvider,
         backgroundColor: Colors.grey.shade200,
       );}),

          Obx((){
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: CustomTextOne(
                text: profileController.userName.value,
                maxLine: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            );
          }),

            Obx((){

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: CustomTextTwo(
                  text: profileController.email.value,
                ),
              );
            }),

            const Divider(
              thickness: 1,
              indent: 40,
              endIndent: 40,
            ),
            // SizedBox(height: sizeH * .01),
            // Profile buttons
            _buildProfileOption(
              icon: Image.asset(AppIcons.myProfile, height: 18.h),
              label: 'My Profile',
              onTap: () {
                Get.to(() => ProfileUpdate());
              },
            ),
            _buildProfileOption(
              icon: Image.asset(AppIcons.journal, height: 18.h),
              label: 'Journal',
              onTap: () {
Get.toNamed(AppRoutes.journalScreen);
              },
            ),
            _buildProfileOption(
              icon: Image.asset(AppIcons.legecy, height: 18.h),
              label: 'Legacy Massage',
              onTap: () {
                Get.toNamed(AppRoutes.legacyScreen);
              },
            ),
            _buildProfileOption(
              icon: Image.asset(AppIcons.familyMembers, height: 18.h),
              label: 'Family Members',
              onTap: () {
                Get.toNamed(AppRoutes.familyMembers);
              },
            ),
            _buildProfileOption(
              icon: Image.asset(AppIcons.support, height: 18.h),
              label: 'Support',
              onTap: () {
                Get.toNamed(AppRoutes.supportScreen);
              },
            ),
            _buildProfileOption(
              icon: Image.asset(AppIcons.setting, height: 18.h),
              label: 'Settings',
              onTap: () {
                Get.to(() => const SettingScreen());
              },
            ),




            // Logout button
            _buildProfileOption(
              isTrue: true,
              icon: Image.asset(AppIcons.logOut, height: 18.h),
              label: 'Logout',

              fillColor: AppColors.cardColor,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      title: "Are you sure you want to LogOut?",
                      subTitle: "You will be logged out of your account",
                      onCancel: () {
                        Get.back();
                      },
                      onConfirm: () async {
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
            SizedBox(height: 20.h,)
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
    Color? fillColor,
    Color borderColor = AppColors.cardColor,
    final bool? isTrue,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: fillColor ?? AppColors.profileCardColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.all(Radius.circular(16)),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Shadow color (with opacity)
                offset: Offset(0, 4), // Horizontal and vertical offset
                blurRadius: 6, // Blur effect
                spreadRadius: 0, // How much the shadow spreads
              ),
            ],
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
                  : Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 20.h,
                      color: Colors.white,
                    ),
              SizedBox(width: 10.w),
            ],
          ),
        ),
      ),
    );
  }
}
