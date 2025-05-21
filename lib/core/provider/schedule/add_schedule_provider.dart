import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/employee_in_department_response.dart';
import 'package:hoteque_app/core/data/networking/response/shift/shift_response.dart';
import 'package:hoteque_app/core/data/networking/states/schedule/add_schedule_result_state.dart';
import 'package:hoteque_app/core/data/repository/schedule_repository.dart';
import 'package:intl/intl.dart';

class AddScheduleProvider extends ChangeNotifier {
  final ScheduleRepository _repository;

  AddScheduleResultState _state = AddScheduleInitialState();
  AddScheduleResultState get state => _state;

  List<EmployeeSearch> _employees = [];
  List<EmployeeSearch> get employees => _employees;

  List<ShiftforSchedule> _shifts = [];
  List<ShiftforSchedule> get shifts => _shifts;

  EmployeeSearch? _selectedEmployee;
  EmployeeSearch? get selectedEmployee => _selectedEmployee;

  ShiftforSchedule? _selectedShift;
  ShiftforSchedule? get selectedShift => _selectedShift;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  AddScheduleProvider(this._repository);

  void setSelectedEmployee(EmployeeSearch employee) {
    _selectedEmployee = employee;
    notifyListeners();
  }

  void setSelectedShift(ShiftforSchedule shift) {
    _selectedShift = shift;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> fetchEmployees(Employee employee) async {
    try {
      _state = AddScheduleLoadingState();
      notifyListeners();

      final result = await _repository.getAllEmployeeInDepartment(
        employee: employee,
      );

      if (result.message != null && result.data == null) {
        _state = AddScheduleErrorState(result.message!);
      } else if (result.data != null) {
        _employees = result.data!.employees;
        _state = AddScheduleLoadedState();
      } else {
        _state = AddScheduleErrorState("Tidak ada data karyawan yang ditemukan");
      }
    } catch (e) {
      _state = AddScheduleErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchShifts() async {
    try {
      _state = AddScheduleLoadingState();
      notifyListeners();

      final result = await _repository.getAllShift();

      if (result.message != null && result.data == null) {
        _state = AddScheduleErrorState(result.message!);
      } else if (result.data != null) {
        _shifts = result.data!.data;
        _state = AddScheduleLoadedState();
      } else {
        _state = AddScheduleErrorState("Tidak ada data shift yang ditemukan");
      }
    } catch (e) {
      _state = AddScheduleErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<bool> createSchedule(Employee employee) async {
    try {
      if (_selectedEmployee == null || _selectedShift == null) {
        _state = AddScheduleErrorState('Pilih pegawai dan shift terlebih dahulu');
        notifyListeners();
        return false;
      }

      _state = AddScheduleLoadingState();
      notifyListeners();

      // Format tanggal sesuai yang diharapkan API (yyyy-MM-dd)
      final formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate);

      final result = await _repository.createScheduleEmployee(
        employee: employee,
        employeeId: _selectedEmployee!.employeeId, // Menggunakan employeeId bukan id
        shiftId: _selectedShift!.id,
        dateSchedule: formattedDate,
        status: "null", // Menambahkan parameter status yang diperlukan
      );

      if (result.data != null && !result.data!.error) {
        _state = AddScheduleSuccessState(result.data!);
        notifyListeners();
        return true;
      } else {
        // Tampilkan pesan error yang lebih spesifik dari API
        final errorMessage = result.message ?? 'Gagal membuat jadwal';
        _state = AddScheduleErrorState(errorMessage);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = AddScheduleErrorState('Terjadi kesalahan: ${e.toString()}');
      notifyListeners();
      return false;
    }
  }

  void resetState() {
    _state = AddScheduleInitialState();
    notifyListeners();
  }
}