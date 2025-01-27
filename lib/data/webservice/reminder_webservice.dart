import 'package:dio/dio.dart';
import 'package:pill_time/helper/dio_helper.dart';

class ReminderWebService {
  final DioHelper _dioHelper = DioHelper();

  Future<Response> getAllReminders(int page) async {
    return await _dioHelper.get('/doseReminder',
        needAuthrization: true, queryParameters: {'page': page});
  }

  Future<Response> getReminder(String id) async {
    return await _dioHelper.get('/doseReminder/$id', needAuthrization: true);
  }

  Future<Response> createReminder(Map<String, dynamic> data) async {
    return await _dioHelper.post('/doseReminder',
        data: data, needAuthrization: true);
  }

  Future<Response> deleteReminder(String id) async {
    return await _dioHelper.delete('/doseReminder/$id', needAuthrization: true);
  }

  Future<Response> favoriteReminder(String id) async {
    return await _dioHelper.put('/doseReminder/$id/favorite',
        data: {'id': id, 'favorite': true}, needAuthrization: true);
  }
}
