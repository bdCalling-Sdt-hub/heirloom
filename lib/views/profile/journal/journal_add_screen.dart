import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heirloom/global_widgets/custom_text.dart'; // Assuming you have these custom widgets
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/utils/app_colors.dart'; // Custom colors
import 'package:intl/intl.dart';
import 'package:get/get.dart';
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
  DateTime? _deliveryDate;
  bool switchValue = false;
  // Method to pick the date
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2020);
    DateTime lastDate = DateTime(2101);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null && picked != _deliveryDate) {
      setState(() {
        _deliveryDate = picked;
        _dateController.text =
            DateFormat('MM/dd/yyyy').format(_deliveryDate!); // Format date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'Add Journal',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15.h,
            children: [
              // Recipient Field (Search/Select recipient)
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

              // Delivery Trigger (Date Picker)
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
                  icon: Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ),
                  onPressed: () => _selectDate(context),
                ),
              ),

              // Message Field
              CustomTextOne(
                text: 'Messages',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),

              CustomTextField(
                controller: _messageController,
                hintText: 'Type your journal message...',
                maxLine: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextTwo(text: "Enhance With Ai"),
                  SizedBox(
                      width: 80.w,
                      child: CustomTextButton(
                        text: "✨Enhance",
                        onTap: () {

                        },
                        fontSize: 12.sp,
                        padding: 0,
                        radius: 8,

                        color: AppColors.settingCardColor,
                      )),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              // Compose Legacy Button
              CustomTextButton(text: 'Compose Journal', onTap: () {})
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
    _dateController.dispose();
    _titleController.dispose();
  }
}
