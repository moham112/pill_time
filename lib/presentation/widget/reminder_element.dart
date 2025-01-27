import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pill_time/logic/reminder_provider.dart';
import 'package:provider/provider.dart';
import 'package:pill_time/data/webservice/reminder.dart';

class ReminderElement extends StatefulWidget {
  final Reminder reminder;

  const ReminderElement({
    super.key,
    required this.reminder,
  });

  @override
  ReminderElementState createState() => ReminderElementState();
}

class ReminderElementState extends State<ReminderElement> {
  late bool _isFavorited;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.reminder.isFavorited;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
    Provider.of<ReminderProvider>(context, listen: false)
        .updateFavoriteStatus(widget.reminder.id.toString(), _isFavorited);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(
            color: Colors.grey,
            width: 0.1.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.reminder.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    widget.reminder.dosesTaken == widget.reminder.dosesTotal
                        ? Icon(
                            Icons.done,
                            size: 18.sp, // Smaller icon size
                            color: Colors.blue,
                          )
                        : Text(
                            '${widget.reminder.dosesTaken}/${widget.reminder.dosesTotal}', // Counter in the form number/number
                            style: TextStyle(
                              fontSize: 14.sp, // Smaller font size
                            ),
                          ),
                    SizedBox(
                        width: 8.w), // Space between counter and menu button
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        size: 18.sp, // Smaller icon size
                      ),
                      onSelected: (String result) async {
                        switch (result) {
                          case 'Delete':
                            await Provider.of<ReminderProvider>(context,
                                    listen: false)
                                .deleteReminder(widget.reminder.id.toString());
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Text(
                widget.reminder.note,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text("From ${widget.reminder.starts} to ${widget.reminder.ends}"),
            Text(
              widget.reminder.dosesTotal != widget.reminder.dosesTaken
                  ? 'Next dose in: ${widget.reminder.getNextDoseIn()}'
                  : 'Finished',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: _toggleFavorite,
                child: Icon(
                  _isFavorited ? Icons.star : Icons.star_border,
                  color: _isFavorited ? Colors.yellow : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
