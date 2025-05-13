
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';




class CustomTextOne extends StatelessWidget {

  const CustomTextOne(
      {super.key,
        this.maxLine,
        this.textOverflow,
        this.fontName,
        this.textAlign = TextAlign.center,
        this.left = 0,
        this.right = 0,
        this.top = 0,
        this.bottom = 0,
        this.fontSize,
        this.textHeight,
        this.fontWeight = FontWeight.w400,
        this.color,
       required this.text });

  final double left;
  final TextOverflow? textOverflow;
  final double right;
  final double top;
  final double bottom;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final String text;
  final TextAlign textAlign;
  final int? maxLine;
  final String? fontName;
  final double? textHeight;

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final sizeW = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.only(
          left: left, right: right, top: top, bottom: bottom),
      child: Text(
        textAlign: textAlign,
        text,
        maxLines: maxLine??3,
        overflow: textOverflow??TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize ?? sizeH*.022,
            // fontFamily: 'Outfit',
            fontWeight:fontWeight?? FontWeight.w800,
          color: color ?? AppColors.textColor,
        ),
      ),
    );
  }
}

class CustomTextTwo extends StatelessWidget {

  const CustomTextTwo(
      {super.key,


        this.fontName,
        this.textAlign = TextAlign.center,
        this.left = 0,
        this.right = 0,
        this.top = 0,
        this.bottom = 0,
        this.fontSize,
        this.textHeight,
        this.fontWeight = FontWeight.w400,
        this.color,
        required this.text, this.textDecoration });

  final double left;
  final double right;
  final double top;
  final double bottom;
  final TextDecoration? textDecoration;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final String text;
  final TextAlign textAlign;

  final String? fontName;
  final double? textHeight;

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final sizeW = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.only(
          left: left, right: right, top: top, bottom: bottom),
      child: Text(
        textAlign: textAlign,
        text,

        style: TextStyle(
            fontSize: fontSize ?? sizeH*.017,
            // fontFamily: 'Outfit',
            fontWeight:fontWeight??FontWeight.w400 ,
            color: color ?? AppColors.textColor,
          decoration: textDecoration ?? TextDecoration.none,
            decorationColor: AppColors.textColor,
        ),
      ),
    );
  }
}