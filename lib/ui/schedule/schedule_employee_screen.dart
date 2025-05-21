import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/schedule_department_employee_response.dart';
import 'package:hoteque_app/core/data/networking/states/schedule/schedule_department_result_state.dart';
import 'package:hoteque_app/core/provider/schedule/schedule_department_provider.dart';
import 'package:hoteque_app/ui/schedule/add_schedule_screen.dart';
import 'package:hoteque_app/ui/schedule/edit_schedule_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScheduleEmployeeScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Employee employee;

  const ScheduleEmployeeScreen({
    super.key,
    required this.employee,
    required this.onBack,
  });

  @override
  State<ScheduleEmployeeScreen> createState() =>
      _ScheduleDepartmentEmployeeState();
}

class _ScheduleDepartmentEmployeeState extends State<ScheduleEmployeeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ScheduleDepartmentProvider>(
        context,
        listen: false,
      );
      provider.fetchSchedules(widget.employee);
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final provider = Provider.of<ScheduleDepartmentProvider>(
      context,
      listen: false,
    );

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != provider.selectedDate) {
      provider.setSelectedDate(picked);
      provider.fetchSchedules(widget.employee);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            widget.onBack();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        title: const Text(
          'Jadwal Kerja Bulan Ini',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDatePicker(),
            const SizedBox(height: 16),
            Expanded(child: _buildScheduleContent()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddScheduleScreen(employee: widget.employee),
            ),
          );
          
          // Refresh schedules if a new schedule was added
          if (result == true) {
            final provider = Provider.of<ScheduleDepartmentProvider>(
              context,
              listen: false,
            );
            provider.fetchSchedules(widget.employee);
          }
        },
        backgroundColor: Color(0xFF90612D),
        elevation: 0,
        child: Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Consumer<ScheduleDepartmentProvider>(
      builder: (context, provider, _) {
        final dateFormatted = DateFormat(
          'dd-MM-yyyy',
        ).format(provider.selectedDate);

        return Row(
          children: [
            const Text("Pilih Tanggal", style: TextStyle(fontSize: 14)),
            const SizedBox(width: 16),
            Flexible(
              fit: FlexFit.loose,
              child: InkWell(
                onTap: () => _pickDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(dateFormatted, style: TextStyle(fontSize: 14)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScheduleContent() {
    return Consumer<ScheduleDepartmentProvider>(
      builder: (context, provider, _) {
        final state = provider.state;

        if (state is ScheduleDepartmentInitialState) {
          return Center(
            child: const Text('Pilih tanggal untuk melihat jadwal'),
          );
        } else if (state is ScheduleDepartmentLoadingState) {
          return Center(
            child: CircularProgressIndicator(color: const Color(0xFF90612D)),
          );
        } else if (state is ScheduleDepartmentErrorState) {
          return _buildErrorWidget(state.message);
        } else if (state is ScheduleDepartmentLoadedState) {
          if (state.schedules.isEmpty) {
            return Center(
              child: const Text('Tidak ada jadwal untuk tanggal ini'),
            );
          }
          return _buildScheduleList(state.schedules);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Terjadi kesalahan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<ScheduleDepartmentProvider>(
                context,
                listen: false,
              );
              provider.fetchSchedules(widget.employee);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF90612D)),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList(List<Schedule> schedules) {
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final schedule = schedules[index];
        return _buildScheduleCard(schedule, index);
      },
    );
  }

  Widget _buildScheduleCard(Schedule schedule, int index) {
    Color? statusColor;
    if (schedule.status == 'Izin') statusColor = Colors.amber;
    if (schedule.status == 'Alpa') statusColor = Colors.redAccent;

    // Format time from shift
    final time = "${schedule.shift.clockIn} - ${schedule.shift.clockOut}";

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.work_history, color: Color(0xFF90612D), size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${schedule.employee.name} - ${schedule.employee.position}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(schedule.shift.name, style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (schedule.status.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      schedule.status,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFF90612D)),
                      onPressed: () {
                        // TODO: Implement delete functionality
                        _showDeleteConfirmation(schedule);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF90612D)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditScheduleScreen(
                                  scheduleData: _convertToScheduleMap(schedule),
                                  scheduleIndex: index,
                                  onUpdate: (_) {
                                    // Refresh schedules after update
                                    final provider =
                                        Provider.of<ScheduleDepartmentProvider>(
                                          context,
                                          listen: false,
                                        );
                                    provider.fetchSchedules(widget.employee);
                                  },
                                ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _convertToScheduleMap(Schedule schedule) {
    // Convert Schedule object to Map for EditScheduleScreen
    return {
      'name': schedule.employee.name,
      'position': schedule.employee.position,
      'shiftType': schedule.shift.name,
      'time': '${schedule.shift.clockIn} - ${schedule.shift.clockOut}',
      'status': schedule.status,
      'id': schedule.id,
    };
  }

  void _showDeleteConfirmation(Schedule schedule) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text(
              'Apakah Anda yakin ingin menghapus jadwal ini?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement delete API call
                  Navigator.pop(context);
                  // After delete, refresh the schedule list
                  final provider = Provider.of<ScheduleDepartmentProvider>(
                    context,
                    listen: false,
                  );
                  provider.fetchSchedules(widget.employee);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
  }
}
