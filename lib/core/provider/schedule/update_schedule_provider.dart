import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/shift/shift_response.dart';
import 'package:hoteque_app/core/data/networking/states/schedule/update_schedule_result_state.dart';
import 'package:hoteque_app/core/data/repository/schedule_repository.dart';
import 'package:intl/intl.dart';

class UpdateScheduleProvider extends ChangeNotifier {
  final ScheduleRepository _repository;

  UpdateScheduleResultState _state = UpdateScheduleInitialState();
  UpdateScheduleResultState get state => _state;

  List<ShiftforSchedule> _shifts = [];
  List<ShiftforSchedule> get shifts => _shifts;

  ShiftforSchedule? _selectedShift;
  ShiftforSchedule? get selectedShift => _selectedShift;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  String? _selectedStatus;
  String? get selectedStatus => _selectedStatus;

  UpdateScheduleProvider(this._repository);

  void setSelectedShift(ShiftforSchedule shift) {
    _selectedShift = shift;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedStatus(String? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  Future<void> fetchShifts(Employee employee) async {
    try {
      _state = UpdateScheduleLoadingState();
      notifyListeners();

      final result = await _repository.getAllShift();

      if (result.message != null && result.data == null) {
        _state = UpdateScheduleErrorState(result.message!);
      } else if (result.data != null) {
        _shifts = result.data!.data;
        _state = UpdateScheduleLoadedState();
      } else {
        _state = UpdateScheduleErrorState("Tidak ada data shift yang ditemukan");
      }
    } catch (e) {
      _state = UpdateScheduleErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }

  void initializeFormData(Map<String, dynamic> scheduleData, List<ShiftforSchedule> availableShifts) {
    // Cari shift yang sesuai berdasarkan nama shift dari data jadwal
    if (scheduleData['shiftType'] != null && availableShifts.isNotEmpty) {
      final shiftName = scheduleData['shiftType'].toString();
      _selectedShift = availableShifts.firstWhere(
        (shift) => shift.type.contains(shiftName.replaceAll('Shift ', '')),
        orElse: () => availableShifts.first,
      );
    }

    // Set status jika ada
    _selectedStatus = scheduleData['status'];

    // Set tanggal dari data jadwal jika ada
    if (scheduleData['dateSchedule'] != null) {
      try {
        // Coba parse tanggal dari format yang ada di data
        // Asumsi format tanggal adalah dd-MM-yyyy
        final dateStr = scheduleData['dateSchedule'].toString();
        final dateParts = dateStr.split('-');
        if (dateParts.length == 3) {
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);
          _selectedDate = DateTime(year, month, day);
        } else {
          _selectedDate = DateTime.now();
        }
      } catch (e) {
        // Jika gagal parse, gunakan tanggal hari ini
        _selectedDate = DateTime.now();
      }
    } else {
      // Jika tidak ada tanggal, gunakan tanggal hari ini
      _selectedDate = DateTime.now();
    }

    notifyListeners();
  }

  Future<bool> updateSchedule(Employee employee, int scheduleId) async {
    try {
      if (_selectedShift == null) {
        _state = UpdateScheduleErrorState('Pilih shift terlebih dahulu');
        notifyListeners();
        return false;
      }

      _state = UpdateScheduleLoadingState();
      notifyListeners();

      // Format tanggal sesuai yang diharapkan API (dd-MM-yyyy)
      final formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate);

      final result = await _repository.updateScheduleEmployee(
        employee: employee,
        scheduleId: scheduleId,
        shiftId: _selectedShift!.id,
        dateSchedule: formattedDate,
        status: _selectedStatus,
      );

      if (result.data != null && !result.data!.error) {
        _state = UpdateScheduleSuccessState(result.data!);
        notifyListeners();
        return true;
      } else {
        // Tampilkan pesan error yang lebih spesifik dari API
        final errorMessage = result.message ?? 'Gagal mengupdate jadwal';
        _state = UpdateScheduleErrorState(errorMessage);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = UpdateScheduleErrorState('Terjadi kesalahan: ${e.toString()}');
      notifyListeners();
      return false;
    }
  }

  void resetState() {
    _state = UpdateScheduleInitialState();
    notifyListeners();
  }
}