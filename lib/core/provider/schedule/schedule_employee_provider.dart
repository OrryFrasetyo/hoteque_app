import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/model/schedule_employee.dart';
import 'package:hoteque_app/core/data/networking/states/schedule/schedule_employee_result_state.dart';
import 'package:hoteque_app/core/data/repository/schedule_repository.dart';

class ScheduleEmployeeProvider extends ChangeNotifier {
  final ScheduleRepository _scheduleRepository;
  ScheduleEmployeeResultState _state = ScheduleEmployeeInitialState();
  List<ScheduleEmployee> _schedules = [];

  ScheduleEmployeeProvider(this._scheduleRepository);

  ScheduleEmployeeResultState get state => _state;
  List<ScheduleEmployee> get schedules => _schedules;

  Future<void> getScheduleEmployee({required Employee employee}) async {
    try {
      _state = ScheduleEmployeeLoadingState();
      notifyListeners();

      final result = await _scheduleRepository.getAllScheduleEmployee(
        employee: employee,
      );

      if (result.data != null) {
        _schedules =
            result.data!.schedules
                .map((schedule) => ScheduleEmployee.fromSchedule(schedule))
                .toList();

        _schedules.sort((a, b) => a.dateSchedule.compareTo(b.dateSchedule));

        _state = ScheduleEmployeeLoadedState(_schedules);
      } else {
        _state = ScheduleEmployeeErrorState(
          result.message ?? "Failed to load schedules",
        );
      }
    } catch (e) {
      _state = ScheduleEmployeeErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }

  void resetState() {
    _state = ScheduleEmployeeInitialState();
    _schedules = [];
    notifyListeners();
  }
}
