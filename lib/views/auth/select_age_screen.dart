import 'package:flutter/material.dart';
import 'package:heirloom/Controller/profile/profile_controller.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/routes/app_routes.dart';
import 'package:heirloom/utils/app_colors.dart';
import 'package:get/get.dart';

import '../../global_widgets/custom_text_field.dart';

class SelectAgeScreen extends StatefulWidget {
  const SelectAgeScreen({super.key});

  @override
  State<SelectAgeScreen> createState() => _SelectAgeScreenState();
}

class _SelectAgeScreenState extends State<SelectAgeScreen> {
  final TextEditingController _nameController = TextEditingController();
  ProfileController profileController=ProfileController();
  final List<String> ageRanges = const [
    'Under 18',
    '18–24',
    '25–34',
    '35–44',
    '45–54',
    '55–64',
    '65 and over',
  ];

  final RxnInt selectedIndex = RxnInt(null);


  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(sizeH * .02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: sizeH * .01,
              children: [
                const CustomTextOne(text: "How older you?"),
                const CustomTextTwo(
                  text:
                      "We need this information to make your\nexperience more relevant & safe",
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: CustomTextOne(text: "Name")),
                CustomTextField(
                  controller: _nameController,
                  hintText: "Enter your name",
                ),
                SizedBox(
                  height: sizeH * .015,
                ),
                ...List.generate(ageRanges.length, (index) {
                  return Obx((){
                    final isSelected = selectedIndex.value == index;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: sizeH * .005),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                          isSelected ? Colors.black : Colors.white,
                          backgroundColor:
                          isSelected ? Colors.white : Colors.transparent,
                          side: BorderSide(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textFieldBorderColor),
                          padding: EdgeInsets.symmetric(vertical: sizeH * .016),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          selectedIndex.value = index;
                        },
                        child: Center(
                            child: CustomTextOne(
                              text: ageRanges[index],
                              color: isSelected ? Colors.black : Colors.white,
                              fontSize: sizeH * .02,
                            )),
                      ),
                    );
                  });
                }),
                SizedBox(height: sizeH * .06),
               Obx((){return  CustomTextButton(
                   text: "Continue",
                   isLoading: profileController.updateProfileLoading.value,
                   onTap: selectedIndex != null
                       ? () {
                     Get.toNamed(AppRoutes.signInScreen);
                     print("Selected age: ${ageRanges[selectedIndex.value!]}");

                     profileController.updateProfileData(fromSelectAge: true,updatedAgeRange: ageRanges[selectedIndex.value!].toString(),updatedName: _nameController.text);
                   }
                       : () {});})
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
  }
}
