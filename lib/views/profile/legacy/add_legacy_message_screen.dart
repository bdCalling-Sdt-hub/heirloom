import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heirloom/global_widgets/custom_text.dart'; // Assuming you have these custom widgets
import 'package:heirloom/global_widgets/custom_text_button.dart';
import 'package:heirloom/utils/app_colors.dart'; // Custom colors
import 'package:intl/intl.dart';

import '../../../global_widgets/custom_text_field.dart'; // For date formatting

class AddLegacyMessageScreen extends StatefulWidget {
  const AddLegacyMessageScreen({super.key});

  @override
  _AddLegacyMessageScreenState createState() => _AddLegacyMessageScreenState();
}

class _AddLegacyMessageScreenState extends State<AddLegacyMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _recipient = "Alja"; // Default value, can be dynamic
  DateTime? _deliveryDate;

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
          text: 'Legacy Message',
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
                text: 'Recipient',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),

              CustomTextField(
                controller: _recipientController,
                hintText: 'Search or select recipient',
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),

              // Delivery Trigger (Date Picker)
              CustomTextOne(
                text: 'Delivery Trigger',
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
                hintText: 'Type your legacy message...',
                maxLine: 5,
                maxLength: 120,
              ),

              SizedBox(
                height: 20.h,
              ),
              // Compose Legacy Button
              CustomTextButton(text: 'Compose Legacy', onTap: () {})
            ],
          ),
        ),
      ),
    );
  }
}
