import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/views/Relation%20chat/chat/report_screen.dart';

import '../../../Controller/relation chat/chat_profile_controller.dart';
import '../../../Controller/relation chat/report_controller.dart';
import '../../../global_widgets/custom_text.dart';
import '../../../global_widgets/dialog.dart';
import '../../../utils/app_colors.dart' show AppColors;
import 'media_screen.dart';

class ProfileAboutScreen extends StatefulWidget {
  final String image;
  final String name;
  final String useName;
  final String receiverId;
  final String conversationId;
  final bool aiUser;
  final bool chatAccess;

  const ProfileAboutScreen(
      {super.key,
      required this.image,
      required this.name,
      required this.conversationId,
      required this.useName,
      required this.receiverId,
      required this.aiUser,
      required this.chatAccess});

  @override
  State<ProfileAboutScreen> createState() => _ProfileAboutScreenState();
}

class _ProfileAboutScreenState extends State<ProfileAboutScreen> {
  late ChatProfileController controller;
  final ReportController reportController = ReportController();
  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatProfileController(widget.conversationId));
    controller.isAiTwinEnabled.value = widget.aiUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundImage: NetworkImage(widget.image),
              ),
              SizedBox(height: 20.h),
              CustomTextOne(
                text: widget.name,
                fontSize: 20.sp,
                maxLine: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
              CustomTextTwo(
                text: widget.useName,
              ),
              SizedBox(height: 30.h),
              _buildProfileOption(
                  title: 'Media',
                  onTap: () {
                    Get.to(MediaScreen(
                      conversationId: widget.conversationId,
                    ));
                  }),
              _buildProfileOption(
                  title: 'Report',
                  onTap: () {
                    Get.to(ReportScreen(
                      receiverId: widget.receiverId,
                    ));
                  }),
              widget.chatAccess
                  ? Obx(() => _buildProfileOption(
                        noIcon: true,
                        padding: 8.r,
                        title: 'Chat With AI Twin',
                        toogle: true,
                        switchValue: controller.isAiTwinEnabled.value,
                        onSwitchChanged: (bool value) async {
                          final success = await controller.toggleAiMode(value);
                          if (!success) {
                            Get.snackbar(
                                'Error', 'Failed to update AI Twin mode');
                          }
                        },
                        onTap: () {},
                      ))
                  : Container(),
              widget.chatAccess
                  ? _buildProfileOption(
                      title: 'Unfriend',
                      textColor: Colors.red,
                      noIcon: true,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              title:
                                  "Are you sure you want to remove this person from your friends list?",
                              subTitle:
                                  "This action will end your friendship connection and you won’t be able to see each other’s updates anymore.",
                              confirmButtonText: "Unfriend",
                              onCancel: () {
                                Get.back();
                              },
                              onConfirm: () {
                                reportController.unfriend(widget.receiverId);
                                Get.back();
                              },
                            );
                          },
                        );
                      })
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildProfileOption({
  required String title,
  required VoidCallback onTap,
  Color? textColor,
  bool? noIcon,
  bool? toogle,
  double? padding,
  bool switchValue = false, // Default value for the Switch
  ValueChanged<bool>? onSwitchChanged, // Callback for the Switch
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5.h),
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: padding ?? 16.h),
        decoration: BoxDecoration(
          color: AppColors.profileCardColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: AppColors.textFieldBorderColor),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.1), // Shadow color (with opacity)
              offset: Offset(0, 4), // Horizontal and vertical offset
              blurRadius: 6, // Blur effect
              spreadRadius: 0, // How much the shadow spreads
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomTextOne(
                text: title,
                textAlign: TextAlign.start,
                color: textColor ?? AppColors.textColor,
                fontSize: 14.sp,
              ),
            ),
            if (toogle == true)
              Switch(
                value: switchValue, // Control the Switch value
                onChanged: onSwitchChanged, // Trigger the callback when toggled
                activeColor: AppColors.secondaryColor
                    .withOpacity(0.5), // Customize active color
                inactiveThumbColor:
                    Colors.grey, // Customize inactive thumb color
              ),
            if (noIcon != true)
              Icon(
                Icons.arrow_forward_ios,
                size: 16.h,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    ),
  );
}
