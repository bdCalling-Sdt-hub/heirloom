

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heirloom/routes/app_routes.dart';
import 'package:heirloom/utils/app_colors.dart';

import '../../Controller/auth/auth_controller.dart';
import '../../global_widgets/app_logo.dart';
import '../../global_widgets/custom_pin_code_textfiled.dart';
import '../../global_widgets/custom_text.dart';
import '../../global_widgets/custom_text_button.dart';

class OtpVerificationScreen extends StatelessWidget {
  final bool? isFormForget;
  final String? email;
   OtpVerificationScreen({
    super.key,
    this.isFormForget,
    this.email,
  });
  final TextEditingController otpTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());
    final sizeH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppLogo(),

            Padding(
              padding: EdgeInsets.all(sizeH * .016),
              child: Column(
                spacing: sizeH * .04,
                children: [

                  Center(child: CustomTextOne(text: "Enter Verification Code.",)),
                  Center(
                    child: CustomTextTwo(
                        text:
                            "Please enter the 6 digit verification code sent to your e-mail"),
                  ),
                  CustomPinCodeTextField(
                    textEditingController: otpTEController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StyleTextButton(
                          text: "Didn’t receive the code?",
                          textColor: AppColors.textColor,
                          onTap: () {
                          }),
                      StyleTextButton(
                          text: "Resend",
                          textDecoration: TextDecoration.underline,
                          onTap: () {
                           // controller.reSendOtp(email!);
                          }),
                    ],
                  ),
                  SizedBox(
                    height: sizeH * .03,
                  ),
                 Obx(() =>  CustomTextButton(
                     text: controller.verifyLoading.value
                         ? "Verifying...."
                         : "Verify",
                     onTap: () {
                       print("==================================${otpTEController.text}");

                       if(isFormForget==true){
                         Get.toNamed(AppRoutes.resetPassScreen);
                       }
                       else{
                         // controller.verifyEmail(
                         //     otpTEController.text, isFormForget!);
                         Get.toNamed(AppRoutes.selectAgeScreen);
                       }
                     }),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
