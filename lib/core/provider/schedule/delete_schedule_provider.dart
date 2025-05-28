import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/states/schedule/delete_schedule_result_state.dart';
import 'package:hoteque_app/core/data/repository/schedule_repository.dart';

class DeleteScheduleProvider extends ChangeNotifier {
  final ScheduleRepository _repository;
  DeleteScheduleResultState _state = DeleteScheduleInitialState();

  DeleteScheduleProvider(this._repository);

  DeleteScheduleResultState get state => _state;

  Future<bool> deleteSchedule({
    required Employee employee,
    required int scheduleId,
  }) async {
    try {
      _state = DeleteScheduleLoadingState();
      notifyListeners();

      final result = await _repository.deleteScheduleEmployee(
        employee: employee,
        scheduleId: scheduleId,
      );

      if (result.data != null) {
        _state = DeleteScheduleSuccessState(result.data!);
        notifyListeners();
        return true;
      } else {
        _state = DeleteScheduleErrorState(
          result.message ?? "Gagal menghapus jadwal",
        );
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = DeleteScheduleErrorState(e.toString());
      notifyListeners();
      return false;
    }
  }

  void resetState() {
    _state = DeleteScheduleInitialState();
    notifyListeners();
  }
}