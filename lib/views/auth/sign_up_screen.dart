import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/auth/auth_controller.dart';
import '../../global_widgets/app_logo.dart';
import '../../global_widgets/custom_text.dart';
import '../../global_widgets/custom_text_button.dart';
import '../../global_widgets/custom_text_field.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_icons.dart';
import '../profile/setting/appData.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController userNameTEController = TextEditingController();
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passTEController = TextEditingController();
  final TextEditingController confirmPassTEController = TextEditingController();



  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthController controller = Get.put(AuthController());



  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    final sizeW = MediaQuery.of(context).size.width;
    RxBool rememberMe = false.obs;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const AppLogo(),

            Padding(
              padding: EdgeInsets.all(sizeH * .02),
              child: Form(
                key: formKey,
                child: Column(
                  spacing: sizeH * .02,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: CustomTextOne(text: "Sign Up")),
                    Center(child: CustomTextTwo(text:"Save and share precious life memories. Sign up for free today")),


                    CustomTextField(
                      controller: userNameTEController,
                      hintText: "Enter a Unique User Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "User Name cannot be empty";
                        }
                        return null;
                      },
                      prefixIcon: Padding(
                        padding:  EdgeInsets.only(left: sizeW*.03,right: sizeW*.01),
                        child: Icon(Icons.person,color: Colors.white.withOpacity(0.8),),
                      ),
                    ),
                    CustomTextField(
                      controller: emailTEController,
                      autofillHints: const [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Enter E-mail",
                      isEmail: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email cannot be empty";
                        }
                        if (!AppConstants.emailValidate.hasMatch(value)) {
                          return "Invalid email address";
                        }
                        return null;
                      },
                      prefixIcon: Padding(
                        padding:  EdgeInsets.only(left: sizeW*.03,right: sizeW*.01),
                        child: Image.asset(AppIcons.email,height: sizeH*.02,),
                      ),
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
                    Obx(() => Row(
                      children: [
                        Checkbox(
                          value: rememberMe.value,
                          checkColor: Colors.white,
                          activeColor: AppColors.buttonColor,
                          onChanged: (value) {
                            rememberMe.value = value!;
                          },
                        ),
                        const CustomTextTwo(text: "Agree with"),
                        InkWell(
                            onTap: () {
                              Get.to(() => AppData(type: "terms"));
                            },
                            child: const CustomTextTwo(
                              text: " Terms of Services",
                              textDecoration: TextDecoration.underline,
                            )),
                      ],
                    )),

                    // sign up button
                    Obx(() => CustomTextButton(
                      text: controller.signUpLoading.value ? "Registering..." : "Register",
                      onTap: () {
                        if (formKey.currentState?.validate() ?? false) {

                          Get.toNamed(AppRoutes.otpVerificationScreen);
                          // controller.handleSignUp(
                          //   emailTEController.text,
                          //   passTEController.text,
                          //   nameTEController.text,
                          // );
                        }
                      },
                    )),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomTextTwo(text: "Already have an account?"),
                        StyleTextButton(
                          text: "Login",
                          textDecoration: TextDecoration.underline,
                          onTap: () {
                            Get.toNamed(AppRoutes.signUpScreen);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: sizeH*.01,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
