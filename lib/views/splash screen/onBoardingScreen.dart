import 'package:flutter/material.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/routes/app_routes.dart';
import 'package:heirloom/utils/app_colors.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    final sizeW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.all(sizeH*.015),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: sizeH*.03,
            children: [
              CustomTextOne(text: "Your AI companion who cares"),
              CustomTextTwo(text: "Always here to talk on your side."),
              SizedBox(
                  width:sizeW*.6 ,
                  child: CustomTextButton(text: "Get the app", onTap: (){
                    Get.toNamed(AppRoutes.signInScreen);
                  },color: AppColors.buttonSecondColor,textColor: Colors.black,radius: 50,)),
            ],
          ),
        ),
      ),
    );
}}
