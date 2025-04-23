import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/get_profile_employee_response.dart';
import 'package:hoteque_app/core/data/networking/states/get_profile_result_state.dart';
import 'package:hoteque_app/core/data/repository/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _profileRepository;

  ProfileProvider(this._profileRepository);

  ProfileState _state = ProfileInitialState();
  Profile? _profile;

  // Getters
  ProfileState get state => _state;
  Profile? get profile => _profile;

  // Helper getters untuk nilai aman
  String get name => _profile?.name ?? '?';
  String get position => _profile?.position ?? '?';
  String get department => _profile?.department ?? '?';
  String get email => _profile?.email ?? '?';
  String get phone => _profile?.phone ?? '?';
  dynamic get photo => _profile?.photo;
  bool get hasPhoto => _profile?.photo != null;
  
  // Pembantu untuk cek status
  bool get isLoading => _state is ProfileLoadingState;
  bool get isError => _state is ProfileErrorState;
  bool get isLoaded => _state is ProfileLoadedState;

  // Mendapatkan pesan error jika dalam kondisi error
  String get errorMessage => _state is ProfileErrorState 
      ? (_state as ProfileErrorState).message 
      : '';

  Future<void> getProfile({required Employee employee}) async {
    _state = ProfileLoadingState();
    notifyListeners();

    final result = await _profileRepository.getProfile(employee: employee);

    if (result.data != null && !result.data!.error) {
      _profile = result.data!.profile;
      _state = ProfileLoadedState(_profile!);
    } else {
      _state = ProfileErrorState(result.message ?? 'Gagal memuat profil');
    }

    notifyListeners();
  }

  // Reset state jika diperlukan (misalnya saat logout)
  void resetState() {
    _state = ProfileInitialState();
    _profile = null;
    notifyListeners();
  }
}