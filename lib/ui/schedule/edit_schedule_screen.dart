import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/shift/shift_response.dart';
import 'package:hoteque_app/core/data/networking/states/schedule/update_schedule_result_state.dart';
import 'package:hoteque_app/core/provider/schedule/update_schedule_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditScheduleScreen extends StatefulWidget {
  final Map<String, dynamic> scheduleData;
  final int scheduleIndex;
  final Function(Map<String, dynamic>) onUpdate;
  final Employee employee;

  const EditScheduleScreen({
    super.key,
    required this.scheduleData,
    required this.scheduleIndex,
    required this.onUpdate,
    required this.employee,
  });

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final List<String> status = ['Sakit', 'Izin', 'Alpa'];
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi data dan ambil data shift
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UpdateScheduleProvider>(context, listen: false);
      provider.fetchShifts(widget.employee).then((_) {
        // Setelah data shift diambil, inisialisasi form
        provider.initializeFormData(widget.scheduleData, provider.shifts);
      });
    });
  }

  void _pickDate() async {
    final provider = Provider.of<UpdateScheduleProvider>(context, listen: false);
    
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2028),
    );

    if (picked != null) {
      provider.setSelectedDate(picked);
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final provider = Provider.of<UpdateScheduleProvider>(context, listen: false);
      final scheduleId = widget.scheduleData['id'];
      
      final success = await provider.updateSchedule(widget.employee, scheduleId);
      
      // Periksa apakah widget masih terpasang setelah operasi asinkron
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Jika berhasil, perbarui data dan kembali ke halaman sebelumnya
        final updatedData = {
          'id': scheduleId,
          'name': widget.scheduleData['name'],
          'position': widget.scheduleData['position'],
          'shiftType': provider.selectedShift?.type ?? '',
          'time': '${provider.selectedShift?.startTime ?? ''} - ${provider.selectedShift?.endTime ?? ''}',
          'status': provider.selectedStatus,
        };
        
        widget.onUpdate(updatedData);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Jadwal berhasil diperbarui'))
        );
        
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Jadwal Kerja",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Consumer<UpdateScheduleProvider>(
        builder: (context, provider, _) {
          final state = provider.state;
          
          if (state is UpdateScheduleLoadingState && _isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (state is UpdateScheduleErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red)
              );
              provider.resetState();
            });
          }
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nama Pegawai',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.scheduleData['name'] ?? 'Tidak ada nama',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Shift',
                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<ShiftforSchedule>(
                    value: provider.shifts.isNotEmpty ? provider.selectedShift : null,
                    hint: Text(
                      'Pilih Shift',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    items: provider.shifts.map((shift) => 
                      DropdownMenuItem(
                        value: shift,
                        child: Text("${shift.type} (${shift.startTime} - ${shift.endTime})"),
                      )
                    ).toList(),
                    decoration: InputDecoration(
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        provider.setSelectedShift(value);
                      }
                    },
                    validator: (value) => value == null ? 'Pilih shift kerja' : null,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tanggal',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(provider.selectedDate),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Status',
                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: provider.selectedStatus != null && status.contains(provider.selectedStatus) 
                           ? provider.selectedStatus 
                           : null,
                    hint: Text(
                      'Pilih Status (Opsional)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    items: [
                      // Tambahkan opsi "Tidak Ada" dengan nilai null
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text('Tidak Ada'),
                      ),
                      // Tambahkan opsi status lainnya
                      ...status.map((statusItem) => 
                        DropdownMenuItem<String>(
                          value: statusItem,
                          child: Text(statusItem),
                        )
                      ),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      provider.setSelectedStatus(value);
                    },
                  ),
                  SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8B5E3C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
