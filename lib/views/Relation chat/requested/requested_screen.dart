import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/global_widgets/custom_no_data_widget.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Controller/relation chat/friend requested/ requested_controller.dart';
import '../../../global_widgets/custom_chat_title.dart';
import '../../../global_widgets/custom_text.dart';
import '../../../global_widgets/custom_text_button.dart';
import '../../../services/api_constants.dart';
import '../../../utils/app_images.dart';


class RequestedScreen extends StatefulWidget {
  const RequestedScreen({super.key});

  @override
  State<RequestedScreen> createState() => _RequestedScreenState();
}

class _RequestedScreenState extends State<RequestedScreen> {
  final RequestedController controller = Get.put(RequestedController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchRequests(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Obx(() {
          if (controller.isLoading.value && controller.requests.isEmpty) {
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    children: [
                      Container(
                        width: 40.r,
                        height: 40.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 14.h, color: Colors.white, margin: EdgeInsets.symmetric(vertical: 4.h)),
                            Container(height: 14.h, width: 150.w, color: Colors.white),
                          ],
                        ),
                      ),
                      Container(width: 30.w, height: 14.h, color: Colors.white),
                    ],
                  ),
                ),
              ),
            );
          }

          if (controller.requests.isEmpty) {
            return CustomNoDataWidget(text: "No Requests Found");
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (!controller.isMoreLoading.value &&
                  scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                controller.loadMore();
              }
              return false;
            },
            child: ListView.builder(
              itemCount: controller.requests.length + (controller.isMoreLoading.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.requests.length) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final request = controller.requests[index];

                return InkWell(
                  onTap: () => _showRequestBottomSheet(context, request),
                  child: CustomChatTile(
                    title: request['name'] ?? 'No Name',
                    subTitle: "@${request['username'] ?? ''}",
                    img: request['image'] != null && request['image'].isNotEmpty
                        ? (request['image'].startsWith('http')
                        ? request['image']
                        : '${ApiConstants.imageBaseUrl}${request['image']}')
                        : AppImages.model,
                    time: CustomTextTwo(text: formatRequestTime(request['time'])),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  String formatRequestTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(timeString);
      return DateFormat('dd/MM/yy, hh:mm a').format(dateTime);
    } catch (e) {
      return timeString;
    }
  }

  void _showRequestBottomSheet(BuildContext context, Map<String, dynamic> request) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextOne(text: "Confirm Request"),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                CircleAvatar(
                  radius: 40.r,
                  backgroundImage: request['image'] != null && request['image'].isNotEmpty
                      ? (request['image'].startsWith('http')
                      ? NetworkImage(request['image'])
                      : NetworkImage('${ApiConstants.imageBaseUrl}${request['image']}'))
                      : AssetImage(AppImages.model) as ImageProvider,
                ),
                SizedBox(height: 10.h),
                CustomTextOne(text: request['name'] ?? ''),
                SizedBox(height: 5.h),
                CustomTextTwo(
                  text: '${request['name'] ?? ''} is awaiting your response to their connection request.',
                ),
                SizedBox(height: 5.h),
                CustomTextTwo(text: '${request['name'] ?? ''} wants to connect with you.'),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: CustomTextButton(
                        text: "Reject",
                        onTap: () async {
                          await controller.actionRequest(request['_id'], 'rejected');
                          Get.back();
                        },
                        color: Colors.red,
                        padding: 4.r,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Flexible(
                      child: CustomTextButton(
                        text: "Accept",
                        onTap: () async {
                          await controller.actionRequest(request['_id'], 'accepted');
                          Get.back();
                        },
                        color: Colors.green,
                        padding: 4.r,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
