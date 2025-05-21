import 'package:hoteque_app/core/data/networking/response/schedule/add_schedule_response.dart';

sealed class AddScheduleResultState {}

class AddScheduleInitialState extends AddScheduleResultState {}

class AddScheduleLoadingState extends AddScheduleResultState {}

class AddScheduleErrorState extends AddScheduleResultState {
  final String message;

  AddScheduleErrorState(this.message);
}

class AddScheduleLoadedState extends AddScheduleResultState {}

class AddScheduleSuccessState extends AddScheduleResultState {
  final AddScheduleResponse response;

  AddScheduleSuccessState(this.response);
}