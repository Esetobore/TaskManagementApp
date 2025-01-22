import 'package:dufil/config/constants/app_constants.dart';
import 'package:dufil/presentation/screens/profile/profile_screen.dart';
import 'package:dufil/presentation/screens/statistics/statistics_screen.dart';
import 'package:dufil/presentation/screens/tasks/task_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScreenRoute extends StatefulWidget {
  const MainScreenRoute({super.key});

  @override
  State<MainScreenRoute> createState() => _MainScreenRouteState();
}

class _MainScreenRouteState extends State<MainScreenRoute> {
  int _currentIndex = 1;

  final List<Widget> _screens = [
    const TaskListScreen(),
    const StatisticsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 20,
      ),
      child: GNav(
        selectedIndex: currentIndex,
        activeColor: Colors.white,
        tabBackgroundColor: kPrimaryAppColor,
        gap: 8,
        haptic: true,
        padding: const EdgeInsets.all(16),
        onTabChange: onTap,
        tabs: const [
          GButton(
            icon: Icons.task,
            text: 'Tasks',
          ),
          GButton(
            icon: Icons.analytics,
            text: 'Statistics',
          ),
          GButton(
            icon: Icons.person,
            text: 'Profile',
          ),
        ],
      ),
    );
  }
}
