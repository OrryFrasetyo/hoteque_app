import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/task.dart';
import 'package:intl/intl.dart';

class TaskHistoryProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  List<TaskHistory> _taskHistories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  DateTime get selectedDate => _selectedDate;
  List<TaskHistory> get taskHistories => _taskHistories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  String get formattedSelectedDate {
    return DateFormat('dd-MM-yyyy', 'id_ID').format(_selectedDate);
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
    loadTaskHistories();
  }

  void toggleTaskExpansion(String taskId) {
    _taskHistories = _taskHistories.map((task) {
      if (task.id == taskId) {
        return task.copyWith(isExpanded: !task.isExpanded);
      }
      return task;
    }).toList();
    notifyListeners();
  }

  void updateTaskFeedback(String taskId, String feedback) {
    _taskHistories = _taskHistories.map((task) {
      if (task.id == taskId) {
        return task.copyWith(feedback: feedback);
      }
      return task;
    }).toList();
    notifyListeners();
  }

  void deleteTask(String taskId) {
    _taskHistories.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  Future<void> loadTaskHistories() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulasi delay API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Data dummy untuk testing
      _taskHistories = _generateDummyData();
    } catch (e) {
      _errorMessage = 'Gagal memuat data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<TaskHistory> _generateDummyData() {
    return [
      TaskHistory(
        id: '1',
        employeeName: 'Maxwell',
        position: 'Housekeeper',
        deadline: DateTime(2025, 7, 14),
        status: TaskStatus.sedangDicek,
        taskList: [
          const TaskItem(
            id: '1-1',
            description: 'Cek kebersihan kamar',
            isCompleted: true,
          ),
          const TaskItem(
            id: '1-2',
            description: 'Cek kebersihan toilet',
            isCompleted: true,
          ),
          const TaskItem(
            id: '1-3',
            description: 'Lain - lain',
            isCompleted: true,
          ),
        ],
        message: 'Kamar sudah bersih bos :)',
        feedback: '',
      ),
      TaskHistory(
        id: '2',
        employeeName: 'Ferdi',
        position: 'Housekeeper',
        deadline: DateTime(2025, 7, 14),
        status: TaskStatus.sedangDicek,
        taskList: [
          const TaskItem(
            id: '2-1',
            description: 'Cek kebersihan kamar',
            isCompleted: false,
          ),
          const TaskItem(
            id: '2-2',
            description: 'Cek kebersihan toilet',
            isCompleted: false,
          ),
        ],
        message: 'Masih dalam proses',
        feedback: '',
      ),
      TaskHistory(
        id: '3',
        employeeName: 'Jordi',
        position: 'Housekeeping',
        deadline: DateTime(2025, 7, 14),
        status: TaskStatus.disetujui,
        taskList: [
          const TaskItem(
            id: '3-1',
            description: 'Cek kebersihan kamar',
            isCompleted: true,
          ),
          const TaskItem(
            id: '3-2',
            description: 'Cek kebersihan toilet',
            isCompleted: true,
          ),
          const TaskItem(
            id: '3-3',
            description: 'Lain - lain',
            isCompleted: true,
          ),
        ],
        message: 'Kamar sudah bersih bos :)',
        feedback: 'Ok tingkatkan',
      ),
    ];
  }
}
