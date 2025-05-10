import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:heirloom/global_widgets/app_logo.dart';
import 'package:lottie/lottie.dart';

import '../../helpers/prefs_helper.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? logged;

  @override
  void initState() {
    super.initState();
    getData();
    Timer(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.onboardingScreen);
     // if(logged=="true"){
     //   Get.offAllNamed(AppRoutes.customNavBar);
     // }else{
     //   Get.offAllNamed(AppRoutes.onboardingScreen);
     // }
    });
  }

  void getData() async {
    logged = await PrefsHelper.getString(AppConstants.isLogged);
  }

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: AppLogo(
              height: sizeH * .7,
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeH * .04),
              child: LinearProgressIndicator(
                color: AppColors.secondaryColor,
                backgroundColor: Colors.white,
                minHeight: sizeH * .01,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ],
        ));
  }
}
