import 'package:hoteque_app/core/data/networking/response/schedule/update_schedule_response.dart';

sealed class UpdateScheduleResultState {}

class UpdateScheduleInitialState extends UpdateScheduleResultState {}

class UpdateScheduleLoadingState extends UpdateScheduleResultState {}

class UpdateScheduleErrorState extends UpdateScheduleResultState {
  final String message;

  UpdateScheduleErrorState(this.message);
}

class UpdateScheduleLoadedState extends UpdateScheduleResultState {}

class UpdateScheduleSuccessState extends UpdateScheduleResultState {
  final UpdateScheduleResponse response;

  UpdateScheduleSuccessState(this.response);
}