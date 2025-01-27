import 'package:flutter/material.dart';
import 'package:pill_time/data/webservice/reminder.dart';
import 'package:pill_time/data/webservice/reminder_webservice.dart';

class ReminderProvider extends ChangeNotifier {
  ReminderWebService reminderWebService;
  List<Reminder> reminders = [];
  List<Reminder> customizedReminders = [];
  int _reminderStartPage = 1;

  ReminderProvider({required this.reminderWebService});

  Future<Reminder> getReminder(String id) async {
    late Reminder reminder;
    await reminderWebService.getReminder(id).then((value) {
      reminder = Reminder.fromJson(value.data);
    });

    return reminder;
  }

  Future<Reminder> addReminder(Map<String, dynamic> data) async {
    late Reminder reminder;
    final response = await reminderWebService.createReminder(data);
    reminder = Reminder.fromJson(response.data['data']);
    reminders.add(reminder);
    notifyListeners();

    return reminder;
  }

  Future<void> deleteReminder(String id) async {
    final respnose = await reminderWebService.deleteReminder(id);

    if (reminders.isNotEmpty &&
        reminders.any((element) => element.id == int.parse(id)) &&
        respnose.statusCode == 200) {
      reminders.removeWhere((element) {
        return element.id == int.parse(id);
      });
    }

    notifyListeners();
  }

  Future<void> updateReminders() async {
    await reminderWebService.getAllReminders(_reminderStartPage).then((value) {
      if (value.data['data'].isNotEmpty) {
        for (var item in value.data['data']) {
          reminders.add(Reminder.fromJson(item));
        }
        _reminderStartPage++;
      }
    });

    notifyListeners();
  }

  void searchForReminder(String query) {
    customizedReminders = reminders
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    notifyListeners();
  }

  void clearReminders() {
    reminders.clear();
  }

  void updateFavoriteStatus(String id, bool isFavorited) {
    reminderWebService.favoriteReminder(id);
    for (var element in reminders) {
      if (element.id.toString() == id) {
        element.isFavorited = isFavorited;
      }
    }
    for (var element in customizedReminders) {
      if (element.id.toString() == id) {
        element.isFavorited = isFavorited;
      }
    }
    notifyListeners();
  }

  void filterReminders(String filter) {
    if (filter == 'all') {
      customizedReminders = reminders;
    } else if (filter == 'favorites') {
      customizedReminders =
          reminders.where((element) => element.isFavorited).toList();
      debugPrint('customizedReminders: $customizedReminders');
      for (var reminder in customizedReminders) {
        debugPrint('Reminder: ${reminder.toJson()}');
      }
    }

    notifyListeners();
  }
}
