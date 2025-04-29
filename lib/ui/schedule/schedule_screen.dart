import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/schedule_employee.dart';
import 'package:hoteque_app/core/data/networking/states/schedule_employee_result_state.dart';
import 'package:hoteque_app/core/provider/auth_provider.dart';
import 'package:hoteque_app/core/provider/schedule_employee_provider.dart';
import 'package:hoteque_app/ui/schedule/widgets/schedule_item_widget.dart';
import 'package:hoteque_app/ui/schedule/widgets/schedule_error_widget.dart';
import 'package:hoteque_app/ui/schedule/widgets/schedule_loading_widget.dart';
import 'package:provider/provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSchedules();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchSchedules() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final scheduleProvider = Provider.of<ScheduleEmployeeProvider>(
      context,
      listen: false,
    );

    // Check if user is logged in
    if (authProvider.isLoggedIn && authProvider.employee != null) {
      await scheduleProvider.getScheduleEmployee(
        employee: authProvider.employee!,
      );
    }
  }

  Future<void> _handleRefresh() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final scheduleProvider = Provider.of<ScheduleEmployeeProvider>(
      context,
      listen: false,
    );

    // Check if user is logged in
    if (authProvider.isLoggedIn && authProvider.employee != null) {
      await scheduleProvider.getScheduleEmployee(
        employee: authProvider.employee!,
      );
    }

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Jadwal Kerja Bulan Ini',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<ScheduleEmployeeProvider>(
                  builder: (context, provider, child) {
                    final state = provider.state;

                    return RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: () {
                        if (state is ScheduleEmployeeLoadingState) {
                          return ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return const ScheduleLoadingWidget(
                                message: 'Memuat jadwal kerja...',
                              );
                            },
                          );
                        } else if (state is ScheduleEmployeeErrorState) {
                          return ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return ScheduleErrorWidget(
                                message: state.message,
                                onRefresh: _handleRefresh,
                              );
                            },
                          );
                        } else if (state is ScheduleEmployeeLoadedState) {
                          if (state.schedules.isEmpty) {
                            return ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 100),
                                      Icon(
                                        Icons.event_busy,
                                        size: 60,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Belum ada jadwal untuk bulan ini',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tarik ke bawah untuk menyegarkan',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          return _buildScheduleList(state.schedules);
                        } else {
                          // Initial state or other state
                          return ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return const ScheduleLoadingWidget(
                                message: 'Memuat jadwal kerja...',
                              );
                            },
                          );
                        }
                      }(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleList(List<ScheduleEmployee> schedules) {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        return ScheduleItemWidget(schedule: schedules[index]);
      },
    );
  }
}
