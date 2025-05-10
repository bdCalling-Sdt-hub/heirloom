import 'package:flutter/material.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/routes/app_routes.dart';
import 'package:heirloom/utils/app_colors.dart';
import 'package:get/get.dart';

class SelectAgeScreen extends StatefulWidget {
  const SelectAgeScreen({super.key});

  @override
  State<SelectAgeScreen> createState() => _SelectAgeScreenState();
}

class _SelectAgeScreenState extends State<SelectAgeScreen> {
  final List<String> ageRanges = const [
    'Under 18',
    '18–24',
    '25–34',
    '35–44',
    '45–54',
    '55–64',
    '65 and over',
  ];

  int? selectedIndex;

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
                SizedBox(
                  height: sizeH * .015,
                ),
                ...List.generate(ageRanges.length, (index) {
                  final isSelected = selectedIndex == index;
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
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Center(
                          child: CustomTextOne(
                        text: ageRanges[index],
                        color: isSelected ? Colors.black : Colors.white,
                        fontSize: sizeH * .02,
                      )),
                    ),
                  );
                }),
                SizedBox(height: sizeH * .06),
                CustomTextButton(
                    text: "Continue",
                    onTap: selectedIndex != null
                        ? () {
                          Get.toNamed(AppRoutes.othersInfoScreen);
                            print("Selected age: ${ageRanges[selectedIndex!]}");
                          }
                        : () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
