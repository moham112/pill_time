import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pill_time/logic/reminder_provider.dart';
import 'package:pill_time/presentation/widget/primary_button.dart';
import 'package:pill_time/presentation/widget/primary_text_area.dart';
import 'package:pill_time/presentation/widget/primary_text_field.dart';
import 'package:pill_time/presentation/widget/prrimary_app_bar.dart';
import 'package:provider/provider.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  AddReminderScreenState createState() => AddReminderScreenState();
}

class AddReminderScreenState extends State<AddReminderScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _numberOfTimesController =
      TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? _selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: Text('add_reminder'.tr().toString()),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 35.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('reminder_title'.tr().toString()),
            SizedBox(height: 5.h),
            PrimaryTextField(
              hint: '',
              controller: _nameController,
            ),
            SizedBox(height: 20.h),
            Text('number_of_times'.tr().toString()),
            SizedBox(height: 5.h),
            PrimaryTextField(
              hint: '',
              controller: _numberOfTimesController,
            ),
            SizedBox(height: 20.h),
            InkWell(
              onTap: _pickStartDate,
              child: Container(
                padding: EdgeInsets.all(15.w), // Added screen util here
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.blue),
                    SizedBox(width: 10.w),
                    Text(_startDate != null
                        ? dateFormat.format(_startDate!)
                        : 'start_date'.tr().toString()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            InkWell(
              onTap: _pickEndDate,
              child: Container(
                padding: EdgeInsets.all(15.w), // Added screen util here
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.blue),
                    SizedBox(width: 10.w),
                    Text(_endDate != null
                        ? dateFormat.format(_endDate!)
                        : 'end_date'.tr().toString()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            InkWell(
              onTap: _pickDateTime,
              child: Container(
                padding: EdgeInsets.all(15.w), // Added screen util here
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.blue),
                    SizedBox(width: 10.w),
                    Text(
                      _selectedDateTime != null
                          ? DateFormat('yyyy-MM-dd HH:mm')
                              .format(_selectedDateTime!)
                          : 'last_dose_time'.tr().toString(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text('note'.tr().toString()),
            SizedBox(height: 5.h),
            PrimaryTextArea(
              hint: '',
              maxLines: 5,
              controller: _noteController,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'add'.tr().toString(),
                onPressed: _addReminder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  Future<void> _pickEndDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _endDate) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _addReminder() async {
    final data = {
      "number_of_times": int.parse(_numberOfTimesController.text),
      "starts": _startDate != null ? dateFormat.format(_startDate!) : null,
      "ends": _endDate != null ? dateFormat.format(_endDate!) : null,
      "name": _nameController.text,
      "note": _noteController.text,
      "first_dose_time": _selectedDateTime != null
          ? DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)
          : null
    };
    try {
      await Provider.of<ReminderProvider>(context, listen: false)
          .addReminder(data);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('reminder_created'.tr().toString()),
      ));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('error_occured'.tr().toString()),
        ));
        Navigator.pop(context);
      }
    }
  }
}
