import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/schedule_department_employee_response.dart';
import 'package:hoteque_app/core/data/networking/states/schedule_department_result_state.dart';
import 'package:hoteque_app/core/data/repository/schedule_repository.dart';
import 'package:intl/intl.dart';

class ScheduleDepartmentProvider extends ChangeNotifier {
  final ScheduleRepository _repository;

  ScheduleDepartmentResultState _state = ScheduleDepartmentInitialState();
  ScheduleDepartmentResultState get state => _state;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  ScheduleDepartmentEmployeeResponse? _response;
  ScheduleDepartmentEmployeeResponse? get response => _response;

  List<Schedule> _schedules = [];
  List<Schedule> get schedules => _schedules;

  Meta? _meta;
  Meta? get meta => _meta;

  ScheduleDepartmentProvider(this._repository);

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> fetchSchedules(Employee employee) async {
    try {
      _state = ScheduleDepartmentLoadingState();
      notifyListeners();

      // Format date to yyyy-MM-dd for API
      final formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate);

      final result = await _repository.getScheduleDepartment(
        employee: employee,
        date: formattedDate,
      );

      if (result.message != null) {
        //ada pesan error
        _state = ScheduleDepartmentErrorState(result.message!);
      } else if (result.data != null) {
        // Berhasil mendapatkan data
        _response = result.data;
        _schedules = _response!.schedules;
        _meta = _response!.meta;

        _state = ScheduleDepartmentLoadedState(_schedules, _meta!);
      } else {
        _state = ScheduleDepartmentErrorState("Tidak ada data yang ditemukan");
      }
    } catch (e) {
      _state = ScheduleDepartmentErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }

  void resetState() {
    _state = ScheduleDepartmentInitialState();
    notifyListeners();
  }
}
