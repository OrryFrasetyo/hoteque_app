import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TaskItem extends Equatable {
  final String id;
  final String description;
  final bool isCompleted;

  const TaskItem({
    required this.id,
    required this.description,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [id, description, isCompleted];

  Map<String, dynamic> toMap() => {
    'id': id,
    'description': description,
    'is_completed': isCompleted,
  };

  factory TaskItem.fromMap(Map<String, dynamic> map) => TaskItem(
    id: map['id'] ?? '',
    description: map['description'] ?? '',
    isCompleted: map['is_completed'] ?? false,
  );

  TaskItem copyWith({String? id, String? description, bool? isCompleted}) {
    return TaskItem(
      id: id ?? this.id,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TaskHistory extends Equatable {
  final String id;
  final String employeeName;
  final String position;
  final DateTime deadline;
  final TaskStatus status;
  final List<TaskItem> taskList;
  final String message;
  final String feedback;
  final bool isExpanded;

  const TaskHistory({
    required this.id,
    required this.employeeName,
    required this.position,
    required this.deadline,
    required this.status,
    required this.taskList,
    required this.message,
    required this.feedback,
    this.isExpanded = false,
  });

  @override
  List<Object?> get props => [
    id,
    employeeName,
    position,
    deadline,
    status,
    taskList,
    message,
    feedback,
    isExpanded,
  ];

  TaskHistory copyWith({
    String? id,
    String? employeeName,
    String? position,
    DateTime? deadline,
    TaskStatus? status,
    List<TaskItem>? taskList,
    String? message,
    String? feedback,
    bool? isExpanded,
  }) {
    return TaskHistory(
      id: id ?? this.id,
      employeeName: employeeName ?? this.employeeName,
      position: position ?? this.position,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      taskList: taskList ?? this.taskList,
      message: message ?? this.message,
      feedback: feedback ?? this.feedback,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

enum TaskStatus { sedangDicek, disetujui, revisi, belumDikerjakan }

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.sedangDicek:
        return 'Sedang Dicek';
      case TaskStatus.disetujui:
        return 'Disetujui';
      case TaskStatus.revisi:
        return 'Revisi';
      case TaskStatus.belumDikerjakan:
        return 'Belum Dikerjakan';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case TaskStatus.sedangDicek:
        return Colors.yellow;
      case TaskStatus.disetujui:
        return Colors.green;
      case TaskStatus.revisi:
        return Colors.orange;
      case TaskStatus.belumDikerjakan:
        return Colors.transparent;
    }
  }

  Color get textColor {
    switch (this) {
      case TaskStatus.sedangDicek:
        return Colors.black;
      case TaskStatus.disetujui:
        return Colors.white;
      case TaskStatus.revisi:
        return Colors.white;
      case TaskStatus.belumDikerjakan:
        return Colors.transparent;
    }
  }
}
