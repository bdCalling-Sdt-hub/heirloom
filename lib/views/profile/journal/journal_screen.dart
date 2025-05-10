import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/utils/app_colors.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'Journal',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextOne(
              text: 'Your All Journal',
              fontSize: 18.sp,
      
            ),
            SizedBox(height: 10.h,),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Example item count
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: Card(
                      color: AppColors.secondaryColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: ExpansionTile(
                      collapsedIconColor: Colors.white,
                        iconColor: Colors.white,
            backgroundColor: AppColors.profileCardColor,

                        title: CustomTextOne(
                          text: 'Journal Entry ${index + 1}',
                          textAlign: TextAlign.start,

                        ),
                        subtitle: CustomTextTwo(
                          text: 'Short description of the journal...',
                          textAlign: TextAlign.start,
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextTwo(
                                  text: 'Detailed content of journal entry $index.',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                  IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.arrowUpRightFromSquare,color: AppColors.secondaryColor,)),
                                    SizedBox(width: 20.w),
                                    IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.red,)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
