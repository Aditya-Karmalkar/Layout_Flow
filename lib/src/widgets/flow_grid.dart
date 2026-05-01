import 'package:flutter/widgets.dart';
import '../flow_scope.dart';
import '../flow_config.dart';

/// Configuration for the number of columns in a [FlowGrid].
class FlowGridColumns {
  /// Number of columns on compact screens (phones).
  final int compact;

  /// Number of columns on medium screens (tablets).
  final int medium;

  /// Number of columns on expanded screens (desktop/web).
  final int expanded;

  const FlowGridColumns({
    this.compact = 1,
    this.medium = 2,
    this.expanded = 3,
  });

  /// Resolves the column count based on the given [breakpoint].
  int resolve(FlowBreakpoint breakpoint) {
    switch (breakpoint) {
      case FlowBreakpoint.compact:
        return compact;
      case FlowBreakpoint.medium:
        return medium;
      case FlowBreakpoint.expanded:
        return expanded;
    }
  }
}

/// A responsive grid that automatically adjusts its column count
/// based on the active [FlowBreakpoint].
///
/// ```dart
/// FlowGrid(
///   columns: const FlowGridColumns(compact: 1, medium: 2, expanded: 3),
///   gap: 16,
///   children: [ ... ],
/// )
/// ```
class FlowGrid extends StatelessWidget {
  /// The widgets to display in the grid.
  final List<Widget> children;

  /// Column configuration for different screen sizes.
  final FlowGridColumns columns;

  /// Spacing between columns and rows.
  final double gap;

  /// The aspect ratio of each item in the grid.
  final double childAspectRatio;

  /// Whether the grid should wrap its content. Defaults to true.
  final bool shrinkWrap;

  /// Scroll physics for the grid. Defaults to [NeverScrollableScrollPhysics]
  /// because [FlowGrid] is often used inside other scrollable views.
  final ScrollPhysics physics;

  /// The padding around the grid.
  final EdgeInsetsGeometry? padding;

  const FlowGrid({
    super.key,
    required this.children,
    this.columns = const FlowGridColumns(),
    this.gap = 0,
    this.childAspectRatio = 1.0,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final breakpoint = context.flowBreakpoint;
    final crossAxisCount = columns.resolve(breakpoint);

    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: gap,
      crossAxisSpacing: gap,
      childAspectRatio: childAspectRatio,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      children: children,
    );
  }
}
