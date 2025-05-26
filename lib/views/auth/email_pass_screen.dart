
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heirloom/routes/app_routes.dart';
import 'package:heirloom/routes/exports.dart';
import 'package:heirloom/utils/app_colors.dart';
import '../../Controller/auth/auth_controller.dart';
import '../../global_widgets/app_logo.dart';
import '../../global_widgets/custom_text.dart';
import '../../global_widgets/custom_text_button.dart';
import '../../global_widgets/custom_text_field.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_icons.dart';

class EmailPassScreen extends StatefulWidget {
  EmailPassScreen({super.key});

  @override
  State<EmailPassScreen> createState() => _EmailPassScreenState();
}

class _EmailPassScreenState extends State<EmailPassScreen> {
  final TextEditingController emailTEController = TextEditingController();

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
                padding: EdgeInsets.all(sizeH * .02),
                child: Form(
                  key: formKey,
                  child: Column(
                    spacing: sizeH * .03,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: CustomTextOne(text: "Forget Your Password?",)),
                      Center(
                        child: CustomTextTwo(
                            text:
                                "Please enter your email to reset your password."),
                      ),
                      SizedBox(height: sizeH*.02,),
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
                      SizedBox(
                        height: sizeH * .1,
                      ),
                      Obx(() => CustomTextButton(
                          text: "Get Verification Code",
                          isLoading: controller.forgotLoading.value,
                          onTap: () {
                            if (formKey.currentState?.validate() ?? false) {
                             controller.handleForgot(emailTEController.text);

                            }
                          }),),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailTEController.dispose();
  }
}
