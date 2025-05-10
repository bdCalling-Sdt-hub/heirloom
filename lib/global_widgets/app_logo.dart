import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_images.dart';

class AppLogo extends StatelessWidget {
  final String? img;
  final double? height;

  const AppLogo({
    super.key, this.img, this.height,
  });

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    final sizeW = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: sizeH*.01),
        child: Image.asset(
          img??AppImages.appLogo,
          height:height?? sizeH*.2,

        ),
      )
    );
  }
}
