import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pill_time/data/webservice/reminder.dart';
import 'package:pill_time/helper/constants.dart';
import 'package:pill_time/logic/auth_provider.dart';
import 'package:pill_time/logic/reminder_provider.dart';
import 'package:pill_time/presentation/widget/filter_item.dart';
import 'package:pill_time/presentation/widget/prrimary_app_bar.dart';
import 'package:pill_time/presentation/widget/reminder_element.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Reminder> remindersList = [];
  final ScrollController _remindersScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getReminders();
    _remindersScrollController.addListener(() {
      if (_remindersScrollController.position.pixels ==
          _remindersScrollController.position.maxScrollExtent) {
        getReminders();
      }
    });
  }

  void getReminders() {
    Provider.of<ReminderProvider>(context, listen: false).updateReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: Text('your_reminders'.tr()),
        leading: Icon(Icons.login_outlined),
        backVCB: () {
          _logout(context);
        },
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/user_profile');
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: CircleAvatar(
                radius: 20.w,
                backgroundImage: NetworkImage(
                  context.watch<AuthProvider>().user.profilePicture,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10.h, left: 23.w, right: 23.w),
        child: Column(
          children: [
            _searchTextField(),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                filter.length,
                (index) {
                  return FilterItem(
                    onTap: () {
                      Provider.of<ReminderProvider>(context, listen: false)
                          .filterReminders(filter[index]);
                    },
                    title: filter[index].tr(),
                    isActive: index == 0,
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
            Flexible(
              child: SingleChildScrollView(
                controller: _remindersScrollController,
                child: Consumer<ReminderProvider>(
                  builder: (context, value, child) => ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: value.customizedReminders.isNotEmpty
                        ? value.customizedReminders.length
                        : value.reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = value.customizedReminders.isNotEmpty
                          ? value.customizedReminders[index]
                          : value.reminders[index];
                      return InkWell(
                        child: ReminderElement(
                          reminder: reminder,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_reminder');
        },
        backgroundColor: Colors.blueAccent, // Set the background color to blue
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    try {
      await Provider.of<AuthProvider>(context, listen: false).logout();
      Provider.of<ReminderProvider>(context, listen: false).clearReminders();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No Connection"),
        ));
      }
    }
  }

  TextFormField _searchTextField() {
    return TextFormField(
      style: TextStyle(
        fontSize: 12.sp,
      ),
      onChanged: (value) {
        Provider.of<ReminderProvider>(context, listen: false)
            .searchForReminder(value);
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 0.1.w,
          ),
        ),
        hintText: 'search'.tr().toString(),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 12.sp,
        ),
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
