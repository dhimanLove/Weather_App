import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:weatherapp/Modal/forecast_model.dart';
import 'package:weatherapp/Pages/Homepage.dart';
import 'package:weatherapp/Pages/Profile.dart';
import 'package:weatherapp/Widgets/Globe.dart';
import 'package:weatherapp/Widgets/Explore.dart';

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
    const Notifications(),
    AccountScreen(),
  ];


  final Color backgroundColor = const Color(0xFF0F1626);
  final Color barColor = const Color(0xFF1E2A44);
  final Color activeColor = const Color(0xFFE39122); // Warm gold/orange, aligns with daytime theme
  final Color inactiveColor = const Color(0xFFB0BEC5); // Soft grey, subtle yet readable
  final Color buttonBackgroundColor = const Color(0xFF2E3155); // Deeper blue, complements gradient

  List<Widget> get navItems => [
    Icon(LineIcons.home,
        size: 30, color: selectedIndex == 0 ? activeColor : inactiveColor),
    Icon(LineIcons.search,
        size: 30, color: selectedIndex == 1 ? activeColor : inactiveColor),
    Icon(LineIcons.globe,
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
        buttonBackgroundColor: buttonBackgroundColor,
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