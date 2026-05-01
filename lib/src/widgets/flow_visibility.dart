import 'package:flutter/widgets.dart';
import '../flow_scope.dart';
import '../flow_config.dart';

/// A widget that controls visibility based on current [FlowBreakpoint].
///
/// Use this to easily show or hide components like sidebars, bottom bars,
/// or detailed views depending on the user's screen size.
///
/// ```dart
/// FlowVisibility(
///   showOn: [FlowBreakpoint.expanded],
///   child: DesktopSidebar(),
/// )
/// ```
class FlowVisibility extends StatelessWidget {
  /// The widget to show/hide.
  final Widget child;

  /// The list of breakpoints where this widget should be visible.
  final List<FlowBreakpoint> showOn;

  const FlowVisibility({
    super.key,
    required this.child,
    required this.showOn,
  });

  /// Only visible on compact screens (phones).
  factory FlowVisibility.compactOnly({
    Key? key,
    required Widget child,
  }) =>
      FlowVisibility(
        key: key,
        showOn: const [FlowBreakpoint.compact],
        child: child,
      );

  /// Only visible on medium screens (tablets).
  factory FlowVisibility.mediumOnly({
    Key? key,
    required Widget child,
  }) =>
      FlowVisibility(
        key: key,
        showOn: const [FlowBreakpoint.medium],
        child: child,
      );

  /// Only visible on expanded screens (desktop/web).
  factory FlowVisibility.expandedOnly({
    Key? key,
    required Widget child,
  }) =>
      FlowVisibility(
        key: key,
        showOn: const [FlowBreakpoint.expanded],
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final current = context.flowBreakpoint;
    final isVisible = showOn.contains(current);

    if (!isVisible) return const SizedBox.shrink();

    return child;
  }
}
