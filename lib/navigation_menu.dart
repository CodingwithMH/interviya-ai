import 'package:flutter/material.dart';
import 'package:app_projects/screens/home.dart';
import 'package:app_projects/screens/history.dart';
import 'package:app_projects/screens/stats.dart';
import 'package:app_projects/screens/profile.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Home(),
    const HistoryPage(),
    const Stats(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xffF8FAFC),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        height: 80,
        margin:  EdgeInsets.fromLTRB(15, 0, 15, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Color(0xff1E293B).withValues(alpha: 0.1),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor:  Color(0xFF0A898D),
            unselectedItemColor: Colors.grey.withValues(alpha: 0.6),
            onTap: (index) => setState(() => _selectedIndex = index),
            items:  [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
