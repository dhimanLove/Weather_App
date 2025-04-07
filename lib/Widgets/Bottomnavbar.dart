import 'package:flutter/material.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'GPS',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications),
        label: 'Notifications',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ]);
  }
}
