import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditScheduleScreen extends StatefulWidget {
  final Map<String, dynamic> scheduleData;
  final int scheduleIndex;
  final Function(Map<String, dynamic>) onUpdate;

  const EditScheduleScreen({
    super.key,
    required this.scheduleData,
    required this.scheduleIndex,
    required this.onUpdate,
  });

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final List<String> employees = [
    'Bagas Saputra',
    'Dimas Raka',
    'Ferdi Alamsyah',
    'Yuni Pratiwi',
    'Bagas',
  ];

  final List<String> shifts = ['Pagi', 'Siang', 'Malam'];

  final List<String> status = ['Izin', 'Alpa'];

  String? selectedEmployee;
  String? selectedShift;
  String? selectedStatus;
  DateTime? selectedDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai dari data yang diterima
    final data = widget.scheduleData;

    // Tentukan employee dari nama
    selectedEmployee = data['name'];

    // Tentukan shift dari shiftType (hilangkan kata "Shift" jika ada)
    if (data['shiftType'] != null) {
      String shiftType = data['shiftType'].toString();
      if (shiftType.contains('Pagi')) {
        selectedShift = 'Pagi';
      } else if (shiftType.contains('Siang')) {
        selectedShift = 'Siang';
      } else if (shiftType.contains('Malam')) {
        selectedShift = 'Malam';
      }
    }

    // Set status jika ada
    selectedStatus = data['status'];

    // Set tanggal (dalam contoh ini kita gunakan tanggal hari ini)
    selectedDate = DateTime.now();
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2028),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> updatedData = {
        'name': selectedEmployee,
        'position': widget.scheduleData['position'], // Pertahankan posisi
        'shiftType': 'Shift $selectedShift',
        'time': _getTimeRange(
          selectedShift,
        ), // Fungsi untuk mendapatkan rentang waktu
        'status': selectedStatus,
      };

      // Panggil callback onUpdate dengan data yang telah diperbarui
      widget.onUpdate(updatedData);
      // Tambahkan aksi submit ke backend di sini
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Jadwal berhasil diedit')));

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    }
  }

  // Fungsi untuk mendapatkan rentang waktu berdasarkan shift
  String _getTimeRange(String? shift) {
    switch (shift) {
      case 'Pagi':
        return '08.00 WIB - 15.00 WIB';
      case 'Siang':
        return '15.00 WIB - 22.00 WIB';
      case 'Malam':
        return '22.00 WIB - 08.00 WIB';
      default:
        return '';
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
      body: Padding(
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
              Center(
                child: SizedBox(
                  child: DropdownSearch<String>(
                    items: employees,
                    selectedItem: selectedEmployee,
                    onChanged: (value) {
                      setState(() {
                        selectedEmployee = value;
                      });
                    },
                    dropdownBuilder: (context, selectedItem) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          selectedItem ?? 'Pilih nama pegawai',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Cari pegawai...',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(title: Text(item));
                      },
                    ),
                    validator:
                        (value) => value == null ? 'Pilih nama pegawai' : null,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Shift',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedShift,
                hint: Text(
                  'Pilih Shift',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                items:
                    shifts
                        .map(
                          (shift) => DropdownMenuItem(
                            value: shift,
                            child: Text(shift),
                          ),
                        )
                        .toList(),
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedShift = value;
                  });
                },
                validator:
                    (value) => value == null ? 'Pilih shift kerja' : null,
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
                    selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                        : 'Pilih tanggal',
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
                value: selectedStatus,
                hint: Text(
                  'Pilih Status',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                items:
                    status
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih Status' : null,
              ),
              SizedBox(height: 32),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
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
      ),
    );
  }
}
