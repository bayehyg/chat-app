import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return NavigationBar(
      backgroundColor: Color(0xFF1F1F1F),
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      indicatorColor: Color(0xff5727B6),
      selectedIndex: currentPageIndex,
      destinations: <Widget>[
        const NavigationDestination(
          selectedIcon: Icon(Icons.home, size: 30, color: Colors.white),
          icon: Icon(Icons.home_outlined, size: 30, color: Colors.grey),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: NavBadge(icon: Icons.notifications_sharp, label: '', color: Colors.white),
          icon: NavBadge(icon: Icons.notifications_sharp, label: '', color: Colors.grey),
          label: 'Notifications',
        ),
        NavigationDestination(
          selectedIcon: NavBadge(icon: CupertinoIcons.chat_bubble_2, label: '2', color: Colors.white),
          icon: NavBadge(icon: CupertinoIcons.chat_bubble_2, label: '2', color: Colors.grey),
          label: 'Messages',
        ),
      ],
    );
  }
}

class NavBadge extends StatelessWidget {
  Color color;
  IconData icon;
  String label;
  NavBadge({
    required this.color,
    required this.label,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: label == ''? null: Text(label),
      child: Icon(icon, color: color, size: 30,),
    );
  }
}
