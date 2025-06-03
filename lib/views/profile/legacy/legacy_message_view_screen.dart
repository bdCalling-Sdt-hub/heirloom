 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heirloom/global_widgets/custom_text.dart';
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/utils/app_colors.dart';
import 'package:get/get.dart';

 import 'package:intl/intl.dart';

 import '../../../Controller/profile/legacy/legacy_controller.dart';
import '../../../global_widgets/custom_no_data_widget.dart';


 class LegacyMessageViewScreen extends StatefulWidget {
   const LegacyMessageViewScreen({super.key});

   @override
   _LegacyMessageViewScreenState createState() => _LegacyMessageViewScreenState();
 }

 class _LegacyMessageViewScreenState extends State<LegacyMessageViewScreen> {
   final LegacyController controller = Get.find<LegacyController>();

   @override
   void initState() {
     super.initState();
     controller.fetchTriggeredLegacyMessages();
   }

   void _viewMessage(String fullMessage) {
     showDialog(
       context: context,
       builder: (_) => AlertDialog(
         title: CustomTextOne(text: 'Full Message', color: Colors.black),
         content: SingleChildScrollView(
           child: CustomTextTwo(text: fullMessage, color: Colors.black, textAlign: TextAlign.start),
         ),
         actions: [
           CustomTextButton(text: "Close", onTap: () => Get.back()),
         ],
       ),
     );
   }

   String formatDate(String dateStr) {
     try {
       final dt = DateTime.parse(dateStr);
       return DateFormat('dd/MM/yyyy').format(dt);
     } catch (_) {
       return dateStr;
     }
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: CustomTextOne(
           text: 'Legacy Messages',
           fontSize: 20.sp,
           fontWeight: FontWeight.w600,
           color: Colors.white,
         ),
         backgroundColor: AppColors.primaryColor,
         elevation: 0,
       ),
       body: Padding(
         padding: EdgeInsets.all(15.w),
         child: Obx(() {
           if (controller.isTriggeredLoading.value && controller.triggeredLegacyMessages.isEmpty) {
             return Center(child: CircularProgressIndicator());
           }

           if (controller.triggeredLegacyMessages.isEmpty) {
             return CustomNoDataWidget(text: "No Legacy Message found.",);
           }

           return NotificationListener<ScrollNotification>(
             onNotification: (scrollInfo) {
               if (!controller.isTriggeredMoreLoading.value &&
                   scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                 controller.loadMoreTriggeredLegacyMessages();
               }
               return false;
             },
             child: ListView.builder(
               itemCount: controller.triggeredLegacyMessages.length + (controller.isTriggeredMoreLoading.value ? 1 : 0),
               itemBuilder: (context, index) {
                 if (index == controller.triggeredLegacyMessages.length) {
                   return Center(
                     child: Padding(
                       padding: EdgeInsets.symmetric(vertical: 10.h),
                       child: CircularProgressIndicator(),
                     ),
                   );
                 }

                 final legacyMessage = controller.triggeredLegacyMessages[index];
                 final previewMessage = legacyMessage['message'] ?? '';
                 final fullMessage = previewMessage;

                 return Padding(
                   padding: EdgeInsets.only(bottom: 15.h),
                   child: Card(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(12.r),
                     ),
                     color: AppColors.cardColor.withOpacity(0.4),
                     elevation: 4,
                     child: Padding(
                       padding: EdgeInsets.all(15.w),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Flexible(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 CustomTextOne(
                                   text: '🎀${legacyMessage['title'] ?? 'Unknown'}',
                                   fontSize: 16.sp,
                                   textAlign: TextAlign.start,
                                 ),
                                 CustomTextTwo(
                                   text: '"$previewMessage"',
                                   fontSize: 14.sp,
                                   color: AppColors.textColor,
                                   textAlign: TextAlign.start,
                                 ),
                                 CustomTextTwo(
                                   text: formatDate(legacyMessage['time']),
                                   fontSize: 12.sp,
                                   color: AppColors.textColor.withOpacity(0.5),
                                 ),
                               ],
                             ),
                           ),
                           IconButton(
                             icon: Icon(Icons.visibility, color: AppColors.secondaryColor),
                             onPressed: () => _viewMessage(fullMessage),
                           ),
                         ],
                       ),
                     ),
                   ),
                 );
               },
             ),
           );
         }),
       ),
     );
   }
 }



