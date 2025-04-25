import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/repository/profile_repository.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository;

  // State untuk data profile
  String _name = '';
  String _email = '';
  String _phone = '';
  String _position = '';
  String _department = '';  
  dynamic _photo;
  int? _id;

  // State untuk loading dan error
  bool _isLoading = false;
  bool _isError = false;
  String _errorMessage = '';
  bool _isUpdating = false;
  
  // File untuk update foto
  File? _photoFile;

  // Getters
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get position => _position;
  String get department => _department;
  dynamic get photo => _photo;
  int? get id => _id;
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  String get errorMessage => _errorMessage;
  bool get isUpdating => _isUpdating;
  File? get photoFile => _photoFile;
  
  // Getter untuk URL foto
  String get photoUrl {
    if (_photo == null) return '';
    // Ganti dengan base URL yang sesuai
    return "http://192.168.80.233:3000$_photo";
  }

  bool get hasPhoto => _photo != null && _photo.toString().isNotEmpty;
  
  UpdateProfileProvider(this._repository);

  void resetState() {
    _name = '';
    _email = '';
    _phone = '';
    _position = '';
    _department = '';
    _photo = null;
    _id = null;
    _isLoading = false;
    _isError = false;
    _errorMessage = '';
    _photoFile = null;
    notifyListeners();
  }

  Future<void> getProfile({required Employee employee}) async {
    _isLoading = true;
    _isError = false;
    notifyListeners();
    
    try {
      final response = await _repository.getProfile(employee: employee);
      
      if (response.data != null) {
        _name = response.data!.profile.name;
        _email = response.data!.profile.email;
        _phone = response.data!.profile.phone;
        _position = response.data!.profile.position;
        _department = response.data!.profile.department;
        _photo = response.data!.profile.photo;
        _id = response.data!.profile.id;
        _isError = false;
        _errorMessage = '';
      } else {
        _isError = true;
        _errorMessage = response.message ?? 'Gagal mengambil data profil';
      }
    } catch (e) {
      _isError = true;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method untuk pick image
  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Kompresi kualitas gambar
      );
      
      if (pickedFile != null) {
        _photoFile = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      _isError = true;
      _errorMessage = 'Gagal memilih gambar: ${e.toString()}';
      notifyListeners();
    }
  }

  // Method untuk update profile
  Future<bool> updateProfile({
    required Employee employee,
    required String name,
    required String phone,
    String? password,
  }) async {
    _isUpdating = true;
    _isError = false;
    notifyListeners();
    
    try {
      final response = await _repository.updateProfile(
        employee: employee,
        name: name,
        phone: phone,
        password: password,
        photoFile: _photoFile,
      );
      
      if (response.data != null) {
        // Successful response with data
        _name = response.data!.profile.name;
        _email = response.data!.profile.email;
        _phone = response.data!.profile.phone;
        _position = response.data!.profile.position;
        _department = response.data!.profile.department;
        _photo = response.data!.profile.photo;
        _id = response.data!.profile.id;
        _photoFile = null; // Reset photo file
        _isError = false;
        _errorMessage = '';
        _isUpdating = false;
        notifyListeners();
        return true;
      } else {
        // Error response
        _isError = true;
        _errorMessage = response.message ?? 'Gagal mengupdate profil';
        _isUpdating = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isError = true;
      _errorMessage = e.toString();
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }
  
  // Reset photo file jika batal
  void resetPhotoFile() {
    _photoFile = null;
    notifyListeners();
  }
}