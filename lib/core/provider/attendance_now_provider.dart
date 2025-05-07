import 'package:flutter/material.dart';

import '../data/model/employee.dart';
import '../data/networking/response/attendance/attendance_now_response.dart';
import '../data/networking/states/attendance_now_result_state.dart';
import '../data/networking/util/api_response.dart';
import '../data/repository/attendance_repository.dart';

class AttendanceNowProvider extends ChangeNotifier {
  final AttendanceRepository _attendanceRepository;

  AttendanceNowResultState _state = AttendanceNowInitialState();
  AttendanceNowResultState get state => _state;

  // Flag untuk mencegah multiple API calls
  bool _isLoading = false;

  AttendanceNow? _attendanceNow;
  AttendanceNow? get attendanceNow => _attendanceNow;

  AttendanceNowProvider(this._attendanceRepository);

  // Getter untuk clock in time
  String get clockInTime {
    if (_attendanceNow != null && _attendanceNow!.clockIn != "--:--") {
      return _attendanceNow!.clockIn;
    }
    return "--:--";
  }

  // Getter untuk clock out time
  String get clockOutTime {
    if (_attendanceNow != null && _attendanceNow!.clockOut != "--:--") {
      return _attendanceNow!.clockOut;
    }
    return "--:--";
  }

  // Getter untuk button text
  String get buttonText {
    if (_attendanceNow == null || _attendanceNow!.clockIn == "--:--") {
      return "Rekam Hadir";
    } else if (_attendanceNow!.clockOut == "--:--") {
      return "Rekam Pulang";
    } else {
      return "Rekam Pulang";
    }
  }

  // Getter untuk button enabled status
  bool get isButtonEnabled {
    if (_attendanceNow == null) return true;
    return _attendanceNow!.clockOut == "--:--"; // Disable jika sudah clock out
  }

  // Method untuk mendapatkan attendance now
  Future<void> getAttendanceNow({required Employee employee}) async {
    // Prevent multiple API calls simultaneously
    if (_isLoading) return;
    _isLoading = true;

    try {
      _state = AttendanceNowLoadingState();
      notifyListeners();

      final ApiResponse<AttendanceNowResponse> response =
          await _attendanceRepository.getAttendanceNow(employee: employee);

      if (response.data != null) {
        final attendanceNowResponse = response.data!;

        if (!attendanceNowResponse.error) {
          _attendanceNow = attendanceNowResponse.attendanceNow;
          _state = AttendanceNowLoadedState(_attendanceNow!);
        } else {
          _state = AttendanceNowErrorState(attendanceNowResponse.message);
        }
      } else if (response.message != null) {
        _state = AttendanceNowErrorState(response.message!);
      } else {
        _state = AttendanceNowErrorState(
          "Terjadi kesalahan yang tidak diketahui",
        );
      }
    } catch (e) {
      _state = AttendanceNowErrorState(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset provider state
  void resetState() {
    _state = AttendanceNowInitialState();
    _attendanceNow = null;
    notifyListeners();
  }
}
