import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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

  final TextEditingController birthdayTEController = TextEditingController();

  final TextEditingController heightTEController = TextEditingController();

  final TextEditingController weightTEController = TextEditingController();

  final RxString weightUnit = 'kg'.obs;
  final RxString heightUnit = 'cm'.obs;

  final ImagePicker _picker = ImagePicker();

  File? _profileImage;

  //select date
  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      birthdayTEController.text =
      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }

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
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    _profileImage = File(image.path);  // Store the selected image in _profileImage
                  });
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
              onTap: () async {
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    _profileImage = File(image.path);  // Store the selected image in _profileImage
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
                      backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)  // If image is picked, display it
                          : AssetImage('assets/default_profile_image.png') as ImageProvider,  // Default image
                      onBackgroundImageError: (error, stackTrace) {
                      },
                    ),


                    Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed:(){_pickImage();},
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
               CustomTextOne(text: "Your Name",fontSize: sizeH*.018,),
              CustomTextField(
                controller: nameController,
                hintText: "Enter your name",
              ),
              CustomTextOne(text: "Gender", fontSize: sizeH * .018,),
              CustomTextField(
                readOnly: true,
                controller: genderTEController,
                hintText: "Select Gender",
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: AppColors.primaryColor,
                  ),
                  onSelected: (String selectedGender) {
                    genderTEController.text = selectedGender;
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                borderRadio: 12.r,
              ),
              // Birthday
              CustomTextOne(text: "Date of birth", fontSize: sizeH * .018,),
              CustomTextField(
                onTap: () {
                  selectDate(context);
                },
                readOnly: true,
                controller: birthdayTEController,
                hintText: "MM-DD-YYYY",
                suffixIcon: const Icon(Icons.calendar_month, color: AppColors.primaryColor),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Birth Date cannot be empty";
                  }
                  return null;
                },
                borderRadio: 12.r,
              ),
              // Height
              CustomTextOne(text: "Height", fontSize: sizeH * .018,),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: heightTEController,
                      hintText: "Enter Height",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Height cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.textFieldFillColor,
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Obx(() => DropdownButton<String>(
                        value: heightUnit.value,
                        icon: const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: AppColors.primaryColor,
                        ),
                        elevation: 16,
                        style: TextStyle(color: AppColors.primaryColor),
                        onChanged: (String? newValue) {
                          heightUnit.value = newValue!;
                        },
                        items: <String>['cm', 'Inch']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                    ),
                  ),
                ],
              ),
              // Weight
              CustomTextOne(text: "Weight", fontSize: sizeH * .018,),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: weightTEController,
                      hintText: "Enter Weight",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Weight cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.textFieldFillColor,
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Obx(() => DropdownButton<String>(
                        value: weightUnit.value,
                        icon: const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: AppColors.primaryColor,
                        ),
                        elevation: 16,
                        style: TextStyle(color: AppColors.primaryColor),
                        onChanged: (String? newValue) {
                          weightUnit.value = newValue!;
                        },
                        items: <String>['kg', 'lbs']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                    ),
                  ),
                ],
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
