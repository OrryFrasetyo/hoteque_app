import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/networking/states/attendance/clock_in_attendance_result_state.dart';
import '../../data/repository/attendance_repository.dart';

import '../../data/model/employee.dart';

class ClockInAttendanceProvider extends ChangeNotifier {
  final AttendanceRepository _repository;

  ClockInAttendanceResultState _state = ClockInAttendanceInitialState();
  ClockInAttendanceResultState get state => _state;

  ClockInAttendanceProvider(this._repository);

  /// Melakukan clock in attendance dengan menggunakan waktu saat ini
  Future<void> clockInAttendance({
    required Employee employee,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      // Update state ke loading
      _state = ClockInAttendanceLoadingState();
      notifyListeners();

      // Dapatkan waktu saat ini dalam format "HH:mm"
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm').format(now);

      // Kirim request
      final response = await _repository.clockInAttendance(
        employee: employee,
        clockIn: formattedTime,
      );

      if (response.data != null) {
        // Update state ke success
        _state = ClockInAttendanceSuccessState(response.data!);
        notifyListeners();

        // Panggil callback success
        onSuccess();
      } else {
        // Update state ke error
        _state = ClockInAttendanceErrorState(
          response.message ?? 'Unknown error occurred',
        );
        notifyListeners();

        // Panggil callback error
        onError(response.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      // Update state ke error
      _state = ClockInAttendanceErrorState(e.toString());
      notifyListeners();

      // Panggil callback error
      onError(e.toString());
    }
  }

  // Reset state ke initial (jika diperlukan)
  void resetState() {
    _state = ClockInAttendanceInitialState();
    notifyListeners();
  }
}
