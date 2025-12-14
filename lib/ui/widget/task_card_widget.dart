import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/task.dart';
import 'package:intl/intl.dart';

class TaskCardWidget extends StatelessWidget {
  final TaskHistory task;
  final VoidCallback onToggleExpansion;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String) onFeedbackSubmit;

  const TaskCardWidget({
    super.key,
    required this.task,
    required this.onToggleExpansion,
    required this.onEdit,
    required this.onDelete,
    required this.onFeedbackSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskHeader(),
            const SizedBox(height: 12),
            _buildTaskInfo(),
            const SizedBox(height: 12),
            _buildStatusAndActions(),
            if (task.isExpanded) ..._buildExpandedContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.employeeName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                task.position,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Tenggat',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            Text(
              DateFormat('dd-MM-yyyy', 'id_ID').format(task.deadline),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onToggleExpansion,
          child: Text(
            task.isExpanded ? 'Lihat Sedikit <<' : 'Lihat Detail >>',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusAndActions() {
    return Row(
      children: [
        if (task.status != TaskStatus.belumDikerjakan)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: task.status.backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              task.status.displayName,
              style: TextStyle(
                fontSize: 12,
                color: task.status.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () => _showFeedbackDialog(),
              icon: const Icon(Icons.comment, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildExpandedContent() {
    return [
      const SizedBox(height: 16),
      const Divider(),
      const SizedBox(height: 8),
      const Text(
        'List Tugas',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      ...task.taskList.map((taskItem) => _buildTaskItem(taskItem)),
      const SizedBox(height: 16),
      _buildMessageSection(),
      if (task.feedback.isNotEmpty) _buildFeedbackSection(),
    ];
  }

  Widget _buildTaskItem(TaskItem taskItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            taskItem.isCompleted
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            color: taskItem.isCompleted ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              taskItem.description,
              style: TextStyle(
                fontSize: 14,
                decoration: taskItem.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
                color: taskItem.isCompleted ? Colors.grey : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pesan',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(task.message, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Tanggapan',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(task.feedback, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  void _showFeedbackDialog() {
    // Implementasi dialog feedback akan ditambahkan di HistoryTaskScreen
  }
}
