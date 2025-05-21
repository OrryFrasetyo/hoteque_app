import 'package:hoteque_app/core/data/networking/response/shift/shift_response.dart';

sealed class ShiftResultState {}

class ShiftInitialState extends ShiftResultState {}

class ShiftLoadingState extends ShiftResultState {}

class ShiftErrorState extends ShiftResultState {
  final String message;

  ShiftErrorState(this.message);
}

class ShiftLoadedState extends ShiftResultState {
  final List<ShiftforSchedule> shifts;

  ShiftLoadedState(this.shifts);
}
