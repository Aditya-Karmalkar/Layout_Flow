import 'package:flutter/material.dart';
import '../flow_scope.dart';

/// A data class defining a navigation destination for [FlowNavigationBar].
class FlowNavigationDestination {
  /// The icon to display.
  final IconData icon;

  /// An optional alternative icon for the selected state.
  final IconData? selectedIcon;

  /// The label text.
  final String label;

  /// An optional tooltip.
  final String? tooltip;

  const FlowNavigationDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.tooltip,
  });
}

/// An adaptive navigation component that automatically switches between
/// a [BottomNavigationBar] and a [NavigationRail] based on the current breakpoint.
///
/// Use this inside [FlowScaffold.navigation] for a complete adaptive shell.
class FlowNavigationBar extends StatelessWidget {
  /// The list of destinations to display.
  final List<FlowNavigationDestination> destinations;

  /// The index of the currently selected destination.
  final int selectedIndex;

  /// Called when a destination is selected.
  final ValueChanged<int>? onDestinationSelected;

  /// The background color of the navigation component.
  final Color? backgroundColor;

  /// The elevation of the navigation component.
  final double? elevation;

  /// Whether to show labels, and when.
  final NavigationDestinationLabelBehavior labelBehavior;

  /// Optional header widget for the [NavigationRail] (desktop mode).
  final Widget? leading;

  /// Optional footer widget for the [NavigationRail] (desktop mode).
  final Widget? trailing;

  /// Whether the rail should be extended (desktop mode).
  final bool extended;

  const FlowNavigationBar({
    super.key,
    required this.destinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.backgroundColor,
    this.elevation,
    this.labelBehavior = NavigationDestinationLabelBehavior.alwaysShow,
    this.leading,
    this.trailing,
    this.extended = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompact = context.isCompact;

    if (isCompact) {
      return BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onDestinationSelected,
        backgroundColor: backgroundColor,
        elevation: elevation ?? 8.0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: _shouldShowLabels(true),
        showUnselectedLabels: _shouldShowLabels(false),
        items: destinations.map((d) {
          return BottomNavigationBarItem(
            icon: Icon(d.icon),
            activeIcon: d.selectedIcon != null ? Icon(d.selectedIcon) : null,
            label: d.label,
            tooltip: d.tooltip,
          );
        }).toList(),
      );
    }

    // Medium/Expanded: Navigation Rail
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: backgroundColor,
      elevation: elevation,
      labelType: _getRailLabelType(),
      leading: leading,
      trailing: trailing,
      extended: extended,
      destinations: destinations.map((d) {
        return NavigationRailDestination(
          icon: Icon(d.icon),
          selectedIcon: d.selectedIcon != null ? Icon(d.selectedIcon) : null,
          label: Text(d.label),
        );
      }).toList(),
    );
  }

  bool _shouldShowLabels(bool selected) {
    switch (labelBehavior) {
      case NavigationDestinationLabelBehavior.alwaysShow:
        return true;
      case NavigationDestinationLabelBehavior.alwaysHide:
        return false;
      case NavigationDestinationLabelBehavior.onlyShowSelected:
        return selected;
    }
  }

  NavigationRailLabelType _getRailLabelType() {
    if (extended) return NavigationRailLabelType.none;
    switch (labelBehavior) {
      case NavigationDestinationLabelBehavior.alwaysShow:
        return NavigationRailLabelType.all;
      case NavigationDestinationLabelBehavior.alwaysHide:
        return NavigationRailLabelType.none;
      case NavigationDestinationLabelBehavior.onlyShowSelected:
        return NavigationRailLabelType.selected;
    }
  }
}
