import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final List<String> employees = [
    'Bagas Saputra',
    'Dimas Raka',
    'Ferdi Alamsyah',
    'Yuni Pratiwi',
  ];

  final List<String> shifts = ['Pagi', 'Siang', 'Malam'];

  String? selectedEmployee;
  String? selectedShift;
  DateTime? selectedDate;

  final _formKey = GlobalKey<FormState>();

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
      // Tambahkan aksi submit ke backend di sini
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Jadwal berhasil ditambahkan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Buat Jadwal Kerja",
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
