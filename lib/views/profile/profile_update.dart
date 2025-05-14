import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/utils/app_images.dart';
import 'package:image_picker/image_picker.dart';

import '../../global_widgets/custom_text.dart';
import '../../global_widgets/custom_text_button.dart';
import '../../global_widgets/custom_text_field.dart';
import '../../utils/app_colors.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({
    super.key,
  });

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
//  final ProfileController profileController = Get.find();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController genderTEController = TextEditingController();

  final TextEditingController ageTEController = TextEditingController();

  final TextEditingController addressTEController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? _profileImage;

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Pick from Gallery"),
              onTap: () async {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    _profileImage = File(image
                        .path); // Store the selected image in _profileImage
                  });
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
              onTap: () async {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    _profileImage = File(image
                        .path); // Store the selected image in _profileImage
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'Information Edit',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(sizeH * .02),
          child: Column(
            spacing: sizeH * .015,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    // Show profile picture or a default image
                    //  String profileImage = "${ApiConstants.imageBaseUrl}/${controller.profile['profilePicture']}" ?? AppImages.model;

                    CircleAvatar(
                      radius: 60.r,
                      backgroundColor:
                          AppColors.secondaryColor.withOpacity(0.2),
                      backgroundImage: _profileImage != null
                          ? FileImage(
                              _profileImage!) // If image is picked, display it
                          : NetworkImage(AppImages.model)
                              as ImageProvider, // Default image
                      onBackgroundImageError: (error, stackTrace) {},
                    ),

                    Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: const BoxDecoration(
                        color: AppColors.cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            _pickImage();
                          },
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomTextField(
                controller: nameController,
                hintText: "Enter your Full Name",
              ),
              CustomTextField(
                readOnly: true,
                controller: genderTEController,
                hintText: "Pronounce",
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  onSelected: (String selectedGender) {
                    genderTEController.text = selectedGender;
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: "Male",
                      child: Text("Male"),
                    ),
                    const PopupMenuItem<String>(
                      value: "Female",
                      child: Text("Female"),
                    ),
                    const PopupMenuItem<String>(
                      value: "Others",
                      child: Text("Others"),
                    ),
                  ],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Gender cannot be empty";
                  }
                  return null;
                },
                borderRadio: 8.r,
              ),

              CustomTextField(
                controller: ageTEController,
                hintText: "Enter Your Age",
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Age cannot be empty";
                  }
                  return null;
                },
              ),
              // Weight
              CustomTextField(
                controller: addressTEController,
                hintText: "Enter Your Address",
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Address cannot be empty";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: sizeH * .02,
              ),
              // Save Profile Button
              CustomTextButton(
                //text:profileController.isLoading.value?"Saving...": 'Save',
                text: "Save Change",
                onTap: () async {
                  // if (nameController.text.trim().isNotEmpty) {
                  //   await profileController.updateProfileData(
                  //       nameController.text.trim());
                  //   Get.back();
                  // } else {
                  //   Get.snackbar("!!!!!", "Name cannot be empty");
                  // }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
