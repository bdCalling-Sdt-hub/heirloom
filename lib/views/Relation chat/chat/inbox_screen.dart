import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heirloom/global_widgets/custom_chat_title.dart';
import 'package:heirloom/global_widgets/custom_text_field.dart';
import 'package:heirloom/routes/app_routes.dart';

import '../../../global_widgets/custom_text.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import 'package:get/get.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final TextEditingController searchTEController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        child: Column(
          children: [
            CustomTextField(
              controller: searchTEController,
              hintText: "Search",
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Flexible(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      Get.toNamed(AppRoutes.chatScreen);
                    },
                    child: CustomChatTile(
                        title: 'Akik',
                        subTitle: "Hey How Are You?",
                        img: AppImages.model,
                        time: "5 min"),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
