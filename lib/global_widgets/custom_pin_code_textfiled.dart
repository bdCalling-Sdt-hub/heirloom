
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../utils/app_colors.dart';

class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField({super.key, this.textEditingController, this.validator});

  final TextEditingController? textEditingController;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: textEditingController,
      length: 6, // OTP length
      autofocus: true, // Auto focus on the OTP field
      keyboardType: TextInputType.number,
      autofillHints: const [AutofillHints.oneTimeCode], // ✅ Auto-fill OTP from SMS/email
      validator: validator,
      focusedPinTheme:PinTheme(
        width: 40.w,
        height: 45.h,

        textStyle:  TextStyle(fontSize: 18.sp, color: Colors.black),
        decoration: BoxDecoration(
          color: AppColors.textFieldFillColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.textFieldBorderColor),
        ),
      ),
      defaultPinTheme: PinTheme(
        width: 40.w,
        height: 45.h,
        textStyle:  TextStyle(fontSize: 18.sp, color: AppColors.textColor),
        decoration: BoxDecoration(

         color: AppColors.textFieldFillColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withOpacity(0.2)),
        ),
      ),
      onCompleted: (pin) {
        print("OTP Entered: $pin"); // ✅ Logs OTP when completed
      },
    );
  }
}
