import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controller/profile/setting_controller.dart';
import '../../../global_widgets/custom_text.dart';
import '../../../global_widgets/dialog.dart';
import '../../../helpers/prefs_helper.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_icons.dart';
import 'appData.dart';
import 'change password/change_password.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? isLogged;
  String? userId;
  final SettingController controller = Get.put(SettingController());

  void getData() async {
    isLogged = await PrefsHelper.getString(AppConstants.isLogged);
    userId = await PrefsHelper.getString(AppConstants.userId);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "Setting"),
      ),
      body: Padding(
        padding: EdgeInsets.all(sizeH * .008),
        child: Column(
          children: [
            buildOption(
              icon: Image.asset(AppIcons.changePass, height: 18.h),
              label: 'Change Password',
              onTap: () {
                Get.to(() => ChangePassword());
              },
            ),
            buildOption(
              icon: Image.asset(AppIcons.privacy, height: 18.h),
              label: 'Privacy Policy',
              onTap: () {
                Get.to(() => AppData(type: "privacy-policy"));
              },
            ),
            buildOption(
              icon: Image.asset(AppIcons.terms, height: 18.h),
              label: 'Terms & Conditions',
              onTap: () {
                Get.to(() => AppData(type: "terms"));
              },
            ),
            buildOption(
              icon: Image.asset(AppIcons.about, height: 18.h),
              label: 'About Us',
              onTap: () {
                Get.to(() => AppData(type: "about"));
              },
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: buildOption(
                noIcon: true,
                color: Colors.red,
                icon: Icon(Icons.delete),
                textColor: Colors.white,
                label: 'Delete Account',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      title: "Do you want to delete your account?",
                      subTitle:"All your changes will be deleted and you will no longer be able to access them.",
                      confirmButtonText: 'Delete',
                      confirmButtonColor: Colors.red,
                      onCancel: () {
                        // Handle Cancel Button Action
                        Get.back();
                      },
                      onConfirm: () {
                        controller.deleteUser(userId.toString());
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the profile options
  Widget buildOption({
    required Widget icon,
    required String label,
    Color? color,
    Color? textColor,
    Color? iconColor,
    required VoidCallback onTap,
    final bool? noIcon,
    Color borderColor = AppColors.primaryColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: color ?? AppColors.settingCardColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              SizedBox(width: 10.w),
              icon,
              SizedBox(width: 20.w),
              CustomTextTwo(
                text: label,
                color: textColor ?? AppColors.textColor,
              ),
              const Spacer(),
              noIcon == true
                  ? SizedBox.shrink()
                  : Icon(Icons.arrow_forward_ios_rounded, size: 18.h,color: Colors.white,),
              SizedBox(width: 10.w),
            ],
          ),
        ),
      ),
    );
  }
}
