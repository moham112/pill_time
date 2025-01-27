import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryTextField extends StatelessWidget {
  const PrimaryTextField({
    super.key,
    required this.hint,
    this.controller,
    this.validator,
    this.obsecure = false,
  });

  final String hint;
  final TextEditingController? controller;

  final String? Function(String?)? validator;

  final bool obsecure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecure,
      validator: validator,
      style: TextStyle(fontSize: 14.sp),
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            EdgeInsetsDirectional.symmetric(horizontal: 15.w, vertical: 10.h),
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodySmall,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.r),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.r),
          borderSide: BorderSide(color: Colors.blue),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.r),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
