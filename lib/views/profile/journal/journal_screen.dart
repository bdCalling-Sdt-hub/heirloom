import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Controller/profile/journal/journal_controller.dart';
import '../../../global_widgets/custom_text.dart';
import '../../../global_widgets/custom_text_button.dart';
import '../../../global_widgets/dialog.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_colors.dart';


class JournalScreen extends StatelessWidget {
  JournalScreen({super.key});

  final JournalController controller = Get.put(JournalController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Attach listener for scroll pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        // Near bottom, load more
        controller.loadMore();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: 'Journal'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextButton(
              text: "+ Add Journal",
              onTap: () {
                Get.toNamed(AppRoutes.journalAddScreen);
              },
              color: AppColors.settingCardColor,
            ),
            SizedBox(height: 10.h),
            CustomTextOne(text: 'Your All Journal'),
            SizedBox(height: 10.h),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchJournalData(page: 1, isLoadMore: false);
                },
                child: Obx(() {
                  if (controller.isLoading.value && controller.journals.isEmpty) {
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (_, __) => Padding(
                        padding: EdgeInsets.only(bottom: 15.h),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade700,
                          highlightColor: Colors.grey.shade500,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            height: 50.h,
                          ),
                        ),
                      ),
                    );
                  }

                  if (controller.journals.isEmpty) {
                    return const Center(child: Text('No journals found.'));
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: controller.journals.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.journals.length) {
                        return Obx(() => controller.isMoreLoading.value
                            ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                            : const SizedBox.shrink());
                      }

                      final journal = controller.journals[index];
                      final date = DateTime.tryParse(journal['date'] ?? '');

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
                              text: journal['title'] ?? 'No Title',
                              textAlign: TextAlign.start,
                            ),
                            subtitle: CustomTextTwo(
                              text: date != null
                                  ? 'Date: ${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}'
                                  : 'Date not available',
                              textAlign: TextAlign.start,
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(15.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextTwo(
                                      text: journal['content'] ?? '',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Get.toNamed(
                                              AppRoutes.journalAddScreen,
                                              arguments: journal,
                                            );
                                          },
                                          icon: const Icon(
                                            FontAwesomeIcons.penToSquare,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 20.w),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CustomDialog(
                                                  title:
                                                  "Are you sure you want to delete this Journal?",
                                                  subTitle:
                                                  "This journal will be permanently deleted from your account.",
                                                  confirmButtonText: "Delete",
                                                  onCancel: () {
                                                    Get.back();
                                                  },
                                                  onConfirm: () {
                                                    Get.back();
                                                    controller.deleteJournal(journal['_id'] );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
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
                  );
                }),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

