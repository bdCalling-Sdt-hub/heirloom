
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';



class CustomTextButton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double? padding;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final VoidCallback onTap;
  final double? radius;
  final bool isLoading; // new flag to show loader

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.fontSize,
    this.radius,
    this.textColor,
    this.padding,
    this.borderColor,
    this.isLoading = false, // default to false
  });

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return TextButton(
      onPressed: isLoading ? null : onTap, // disable when loading
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(padding ?? sizeH * .015),
        backgroundColor: color ?? AppColors.secondaryColor,
        side: BorderSide(color: borderColor ?? Colors.transparent),
        fixedSize: const Size.fromWidth(double.maxFinite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 12.r),
        ),
      ),
      child: isLoading
          ? SizedBox(
        height: fontSize ?? sizeH * .022,
        width: fontSize ?? sizeH * .022,
        child: CircularProgressIndicator(
          color: textColor ?? Colors.white,
          strokeWidth: 2,
        ),
      )
          : Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: fontSize ?? sizeH * .022,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}


class StyleTextButton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final Color? textColor;
  final Function onTap;
  final double? radius;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  const StyleTextButton({
    super.key,
    required this.text,
    this.color,
    required this.onTap,
    this.fontSize,
    this.radius,
    this.textColor, this.textAlign, this.textDecoration,
  });

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return TextButton(
        onPressed: () {
          onTap();
        },
        child: Text(
          text,
          textAlign:textAlign ,
          style: TextStyle(
            color: textColor??AppColors.textColor,
              fontSize: sizeH * .018,
              fontWeight: FontWeight.w600,
              // fontFamily: 'Outfit',
          decoration: textDecoration ?? TextDecoration.none,
              decorationColor: Colors.white
          ),

        ));
  }
}