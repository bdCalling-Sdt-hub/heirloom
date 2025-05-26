import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heirloom/Controller/profile/journal/journal_controller.dart';
import 'package:heirloom/global_widgets/custom_text.dart'; // Assuming you have these custom widgets
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/utils/app_colors.dart'; // Custom colors
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../global_widgets/custom_text_field.dart'; // For date formatting

class JournalAddScreen extends StatefulWidget {
  const JournalAddScreen({super.key});

  @override
  _JournalAddScreenState createState() => _JournalAddScreenState();
}

class _JournalAddScreenState extends State<JournalAddScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final JournalController journalController = Get.find<JournalController>();
  DateTime? _selectedDate;
  String? editingJournalId;

  @override
  void initState() {
    super.initState();
    final journal = Get.arguments;
    if (journal != null) {
      // We are editing
      editingJournalId = journal['_id'];
      _titleController.text = journal['title'] ?? '';
      _messageController.text = journal['content'] ?? '';
      if (journal['date'] != null) {
        _selectedDate = DateTime.tryParse(journal['date']);
        if (_selectedDate != null) {
          _dateController.text =
              DateFormat('MM/dd/yyyy').format(_selectedDate!);
        }
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(2020);
    final lastDate = DateTime(2101);

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  void _submit() {
    final title = _titleController.text.trim();
    final content = _messageController.text.trim();
    final dateText = _dateController.text.trim();

    if (title.isEmpty || content.isEmpty || dateText.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    if (editingJournalId != null) {
      // Update existing
      journalController
          .updateJournal(
        title,
        dateText,
        content,
        editingJournalId!,
      )
          .then((_) {
        Get.back(); // Return to journal list
      });
    } else {
      // Create new
      journalController.createJournal(title, dateText, content).then((_) {
        Get.back();
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _dateController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = editingJournalId != null;

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: isEditing ? 'Edit Journal' : 'Add Journal'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextOne(
              text: 'Title',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
            CustomTextField(
              controller: _titleController,
              hintText: 'Enter your title',
            ),
            SizedBox(height: 20.h),
            CustomTextOne(
              text: 'Date',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
            CustomTextField(
              controller: _dateController,
              hintText: 'MM/DD/YYYY',
              readOnly: true,
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_month, color: Colors.white),
                onPressed: () => _selectDate(context),
              ),
            ),
            SizedBox(height: 20.h),
            CustomTextOne(
              text: 'Messages',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
            Obx(() {
              if (journalController.enhanceJournalLoading.value) {
                // Show shimmer while enhancing
                return Container(
                  width: double.infinity,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade700,
                    highlightColor: Colors.grey.shade500,
                    child: Container(

                      decoration: BoxDecoration(

                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.all(Radius.circular(16.r))),
                    ),
                  ),
                );
              } else {
                // Show normal text field
                return CustomTextField(
                  controller: _messageController,
                  hintText: 'Type your journal message...',
                  maxLine: 5,
                );
              }
            }),
            SizedBox(height: 10.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextTwo(text: "Enhance With Ai"),
                SizedBox(
                  width: 80.w,
                  child: CustomTextButton(
                    text: "✨Enhance",
                    onTap: () async {
                      if (_messageController.text.isNotEmpty) {
                        final enhancedContent = await journalController.enhanceJournal(_messageController.text);
                        if (enhancedContent != null) {
                          setState(() {
                            _messageController.text = enhancedContent;
                          });
                        }
                      } else {
                        Get.snackbar("Alert", "Please enter your message first!");
                      }
                    },
                    fontSize: 12.sp,
                    padding: 0,
                    radius: 8,
                    color: AppColors.settingCardColor,
                  ),

                ),
              ],
            ),
            SizedBox(height: 30.h),
            Obx(() {
              final loading = isEditing
                  ? journalController.updateJournalLoading.value
                  : journalController.addJournalLoading.value;
              return CustomTextButton(
                text: isEditing ? 'Update Journal' : 'Compose Journal',
                isLoading: loading,
                onTap: loading ? () {} : _submit,
              );
            }),
          ],
        ),
      ),
    );
  }
}
