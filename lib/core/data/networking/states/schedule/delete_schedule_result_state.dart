import 'package:hoteque_app/core/data/networking/response/simple_response.dart';

sealed class DeleteScheduleResultState {}

class DeleteScheduleInitialState extends DeleteScheduleResultState {}

class DeleteScheduleLoadingState extends DeleteScheduleResultState {}

class DeleteScheduleErrorState extends DeleteScheduleResultState {
  final String message;

  DeleteScheduleErrorState(this.message);
}

class DeleteScheduleSuccessState extends DeleteScheduleResultState {
  final SimpleResponse response;

  DeleteScheduleSuccessState(this.response);
}