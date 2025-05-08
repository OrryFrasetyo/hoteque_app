import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/schedule.dart';
import 'package:hoteque_app/core/data/networking/states/schedule/schedule_now_employee_result_state.dart';
import 'package:hoteque_app/core/data/repository/schedule_repository.dart';

class ScheduleNowProvider extends ChangeNotifier {
  final ScheduleRepository _scheduleRepository;
  ScheduleNowEmployeeResultState _state = ScheduleNowEmployeeInitialState();

  Schedule? _todaySchedule;

  ScheduleNowProvider(this._scheduleRepository);

  ScheduleNowEmployeeResultState get state => _state;
  Schedule? get todaySchedule => _todaySchedule;

  // Getter untuk memudahkan akses data di UI
  String get shiftType => _todaySchedule?.shift.type ?? "Tidak Ada Shift";
  String get scheduleTime {
    if (_todaySchedule == null) return "-- : -- - -- : --";
    return "${_todaySchedule!.shift.startTime} - ${_todaySchedule!.shift.endTime}";
  }

  Future<void> getTodaySchedule({required Employee employee}) async {
    try {
      _state = ScheduleNowEmployeeLoadingState();
      notifyListeners();

      // Delay kecil untuk memastikan UI diperbarui
      await Future.delayed(const Duration(milliseconds: 100));

      final result = await _scheduleRepository.getScheduleNowEmployee(
        employee: employee,
      );

      if (result.data != null && !result.data!.error) {
        _todaySchedule = result.data!.schedule;
        _state = ScheduleNowEmployeeLoadedState([_todaySchedule!]);
      } else {
        _state = ScheduleNowEmployeeErrorState(
          result.message ?? "Gagal memuat jadwal hari ini",
        );
      }
    } catch (e) {
      _state = ScheduleNowEmployeeErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }

  // Method untuk reset state saat logout
  void resetState() {
    _state = ScheduleNowEmployeeInitialState();
    _todaySchedule = null;
    notifyListeners();
  }
  
}