import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeProvider extends ChangeNotifier {
  DateTime _currentDateTime = DateTime.now();
  Timer? _timer;

  // Format tanggal dalam bahasa Indonesia
  final DateFormat _dateFormatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
  // Format jam digital
  final DateFormat _timeFormatter = DateFormat('HH:mm:ss');

  TimeProvider() {
    // Inisialisasi timer untuk memperbarui waktu setiap detik
    _startTimer();
  }

  void _startTimer() {
    // Update once immediately to prevent delay at startup
    _updateDateTime();

    // Cancel any existing timer first to prevent duplicates
    _timer?.cancel();

    // Use a fixed delay timer instead of periodic to avoid drift
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateDateTime();
    });
  }

  void _updateDateTime() {
    final newDateTime = DateTime.now();
    // Only notify if the time has actually changed
    if (_currentDateTime.second != newDateTime.second) {
      _currentDateTime = newDateTime;
      notifyListeners();
    }
  }

  // Mendapatkan tanggal dalam format yang diinginkan
  String get formattedDate => _dateFormatter.format(_currentDateTime);

  // Mendapatkan waktu dalam format digital
  String get formattedTime => _timeFormatter.format(_currentDateTime);

  // Mendapatkan jam dan menit saja (untuk tampilan lebih simple)
  String get formattedTimeShort => DateFormat('HH:mm').format(_currentDateTime);

  @override
  void dispose() {
    // Penting: membersihkan timer ketika provider tidak digunakan lagi
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
