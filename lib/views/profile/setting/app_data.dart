
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../Controller/profile/setting_controller.dart';
import '../../../global_widgets/custom_text.dart';
import '../../../utils/app_colors.dart';



class AppData extends StatelessWidget {
  final String type;
  const AppData({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final SettingController settingController = Get.put(SettingController());
    settingController.fetchAppData(type);
    String getAppTitle(String type) {
      switch (type) {
        case "privacy-policy":
          return "Privacy Policy";
        case "terms":
          return "Terms & Conditions";
        case "about":
          return "About Us";
        default:
          return "Info";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title:CustomTextOne(
          text: getAppTitle(type),
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),

      ),
      body: Obx(() {
        if (settingController.isLoadingAppData.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.all(sizeH * .02),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextTwo(
                  text: 'Our ${getAppTitle(type)}',
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: sizeH * .02),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.settingCardColor,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(sizeH * .016),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: sizeH * 0.7,
                    ),
                    child: SingleChildScrollView(
                      child: HtmlWidget(
                        settingController.appContent.value,
                        textStyle: TextStyle(fontSize: 14.sp,color: AppColors.textColor),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      }),
    );
  }
}
