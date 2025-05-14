import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/utils/app_colors.dart';
import '../../../global_widgets/custom_chat_title.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_images.dart';
import 'package:get/get.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  final TextEditingController searchTEController = TextEditingController();
 bool requestSent=false;
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
            Align(
                alignment: Alignment.topLeft,
                child: CustomTextOne(text: "Add Friends",)),
            SizedBox(
              height: 10.h,
            ),
            Flexible(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return CustomChatTile(
                      title: 'Akik',
                      subTitle: "Hey How Are You?",
                      img: AppImages.model,
                      time: SizedBox(
                        width: 100.w,
                        child: CustomTextButton(text:requestSent==true?"Request Sent": "Request", onTap: (){
                          requestSent=true;
                          setState(() {
                          });
                        },fontSize: 12.sp,padding: 2,color:requestSent==true?Colors.transparent: Colors.green,borderColor: AppColors.textFieldBorderColor,),
                      ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchTEController.dispose();
  }
}
