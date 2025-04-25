import 'package:hoteque_app/core/data/networking/response/profile_employee_response.dart';

sealed class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileErrorState extends ProfileState {
  final String message;
  
  ProfileErrorState(this.message);
}

class ProfileLoadedState extends ProfileState {
  final Profile data;
  
  ProfileLoadedState(this.data);
}

