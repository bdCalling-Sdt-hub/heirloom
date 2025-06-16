import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/services/api_constants.dart';
import 'package:heirloom/utils/app_images.dart';
import 'package:image_picker/image_picker.dart';

import '../../Controller/profile/profile_controller.dart';
import '../../global_widgets/custom_text_button.dart';
import '../../global_widgets/custom_text_field.dart';
import '../../utils/app_colors.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key});

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final ProfileController profileController = Get.put(ProfileController());

  final TextEditingController nameController = TextEditingController();

  final TextEditingController addressTEController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  final List<String> ageRanges = const [
    'Under 18',
    '18–24',
    '25–34',
    '35–44',
    '45–54',
    '55–64',
    '65 and over',
  ];

  // Track selected ageRange string reactively
  final RxnString selectedAgeRange = RxnString(null);

  @override
  void initState() {
    super.initState();
    profileController.fetchProfileData();

    ever(profileController.isLoading, (bool loading) {
      if (!loading && mounted) {
        nameController.text = profileController.fullName.value;
        addressTEController.text = profileController.address.value;
        selectedAgeRange.value = profileController.ageRange.value.isNotEmpty
            ? profileController.ageRange.value
            : null;
      }
    });
  }


  Future<void> _pickImage() async {
    final XFile? image = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Pick from Gallery"),
              onTap: () async {
                final picked =
                await _picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, picked);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
              onTap: () async {
                final picked =
                await _picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, picked);
              },
            ),
          ],
        );
      },
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Information Edit'),
      ),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(sizeH * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: sizeH*.02,
            children: [
        Obx(()=>      Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 45.r,  // half of 90.w
                backgroundColor: Colors.grey.shade200,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : profileController.profileImageUrl.value.isNotEmpty
                    ? CachedNetworkImageProvider(ApiConstants.imageBaseUrl + profileController.profileImageUrl.value)
                    : AssetImage(AppImages.model) as ImageProvider,
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.cardColor,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                ),
              ),
            ],
          ),
        ),),
SizedBox(height: 10.h,),
              CustomTextField(
                controller: nameController,
                hintText: "Enter your Full Name",
              ),



              Obx(() {
                return GestureDetector(
                  onTap: () {
                    // To prevent keyboard from showing up on tap
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      CustomTextField(
                        controller: TextEditingController(text: selectedAgeRange.value ?? profileController.ageRange.value),
                        hintText: "Select Your Age Range",
                        readOnly: true,
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down_circle_outlined,color: Colors.white,),
                        onSelected: (String value) {
                          selectedAgeRange.value = value;
                        },
                        itemBuilder: (BuildContext context) {
                          return ageRanges.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                );
              }),


              CustomTextField(
                controller: addressTEController,
                hintText: "Enter Your Address",
              ),
              SizedBox(height: sizeH * 0.04),
              Obx(() {
                return CustomTextButton(
                  isLoading: profileController.updateProfileLoading.value,
                  text:"Save Change",
                  onTap:(){
                    profileController.updateProfileData(
                      updatedName: nameController.text.trim(),
                      updatedAddress: addressTEController.text.trim(),
                      updatedAgeRange: selectedAgeRange.value,
                      imageFile: _profileImage,
                    );
                  }
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    nameController.dispose();

    addressTEController.dispose();
    super.dispose();
  }
}
