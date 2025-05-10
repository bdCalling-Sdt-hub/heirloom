

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Controller/auth/auth_controller.dart';
import '../../global_widgets/app_logo.dart';
import '../../global_widgets/custom_text.dart';
import '../../global_widgets/custom_text_button.dart';
import '../../global_widgets/custom_text_field.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';

class ResetPassScreen extends StatelessWidget {
  ResetPassScreen({super.key});
  final TextEditingController passTEController = TextEditingController();
  final TextEditingController confirmPassTEController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    final sizeW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppLogo(),
            Padding(
                padding: EdgeInsets.all(sizeH * .016),
                child: Form(
                  key: formKey,
                  child: Column(
                    spacing: sizeH * .03,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: CustomTextOne(text: "Reset Your Password.",)),
                      Center(
                        child: CustomTextTwo(
                            text: "Password  must have 8-10 characters."),
                      ),

                      CustomTextField(
                        controller: passTEController,
                        hintText: "Enter Password",
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password cannot be empty";
                          }
                          if (value.length < 8) {
                            return "Password must be at least 8 characters and include uppercase, lowercase, numbers, and special characters (e.g., Abc123@!)";
                          }
                          return null;
                        },

                        prefixIcon: Padding(
                          padding:  EdgeInsets.only(left: sizeW*.03,right: sizeW*.01),
                          child: Image.asset(AppIcons.password,height: sizeH*.02,),
                        ),
                      ),

                      CustomTextField(
                        controller: confirmPassTEController,
                        hintText: "Re-enter your password",
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password";
                          }
                          if (value != passTEController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },

                        prefixIcon: Padding(
                          padding:  EdgeInsets.only(left: sizeW*.03,right: sizeW*.01),
                          child: Image.asset(AppIcons.password,height: sizeH*.02,),
                        ),
                      ),
                      SizedBox(
                        height: sizeH * .02,
                      ),
                      Obx(() => CustomTextButton(
                          text:controller.setPasswordLoading.value?"Resetting...": "Reset Password",
                          onTap: () {
                            if (formKey.currentState?.validate() ?? false) {
                             // controller.resetPassword(rePassTEController.text);
                              Get.toNamed(AppRoutes.passwordChangedUi);
                            }
                          }),)
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
