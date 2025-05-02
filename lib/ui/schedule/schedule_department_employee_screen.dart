import 'package:flutter/material.dart';
import 'package:hoteque_app/ui/schedule/add_schedule_screen.dart';
import 'package:hoteque_app/ui/schedule/edit_schedule_screen.dart';
import 'package:intl/intl.dart';

class ScheduleDepartmentEmployeeScreen extends StatefulWidget {
  const ScheduleDepartmentEmployeeScreen({super.key});

  @override
  State<ScheduleDepartmentEmployeeScreen> createState() =>
      _ScheduleDepartmentEmployeeState();
}

class _ScheduleDepartmentEmployeeState
    extends State<ScheduleDepartmentEmployeeScreen> {
  DateTime selectedDate = DateTime(2025, 5, 1);

  final List<Map<String, dynamic>> scheduleList = [
    {
      'name': 'Bagus',
      'position': 'Cook',
      'shiftType': 'Shift Pagi',
      'time': '08.00 WIB - 15.00 WIB',
      'status': null,
    },
    {
      'name': 'Dimas',
      'position': 'Cook',
      'shiftType': 'Shift Siang',
      'time': '15.00 WIB - 22.00 WIB',
      'status': 'Izin',
    },
    {
      'name': 'Ferdi',
      'position': 'Cook',
      'shiftType': 'Shift Malam',
      'time': '22.00 WIB - 08.00 WIB',
      'status': 'Alpa',
    },
  ];

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('dd/MM/yyyy').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        title: Text(
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
            Row(
              children: [
                Text("Pilih Tanggal", style: TextStyle(fontSize: 14)),
                SizedBox(width: 16),
                Flexible(
                  fit: FlexFit.loose,
                  child: InkWell(
                    onTap: _pickDate,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
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
                      child: Text(
                        dateFormatted,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: scheduleList.length,
                itemBuilder: (context, index) {
                  final item = scheduleList[index];
                  return _buildScheduleCard(item, index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScheduleScreen()),
          );
        },
        backgroundColor: Color(0xFF90612D),
        elevation: 0,
        child: Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> data, int index) {
    Color? statusColor;
    if (data['status'] == 'Izin') statusColor = Colors.amber;
    if (data['status'] == 'Alpa') statusColor = Colors.redAccent;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.work_history, color: Color(0xFF90612D), size: 36),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data['name']} - ${data['position']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(data['shiftType'], style: TextStyle(fontSize: 12)),
                  SizedBox(height: 4),
                  Text(
                    data['time'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (data['status'] != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      data['status'],
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Color(0xFF90612D)),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Color(0xFF90612D)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditScheduleScreen(
                                  scheduleData: data,
                                  scheduleIndex: index,
                                  onUpdate: (updatedData) {
                                    setState(() {
                                      scheduleList[index] = updatedData;
                                    });
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
}
