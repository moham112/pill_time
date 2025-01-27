import 'package:intl/intl.dart';

class Reminder {
  final int id;
  final int numberOfTimes;
  final String starts;
  final String ends;
  final String name;
  final String note;
  final String firstDoseTime;
  String nextTimeDose;
  int dosesTotal;
  int dosesTaken;
  bool isFavorited;

  Reminder({
    required this.id,
    required this.numberOfTimes,
    required this.starts,
    required this.ends,
    required this.name,
    required this.note,
    required this.firstDoseTime,
    required this.isFavorited,
    required this.dosesTaken,
    required this.dosesTotal,
    required this.nextTimeDose,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      numberOfTimes: int.parse(json['number_of_times'].toString()),
      firstDoseTime: json['first_dose_time'],
      starts: json['starts'],
      ends: json['ends'],
      name: json['name'],
      note: json['note'],
      isFavorited: json['favorite'] == 1,
      dosesTaken: json['doses_taken'],
      dosesTotal: json['doses_total'],
      nextTimeDose: json['next_dose_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_dose_time': firstDoseTime,
      'number_of_times': numberOfTimes,
      'starts': starts,
      'ends': ends,
      'name': name,
      'note': note,
      'favorite': isFavorited,
      'doses_taken': dosesTaken,
      'doses_total': dosesTotal,
      'next_dose_time': nextTimeDose,
    };
  }

  String getNextDoseIn() {
    final now = DateTime.now();
    final nextDoseDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(nextTimeDose);

    if (nextDoseDateTime.isBefore(now)) {
      // Calculate the next dose time based on the interval and number of times per day
      final interval = Duration(hours: 24 ~/ numberOfTimes);
      var nextDose = nextDoseDateTime;

      while (nextDose.isBefore(now)) {
        nextDose = nextDose.add(interval);
      }

      final duration = nextDose.difference(now);
      return _formatDuration(duration);
    } else {
      final duration = nextDoseDateTime.difference(now);
      return _formatDuration(duration);
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}
