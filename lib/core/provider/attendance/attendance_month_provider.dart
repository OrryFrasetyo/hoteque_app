import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import '../../data/model/attendance.dart';
import '../../data/networking/states/attendance/attendance_month_result_state.dart';
import '../../data/repository/attendance_repository.dart';

class AttendanceMonthProvider extends ChangeNotifier {
  final AttendanceRepository _attendanceRepository;

  AttendanceMonthProvider(this._attendanceRepository);

  // State management using the ResultState pattern
  AttendanceMonthResultState _state =
      AttendanceMonthInitialState();

  // Getter for the current state
  AttendanceMonthResultState get state => _state;

  // Method to update state
  void _setState(AttendanceMonthResultState newState) {
    _state = newState;
    notifyListeners();
  }

  // Convenience getters to check current state type
  bool get isInitial => _state is AttendanceMonthInitialState;
  bool get isLoading => _state is AttendanceMonthLoadingState;
  bool get isError => _state is AttendanceMonthErrorState;
  bool get isLoaded => _state is AttendanceMonthLoadedState;

  // Getters for state data
  String get errorMessage =>
      _state is AttendanceMonthErrorState
          ? (_state as AttendanceMonthErrorState).message
          : '';

  List<Attendance> get attendanceList =>
      _state is AttendanceMonthLoadedState
          ? (_state as AttendanceMonthLoadedState).attendances
          : [];

  bool get isEmpty =>
      _state is AttendanceMonthLoadedState &&
      (_state as AttendanceMonthLoadedState).attendances.isEmpty;

  Future<void> getAttendanceMonth({required Employee employee}) async {
    _setState(AttendanceMonthLoadingState());

    final result = await _attendanceRepository.getAttendanceMonth(
      employee: employee,
    );

    if (result.data != null) {
      final response = result.data!;

      if (response.error) {
        _setState(AttendanceMonthErrorState(response.message));
      } else {
        // Check if the message indicates empty data
        if (response.message == "No attendance data found") {
          _setState(AttendanceMonthLoadedState([]));
        } else {
          _setState(AttendanceMonthLoadedState(response.attendances));
        }
      }
    } else if (result.message != null) {
      _setState(AttendanceMonthErrorState(result.message!));
    } else {
      _setState(AttendanceMonthErrorState("Unknown error occurred"));
    }
  }

  // Reset state when user logs out
  void resetState() {
    _setState(AttendanceMonthInitialState());
  }
}