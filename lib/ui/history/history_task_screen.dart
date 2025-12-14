import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hoteque_app/core/provider/task/task_history_provider.dart';
import 'package:hoteque_app/ui/widget/task_card_widget.dart';

class HistoryTaskScreen extends StatefulWidget {
  const HistoryTaskScreen({super.key});

  @override
  State<HistoryTaskScreen> createState() => _HistoryTaskScreenState();
}

class _HistoryTaskScreenState extends State<HistoryTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskHistoryProvider>().loadTaskHistories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Riwayat Tugas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF8B5A2B),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(child: _buildTaskList()),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Tanggal',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Consumer<TaskHistoryProvider>(
              builder: (context, provider, child) {
                return GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[50],
                    ),
                    child: Text(
                      provider.formattedSelectedDate,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () => _showAddTaskDialog(context),
            icon: const Icon(Icons.add_task),
            color: Color(0xFF8B5A2B),
            iconSize: 24,
          ),
          IconButton(
            onPressed: () => _downloadReport(),
            icon: const Icon(Icons.download),
            color: Color(0xFF8B5A2B),
            iconSize: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Consumer<TaskHistoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  provider.errorMessage,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadTaskHistories(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        if (provider.taskHistories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada tugas untuk tanggal ini',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: provider.taskHistories.length,
          itemBuilder: (context, index) {
            final task = provider.taskHistories[index];
            return TaskCardWidget(
              task: task,
              onToggleExpansion: () => provider.toggleTaskExpansion(task.id),
              onEdit: () => _editTask(task.id),
              onDelete: () => _deleteTask(context, task.id),
              onFeedbackSubmit: (feedback) =>
                  provider.updateTaskFeedback(task.id, feedback),
            );
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final provider = context.read<TaskHistoryProvider>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('id', 'ID'),
    );

    if (picked != null && picked != provider.selectedDate) {
      provider.setSelectedDate(picked);
    }
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Tambah Tugas Pegawai',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Form tambah tugas pegawai masih dalam pengembangan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Tutup',
                style: TextStyle(
                  color: Colors.brown[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _downloadReport() {
    // Implementasi download report
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur download sedang dalam pengembangan')),
    );
  }

  void _editTask(String taskId) {
    // Implementasi edit task
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit task dengan ID: $taskId')));
  }

  void _deleteTask(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Tugas'),
          content: const Text('Apakah Anda yakin ingin menghapus tugas ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                context.read<TaskHistoryProvider>().deleteTask(taskId);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tugas berhasil dihapus')),
                );
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
