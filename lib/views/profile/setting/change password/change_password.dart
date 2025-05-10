
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../Controller/auth/auth_controller.dart';
import '../../../../global_widgets/app_logo.dart';
import '../../../../global_widgets/custom_text.dart';
import '../../../../global_widgets/custom_text_button.dart';
import '../../../../global_widgets/custom_text_field.dart';
import '../../../../helpers/prefs_helper.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/app_icons.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final TextEditingController oldPassTEController = TextEditingController();

  final TextEditingController passTEController = TextEditingController();

  final TextEditingController rePassTEController = TextEditingController();

  final AuthController controller = Get.put(AuthController());

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(title: CustomTextOne(text: "Change Password")),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(sizeH * .02),
            child: Column(
              children: [
                AppLogo(),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: sizeH * .03,
                    children: [
                      // Current Password
                      CustomTextOne(
                          text: "Your Current Password", fontSize: sizeH * .018),
                      CustomTextField(
                        controller: oldPassTEController,
                        hintText: "Current Password",
                        isPassword: true,
                        validator: (value) =>
                            value!.isEmpty ? "Current password is required" : null,
                      ),

                      // New Password
                      CustomTextOne(
                          text: "Enter New Password", fontSize: sizeH * .018),
                      CustomTextField(
                        controller: passTEController,
                        hintText: "New Password",
                        isPassword: true,
                        validator: (value) => value!.length < 8
                            ? "Password must be at least 8 characters"
                            : null,
                      ),

                      // Re-enter New Password
                      CustomTextOne(
                          text: "Re-Enter New Password", fontSize: sizeH * .018),
                      CustomTextField(
                        controller: rePassTEController,
                        hintText: "Re-Enter New Password",
                        isPassword: true,
                        validator: (value) => value != passTEController.text
                            ? "Passwords do not match"
                            : null,
                      ),

                      // Forget Password Button
                      Align(
                        alignment: Alignment.centerRight,
                        child:
                            StyleTextButton(text: "Forget Password?", onTap: () {
                              Get.toNamed(AppRoutes.emailPassScreen);
                            }),
                      ),



                      // Update Password Button
                      Obx(
                        () => CustomTextButton(
                          text: controller.changePasswordLoading.value
                              ? "Updating Password..."
                              : "Update Password",
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              // controller.changePassword(
                              //   oldPassTEController.text,
                              //   rePassTEController.text,
                              // );
                              Get.offAllNamed(AppRoutes.customNavBar);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
