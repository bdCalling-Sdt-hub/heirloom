import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/global_widgets/custom_text_field.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController subjectTEController=TextEditingController();
  final TextEditingController detailsTEController=TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "Support"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15.h,
            children: [
              CustomTextOne(text: "Subject"),
              CustomTextField(controller:subjectTEController,hintText: "Enter the subject", ),
              CustomTextOne(text: "Note"),
              CustomTextField(controller:detailsTEController,hintText: "Enter the Details ..", maxLine: 4,maxLength: 80,),
              CustomTextButton(text: "Send to Admin", onTap: (){})
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    subjectTEController.dispose();
    detailsTEController.dispose();
    super.dispose();
  }
}

