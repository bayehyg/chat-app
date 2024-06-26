import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomBottomNav extends StatefulWidget {
  static bool notifications = false;
  final Function onNotificationsSelected;
  final Function onHomeSelected;
  CustomBottomNav(
      {super.key,
      required this.onNotificationsSelected,
      required this.onHomeSelected});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: const Color(0xFF1F1F1F),
      onDestinationSelected: (int index) {
        if (index == currentPageIndex) return;
        setState(() {
          currentPageIndex = index;
        });
        if (index == 0) {
          widget.onHomeSelected();
        }
        if (index == 1) {
          widget.onNotificationsSelected();
        }
      },
      indicatorColor: const Color(0xff5727B6),
      selectedIndex: currentPageIndex,
      destinations: <Widget>[
        const NavigationDestination(
          selectedIcon: Icon(Icons.home, size: 30, color: Colors.white),
          icon: Icon(Icons.home_outlined, size: 30, color: Colors.grey),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: CustomBottomNav.notifications
              ? NavBadge(
                  icon: Icons.notifications_sharp,
                  color: Colors.white,
                  label: '',
                )
              : const Icon(Icons.notifications_sharp),
          icon: CustomBottomNav.notifications
              ? NavBadge(
                  icon: Icons.notifications_sharp,
                  color: Colors.grey,
                  label: '',
                )
              : Icon(
                  Icons.notifications_sharp,
                  size: MediaQuery.of(context).size.width / 13,
                ),
          label: 'Notifications',
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
      label: label == '' ? null : Text(label),
      child: Icon(
        icon,
        color: color,
        size: 30,
      ),
    );
  }
}
