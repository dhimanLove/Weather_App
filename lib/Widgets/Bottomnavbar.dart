import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:weatherapp/Modal/forecast_model.dart';
import 'package:weatherapp/Pages/Homepage.dart';
import 'package:weatherapp/Pages/Profile.dart';
import 'package:weatherapp/Widgets/notification.dart';
import 'package:weatherapp/Widgets/weathermap.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const ExploreScreen(),
    const notifications(),
    AccountScreen(),
  ];

  final Color backgroundColor = const Color(0xFF0D1B2A);
  final Color activeColor = Colors.black;
  final Color inactiveColor = Colors.white;
  final Color barColor = Color(0xFF1B263B);

  List<Widget> get navItems => [
        Icon(LineIcons.home,
            size: 30, color: selectedIndex == 0 ? activeColor : inactiveColor),
        Icon(LineIcons.search,
            size: 30, color: selectedIndex == 1 ? activeColor : inactiveColor),
        Icon(LineIcons.bell,
            size: 30, color: selectedIndex == 2 ? activeColor : inactiveColor),
        Icon(LineIcons.user,
            size: 30, color: selectedIndex == 3 ? activeColor : inactiveColor),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        letIndexChange: (index) => true,
        height: 60,
        items: navItems,
        color: barColor,
        buttonBackgroundColor: Colors.grey[300],
        backgroundColor: backgroundColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
