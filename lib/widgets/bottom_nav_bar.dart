import 'package:flutter/material.dart';

class NavBarItem {
  NavBarItem({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;
}

class BottomNavBar extends StatelessWidget {
  BottomNavBar({
    Key? key,
    required this.onBack,
    required this.items,
    this.currentIndex,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.backgroundColor,
    this.showLabels = false,
  }) : super(key: key);

  final VoidCallback onBack;
  final List<NavBarItem> items;
  final bool showLabels;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final int? currentIndex;

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    return BottomNavigationBar(
      currentIndex: currentIndex ?? 0,
      backgroundColor: backgroundColor ?? Colors.brown.shade50,
      selectedItemColor: selectedItemColor ?? primaryColor,
      unselectedItemColor: unselectedItemColor ?? Colors.grey.shade700,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index == 0) {
          onBack();
        } else {
          this.items[index - 1].onTap();
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_back),
          label: 'Overview',
        ),
        ...items.map(
          (iconData) => BottomNavigationBarItem(
            icon: Icon(iconData.icon),
            label: iconData.toString(),
          ),
        ),
      ],
    );
  }
}
