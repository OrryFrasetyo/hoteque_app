import 'package:flutter/material.dart';
import 'package:hoteque_app/ui/history/history_screen.dart';
import 'package:hoteque_app/ui/home/home_screen.dart';
import 'package:hoteque_app/ui/schedule/schedule_screen.dart';
import 'package:hoteque_app/ui/task/task_screen.dart';

class MainScreen extends StatelessWidget {
  final VoidCallback onLogout;
  final int currentIndex;
  final Function(int) onTabChanged;

  const MainScreen({
    super.key,
    required this.onLogout,
    required this.currentIndex,
    required this.onTabChanged,
  });

  // flag to handle width platform
  static const int tabletBreakpoint = 600;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < tabletBreakpoint;

    Widget content = IndexedStack(
      index: currentIndex,
      children: [
        HomeScreen(onLogout: onLogout),
        ScheduleScreen(),
        TaskScreen(),
        HistoryScreen(),
      ],
    );

    return Scaffold(
      body:
          isMobile
              ? content
              : Row(
                children: [
                  NavigationRail(
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text("Beranda"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.schedule),
                        label: Text("Jadwal"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.assignment),
                        label: Text("Tugas"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.history_outlined),
                        label: Text("Riwayat"),
                      ),
                    ],
                    selectedIndex: currentIndex,
                    onDestinationSelected: onTabChanged,
                    labelType: NavigationRailLabelType.all,
                  ),

                  VerticalDivider(width: 1),

                  Expanded(child: content),
                ],
              ),
      bottomNavigationBar:
          isMobile
              ? NavigationBar(
                selectedIndex: currentIndex,
                onDestinationSelected: onTabChanged,
                destinations: [
                  NavigationDestination(
                    icon: Icon(Icons.home),
                    label: "Beranda",
                    tooltip: "Beranda",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.schedule),
                    label: "Jadwal",
                    tooltip: "Jadwal",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.assignment),
                    label: "Tugas",
                    tooltip: "Tugas",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.history),
                    label: "Riwayat",
                    tooltip: "Riwayat",
                  ),
                ],
              )
              : null,
    );
  }
}
