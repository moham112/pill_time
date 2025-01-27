import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterItem extends StatelessWidget {
  final bool isActive;
  final String title;
  final VoidCallback? onTap;

  const FilterItem({
    super.key,
    this.onTap,
    this.isActive = false,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isActive ? Colors.blue : Colors.grey,
              width: 0.5.w,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ));
  }
}
