import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Controller/profile/legacy/legacy_controller.dart';
import '../../../global_widgets/custom_text.dart';
import '../../../global_widgets/custom_text_button.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../utils/app_colors.dart';

class AddLegacyMessageScreen extends StatefulWidget {
  final Map<String, dynamic>? existingLegacy; // For edit mode, pass existing legacy

  const AddLegacyMessageScreen({Key? key, this.existingLegacy}) : super(key: key);

  @override
  _AddLegacyMessageScreenState createState() => _AddLegacyMessageScreenState();
}

class _AddLegacyMessageScreenState extends State<AddLegacyMessageScreen> {
  final LegacyController controller = Get.find<LegacyController>();

  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _recipientSearchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  List<String> selectedRecipients = [];

  bool get isEditing => widget.existingLegacy != null;
  String? get editingLegacyId => widget.existingLegacy?['_id'];

  @override
  void initState() {
    super.initState();

    // Fetch all friends initially
    controller.fetchFriends();

    if (isEditing) {
      final legacy = widget.existingLegacy!;

      _messageController.text = legacy['message'] ?? '';

      if (legacy['recipients'] != null) {
        selectedRecipients = List<String>.from(
          (legacy['recipients'] as List).map((r) => r['_id'].toString()),
        );
        _recipientSearchController.text = (legacy['recipients'] as List)
            .map((r) => r['name'] ?? 'Unknown')
            .join(', ');
      }

      final timeStr = legacy['time'] ?? legacy['triggerDate'];
      if (timeStr != null) {
        try {
          final dt = DateTime.parse(timeStr);
          _selectedDate = dt;
          _selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
          _dateController.text = DateFormat('MM/dd/yyyy').format(dt);
          _timeController.text = DateFormat.jm().format(dt);
        } catch (_) {}
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? now,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        final localizations = MaterialLocalizations.of(context);
        _timeController.text = localizations.formatTimeOfDay(picked, alwaysUse24HourFormat: false);
      });
    }
  }

  String? getCombinedDateTimeIso() {
    if (_selectedDate == null) return null;

    final date = _selectedDate!;
    final time = _selectedTime ?? TimeOfDay(hour: 0, minute: 0);

    final combined = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    return combined.toUtc().toIso8601String();
  }

  void _onSearchChanged(String query) {
    controller.fetchFriends(search: query);
  }

  void _toggleRecipientSelection(String id) {
    setState(() {
      if (selectedRecipients.contains(id)) {
        selectedRecipients.remove(id);
      } else {
        selectedRecipients.add(id);
      }
    });
  }

  Widget _buildRecipientList() {
    return Obx(() {
      if (controller.isFriendsLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.friends.isEmpty) {
        return CustomTextTwo(text: "No recipients found");
      }

      return SizedBox(
        height: 100.h,
        child: ListView.builder(
          itemCount: controller.friends.length,
          itemBuilder: (context, index) {
            final friend = controller.friends[index];
            final friendId = friend['_id'].toString();
            final isSelected = selectedRecipients.contains(friendId);

            return Card(
              color: AppColors.settingCardColor,
              child: ListTile(
                title: CustomTextTwo(text:friend['name'] ?? 'Unknown',textAlign: TextAlign.start,),
                trailing: isSelected
                    ? Icon(Icons.check_box, color: AppColors.secondaryColor)
                    : Icon(Icons.check_box_outline_blank),
                onTap: () => _toggleRecipientSelection(friendId),
              ),
            );
          },
        ),
      );
    });
  }

  Future<void> _submitLegacyMessage() async {
    final triggerDate = getCombinedDateTimeIso();
    final message = _messageController.text.trim();

    if (selectedRecipients.isEmpty) {
      Get.snackbar("!!!", "Please select at least one recipient");
      return;
    }

    if (triggerDate == null) {
      Get.snackbar("!!!", "Please select delivery date and time");
      return;
    }

    if (message.isEmpty) {
      Get.snackbar("!!!", "Message cannot be empty");
      return;
    }

    bool success;

    if (isEditing) {
      success = await controller.editLegacyMessage(
        legacyId: editingLegacyId!,
        recipients: selectedRecipients,
        triggerDateIso: triggerDate,
       message: message,

      );
    } else {
      success = await controller.addLegacyMessage(
        recipients: selectedRecipients,
        triggerDateIso: triggerDate,
        message: message,
      );
    }

    if (success) {
      Get.back();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _recipientSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: isEditing ? 'Edit Legacy Message' : 'Add Legacy Message'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20.h,
            children: [
              CustomTextOne(text: 'Recipients', fontSize: 16.sp, fontWeight: FontWeight.w500),

              CustomTextField(
                controller: _recipientSearchController,
                hintText: 'Search recipients',
                suffixIcon: Icon(Icons.search, color: Colors.white),
                onChanged: _onSearchChanged,
              ),



              _buildRecipientList(),



              CustomTextOne(text: 'Delivery Trigger', fontSize: 16.sp, fontWeight: FontWeight.w500),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _dateController,
                      hintText: 'MM/DD/YYYY',
                      readOnly: true,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_month, color: Colors.white),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomTextField(
                      controller: _timeController,
                      hintText: '10:00 AM',
                      readOnly: true,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.access_time_outlined, color: Colors.white),
                        onPressed: () => _selectTime(context),
                      ),
                    ),
                  ),
                ],
              ),


              CustomTextOne(text: 'Message', fontSize: 16.sp, fontWeight: FontWeight.w500),

              CustomTextField(
                controller: _messageController,
                hintText: 'Type your legacy message...',
                maxLine: 5,
                maxLength: 120,
              ),



              CustomTextButton(
                text: isEditing ? 'Update Legacy' : 'Compose Legacy',
                onTap: _submitLegacyMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
