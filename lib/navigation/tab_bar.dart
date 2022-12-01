import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scanera/ext/context_ext.dart';
import 'package:scanera/theme/color/app_colors.dart';

enum TabBarItemType {
  bluetooth,
  wifi,
  sensors,
  allScan,
}

extension TabBarItemTypeExtension on TabBarItemType {
  String getLabel(BuildContext context) {
    switch (this) {
      case TabBarItemType.bluetooth:
        return AppLocalizations.of(context).navBarBluetooth;
      case TabBarItemType.wifi:
        return AppLocalizations.of(context).navBarWifi;
      case TabBarItemType.sensors:
        return AppLocalizations.of(context).navBarSensors;
      case TabBarItemType.allScan:
        return AppLocalizations.of(context).navBarAllScan;
    }
  }
}

class ScaffoldWithNavBarTabItem extends BottomNavigationBarItem {
  const ScaffoldWithNavBarTabItem({
    required this.type,
    required this.initialLocation,
    required super.icon,
    required super.activeIcon,
    super.label,
  });

  final String initialLocation;
  final TabBarItemType type;
}

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar(
      {super.key, required this.child, required this.tabs});

  final Widget child;
  final List<ScaffoldWithNavBarTabItem> tabs;

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  int _locationToTabIndex(String location) {
    final index =
        widget.tabs.indexWhere((t) => location.startsWith(t.initialLocation));

    return index < 0 ? 0 : index;
  }

  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  void _onItemTapped(BuildContext context, int tabIndex) {
    if (tabIndex != _currentIndex) {
      context.go(widget.tabs[tabIndex].initialLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            color: AppColors.kSurfaceVariant,
            height: 1,
            thickness: 1,
          ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            unselectedItemColor: AppColors.kPrimary90,
            unselectedFontSize: 11,
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            selectedFontSize: 11,
            selectedItemColor: AppColors.kPrimaryBlue,
            showUnselectedLabels: true,
            items: widget.tabs
                .map(
                  (tab) => ScaffoldWithNavBarTabItem(
                    type: tab.type,
                    initialLocation: tab.initialLocation,
                    icon: tab.icon,
                    label: tab.type.getLabel(context),
                    activeIcon: tab.activeIcon,
                  ),
                )
                .toList(),
            onTap: (index) => _onItemTapped(context, index),
          ),
        ],
      ),
    );
  }
}
