import 'package:flutter/material.dart';
import '../../data/model/employee.dart';
import '../../data/networking/response/attendance/attendance_three_days_ago_response.dart';
import '../../data/networking/states/attendance/attendance_three_days_ago_result_state.dart';
import '../../data/repository/attendance_repository.dart';

class AttendanceThreeDaysProvider extends ChangeNotifier {
  final AttendanceRepository _attendanceRepository;

  AttendanceThreeDaysProvider(this._attendanceRepository);

  // State management using the ResultState pattern
  AttendanceThreeDaysAgoResultState _state =
      AttendanceThreeDaysAgoInitialState();

  // Getter for the current state
  AttendanceThreeDaysAgoResultState get state => _state;

  // Method to update state
  void _setState(AttendanceThreeDaysAgoResultState newState) {
    _state = newState;
    notifyListeners();
  }

  // Convenience getters to check current state type
  bool get isInitial => _state is AttendanceThreeDaysAgoInitialState;
  bool get isLoading => _state is AttendanceThreeDaysAgoLoadingState;
  bool get isError => _state is AttendanceThreeDaysAgoErrorState;
  bool get isLoaded => _state is AttendanceThreeDaysAgoLoadedState;

  // Getters for state data
  String get errorMessage =>
      _state is AttendanceThreeDaysAgoErrorState
          ? (_state as AttendanceThreeDaysAgoErrorState).message
          : '';

  List<Attendance> get attendanceList =>
      _state is AttendanceThreeDaysAgoLoadedState
          ? (_state as AttendanceThreeDaysAgoLoadedState).attendances
          : [];

  bool get isEmpty =>
      _state is AttendanceThreeDaysAgoLoadedState &&
      (_state as AttendanceThreeDaysAgoLoadedState).attendances.isEmpty;

  Future<void> getAttendanceThreeDaysAgo({required Employee employee}) async {
    _setState(AttendanceThreeDaysAgoLoadingState());

    final result = await _attendanceRepository.getAttendanceThreeDaysAgo(
      employee: employee,
    );

    if (result.data != null) {
      final response = result.data!;

      if (response.error) {
        _setState(AttendanceThreeDaysAgoErrorState(response.message));
      } else {
        // Check if the message indicates empty data
        if (response.message == "No attendance data found") {
          _setState(AttendanceThreeDaysAgoLoadedState([]));
        } else {
          _setState(AttendanceThreeDaysAgoLoadedState(response.attendance));
        }
      }
    } else if (result.message != null) {
      _setState(AttendanceThreeDaysAgoErrorState(result.message!));
    } else {
      _setState(AttendanceThreeDaysAgoErrorState("Unknown error occurred"));
    }
  }

  // Reset state when user logs out
  void resetState() {
    _setState(AttendanceThreeDaysAgoInitialState());
  }
}
