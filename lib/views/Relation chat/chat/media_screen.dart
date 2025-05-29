import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/utils/app_images.dart';
import 'package:photo_view/photo_view.dart';

import '../../../Controller/relation chat/chat_profile_controller.dart';
import '../../../global_widgets/custom_text.dart';


class MediaScreen extends StatelessWidget {
  final String conversationId;

  const MediaScreen({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    final ChatProfileController controller = Get.put(ChatProfileController(conversationId));

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: 'Media', fontSize: 18.sp),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Obx(() {
          if (controller.isLoading.value) {
            // Show loading shimmer or progress indicator
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.mediaImages.isEmpty) {
            return Center(child: CustomTextOne(text: 'No media found.'));
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!controller.isLoadingMore.value &&
                  scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 100) {
                controller.loadMore();
              }
              return false;
            },
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
              ),
              itemCount: controller.mediaImages.length + (controller.isLoadingMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.mediaImages.length) {
                  return Center(child: CircularProgressIndicator());
                }
                final imageUrl = controller.mediaImages[index];

                return GestureDetector(
                  onTap: () {
                    Get.to(() => PhotoViewScreen(imageUrl: imageUrl));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, color: Colors.red),
                        );
                      },
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

class PhotoViewScreen extends StatelessWidget {
  final String imageUrl;
  const PhotoViewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
