import 'package:flutter/material.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/global_widgets/custom_text_field.dart';
import 'package:heirloom/routes/app_routes.dart';
import 'package:heirloom/utils/app_colors.dart';
import 'package:get/get.dart';

class OthersInfoScreen extends StatefulWidget {
  const OthersInfoScreen({super.key});

  @override
  State<OthersInfoScreen> createState() => _OthersInfoScreenState();
}

class _OthersInfoScreenState extends State<OthersInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> pronouns = ['She/Her', 'He/Him', 'They/Them'];
  int? selectedPronounIndex;

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(sizeH * 0.025),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: sizeH * .015,
            children: [
              const Center(child: CustomTextOne(text: "Your name & Pronounce")),
              const Center(
                child: CustomTextTwo(
                  text:
                      "We need this information to make your\nexperience more relevant & safe",
                ),
              ),
              SizedBox(
                height: sizeH * .02,
              ),
              CustomTextOne(text: "Name"),
              CustomTextField(
                controller: _nameController,
                hintText: "Enter your name",
              ),
              SizedBox(height: sizeH * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(pronouns.length, (index) {
                  final isSelected = selectedPronounIndex == index;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedPronounIndex = index;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isSelected
                                ? AppColors.secondaryColor
                                : Colors.transparent,
                            side: BorderSide(
                                color: isSelected
                                    ? const Color(0xFF9B51E0)
                                    : Colors.white24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding:
                                EdgeInsets.symmetric(vertical: sizeH * .015),
                          ),
                          child: CustomTextTwo(
                            text: pronouns[index],
                            color: isSelected ? Colors.white : Colors.white,
                          )),
                    ),
                  );
                }),
              ),
              const Spacer(),
              CustomTextButton(
                text: "Continue",
                onTap: () {
                  final name = _nameController.text;
                  final pronoun = selectedPronounIndex != null
                      ? pronouns[selectedPronounIndex!]
                      : null;
                  // Validate or proceed
                  print('Name: $name');
                  print('Pronoun: $pronoun');

                  Get.offAllNamed(AppRoutes.customNavBar);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
