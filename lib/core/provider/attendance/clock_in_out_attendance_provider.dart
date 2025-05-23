import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/networking/states/attendance/clock_in_out_attendance_result_state.dart';
import '../../data/repository/attendance_repository.dart';

import '../../data/model/employee.dart';

class ClockInOutAttendanceProvider extends ChangeNotifier {
  final AttendanceRepository _repository;

  ClockInOutAttendanceResultState _state = ClockInOutAttendanceInitialState();
  ClockInOutAttendanceResultState get state => _state;

  ClockInOutAttendanceProvider(this._repository);

  /// Melakukan clock in attendance dengan menggunakan waktu saat ini
  Future<void> clockInAttendance({
    required Employee employee,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      // Update state ke loading
      _state = ClockInOutAttendanceLoadingState();
      notifyListeners();

      // Dapatkan waktu saat ini dalam format "HH:mm"
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm').format(now);

      await Future.delayed(const Duration(seconds: 2));

      // Kirim request
      final response = await _repository.clockInAttendance(
        employee: employee,
        clockIn: formattedTime,
      );

      if (response.data != null) {
        // Update state ke success
        _state = ClockInOutAttendanceSuccessState(response.data!);
        notifyListeners();

        // Panggil callback success
        onSuccess();
      } else {
        // Update state ke error
        _state = ClockInOutAttendanceErrorState(
          response.message ?? 'Unknown error occurred',
        );
        notifyListeners();

        // Panggil callback error
        onError(response.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      // Update state ke error
      _state = ClockInOutAttendanceErrorState(e.toString());
      notifyListeners();

      // Panggil callback error
      onError(e.toString());
    }
  }

  /// Melakukan clock out attendance dengan menggunakan waktu saat ini
  Future<void> clockOutAttendance({
    required Employee employee,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      // Update state ke loading
      _state = ClockInOutAttendanceLoadingState();
      notifyListeners();

      // Dapatkan waktu saat ini dalam format "HH:mm"
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm').format(now);

      await Future.delayed(const Duration(seconds: 2));

      // Kirim request
      final response = await _repository.clockOutAttendance(
        employee: employee,
        clockOut: formattedTime,
      );

      if (response.data != null) {
        // Update state ke success
        _state = ClockInOutAttendanceSuccessState(response.data!);
        notifyListeners();

        // Panggil callback success
        onSuccess();
      } else {
        // Update state ke error
        _state = ClockInOutAttendanceErrorState(
          response.message ?? 'Unknown error occurred',
        );
        notifyListeners();

        // Panggil callback error
        onError(response.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      // Update state ke error
      _state = ClockInOutAttendanceErrorState(e.toString());
      notifyListeners();

      // Panggil callback error
      onError(e.toString());
    }
  }

  // Reset state ke initial (jika diperlukan)
  void resetState() {
    _state = ClockInOutAttendanceInitialState();
    notifyListeners();
  }
}
