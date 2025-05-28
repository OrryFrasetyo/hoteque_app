import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/attendance/attendance_by_status_response.dart';
import 'package:hoteque_app/core/data/networking/states/attendance/attendance_by_status_result_state.dart';
import 'package:hoteque_app/core/data/repository/attendance_repository.dart';

class AttendanceByStatusProvider extends ChangeNotifier {
  final AttendanceRepository _attendanceRepository;

  AttendanceByStatusProvider(this._attendanceRepository);

  // State management menggunakan ResultState pattern
  AttendanceByStatusResultState _state = AttendanceByStatusInitialState();

  // Getter untuk state saat ini
  AttendanceByStatusResultState get state => _state;

  // Setter untuk state dengan notifikasi
  void _setState(AttendanceByStatusResultState newState) {
    _state = newState;
    if (hasListeners) {
      // Hanya notifikasi jika ada listener yang aktif
      notifyListeners();
    }
  }

  // Getter untuk data attendance
  List<AttendanceStatus> get attendances =>
      _state is AttendanceByStatusLoadedState
          ? (_state as AttendanceByStatusLoadedState).attendances
          : [];

  // Cek apakah data kosong
  bool get isEmpty =>
      _state is AttendanceByStatusLoadedState &&
      (_state as AttendanceByStatusLoadedState).attendances.isEmpty;

  // Fungsi untuk mendapatkan attendance berdasarkan clock_in_status
  Future<void> getAttendanceByClockInStatus({
    required Employee employee,
    required String status,
  }) async {
    _setState(AttendanceByStatusLoadingState());

    final result = await _attendanceRepository.getAttendanceByStatus(
      employee: employee,
      clockInStatus: status,
    );

    if (result.data != null) {
      final response = result.data!;

      if (response.error) {
        _setState(AttendanceByStatusErrorState(response.message));
      } else {
        _setState(AttendanceByStatusLoadedState(response.attendances));
      }
    } else if (result.message != null) {
      _setState(AttendanceByStatusErrorState(result.message!));
    } else {
      _setState(
        AttendanceByStatusErrorState("Terjadi kesalahan yang tidak diketahui"),
      );
    }
  }

  // Fungsi untuk mendapatkan attendance berdasarkan clock_out_status
  Future<void> getAttendanceByClockOutStatus({
    required Employee employee,
    required String status,
  }) async {
    _setState(AttendanceByStatusLoadingState());

    final result = await _attendanceRepository.getAttendanceByStatus(
      employee: employee,
      clockOutStatus: status,
    );

    if (result.data != null) {
      final response = result.data!;

      if (response.error) {
        _setState(AttendanceByStatusErrorState(response.message));
      } else {
        _setState(AttendanceByStatusLoadedState(response.attendances));
      }
    } else if (result.message != null) {
      _setState(AttendanceByStatusErrorState(result.message!));
    } else {
      _setState(
        AttendanceByStatusErrorState("Terjadi kesalahan yang tidak diketahui"),
      );
    }
  }

  // Reset state ke initial
  void resetState() {
    _state = AttendanceByStatusInitialState();
  }
}
