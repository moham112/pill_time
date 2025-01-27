import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pill_time/presentation/widget/primary_text_field.dart';

class PrimaryTextArea extends PrimaryTextField {
  final int maxLines;
  const PrimaryTextArea({
    super.key,
    super.controller,
    required super.hint,
    required this.maxLines,
  }) : super(obsecure: false);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        fontSize: 14.sp,
      ),
      controller: controller,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.grey),
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      maxLines: maxLines, // Allows the text area to expand vertically
    );
  }
}
