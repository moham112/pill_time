import 'package:flutter/material.dart';
import 'package:pill_time/helper/cache_helper.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final Widget title;
  final VoidCallback? backVCB;

  const PrimaryAppBar({
    super.key,
    this.leading,
    this.actions,
    this.backVCB,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: true,
      leading: InkWell(
          onTap: backVCB ??
              () {
                Navigator.pop(context);
              },
          child: leading ??
              Icon(
                CacheHelper.getData('lang') == 'en'
                    ? Icons.arrow_forward
                    : Icons.arrow_back,
              )),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
