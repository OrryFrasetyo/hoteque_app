import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/employee.dart';
import 'package:hoteque_app/core/data/networking/response/schedule/employee_in_department_response.dart';
import 'package:hoteque_app/core/data/networking/response/shift/shift_response.dart';
import 'package:hoteque_app/core/data/networking/states/schedule/add_schedule_result_state.dart';
import 'package:hoteque_app/core/provider/schedule/add_schedule_provider.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';

class AddScheduleScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Employee? employee;

  const AddScheduleScreen({
    super.key, 
    this.employee, 
    required this.onBack
  });

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AddScheduleProvider>(context, listen: false);

      // Fetch initial data
      if (widget.employee != null) {
        provider.fetchEmployees(widget.employee!);
        provider.fetchShifts();
      }
    });
  }

  void _pickDate(BuildContext context) async {
    final provider = Provider.of<AddScheduleProvider>(context, listen: false);

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
    if (_formKey.currentState!.validate() && widget.employee != null) {
      final provider = Provider.of<AddScheduleProvider>(context, listen: false);
      final success = await provider.createSchedule(widget.employee!);

      if (success) {
        // Navigate back to schedule employee screen
        widget.onBack();
      }
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
            widget.onBack();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Consumer<AddScheduleProvider>(
        builder: (context, provider, _) {
          if (provider.state is AddScheduleLoadingState) {
            return Center(
              child: CircularProgressIndicator(color: const Color(0xFF90612D)),
            );
          }
    
          if (provider.state is AddScheduleErrorState) {
            final errorState = provider.state as AddScheduleErrorState;
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
                  Text(errorState.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.employee != null) {
                        provider.fetchEmployees(widget.employee!);
                        provider.fetchShifts();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF90612D),
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
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
                  Center(
                    child: SizedBox(
                      child: DropdownSearch<EmployeeSearch>(
                        items: provider.employees,
                        selectedItem: provider.selectedEmployee,
                        itemAsString: (item) => item.name,
                        onChanged: (value) {
                          if (value != null) {
                            provider.setSelectedEmployee(value);
                          }
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
                              selectedItem?.name ?? 'Pilih nama pegawai',
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
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          itemBuilder: (context, item, isSelected) {
                            return ListTile(title: Text(item.name));
                          },
                        ),
                        validator:
                            (value) =>
                                value == null ? 'Pilih nama pegawai' : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Shift',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  DropdownSearch<ShiftforSchedule>(
                    items: provider.shifts,
                    selectedItem: provider.selectedShift,
                    itemAsString: (item) => item.type,
                    onChanged: (value) {
                      if (value != null) {
                        provider.setSelectedShift(value);
                      }
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Pilih Shift',
                      ),
                    ),
                    popupProps: PopupProps.menu(
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(
                          title: Text(item.type),
                          subtitle: Text("${item.startTime} - ${item.endTime}"),
                        );
                      },
                    ),
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
                    onTap: () => _pickDate(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        DateFormat('dd-MM-yyyy').format(provider.selectedDate),
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
          );
        },
      ),
    );
  }
}
