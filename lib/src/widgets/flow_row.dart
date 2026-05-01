import 'package:flutter/widgets.dart';
import '../flow_scope.dart';

enum _FlowRowMode {
  breakpoint,
  constraints,
  orientation,
}

/// A smart layout widget that renders as a [Row] or [Column] based on
/// available space or orientation.
///
/// By default, it uses [LayoutBuilder] to check its own available width
/// against the [breakpoint].
class FlowRow extends StatelessWidget {
  /// The children to display.
  final List<Widget> children;

  /// The width threshold (in logical pixels) below which
  /// the layout switches from [Row] to [Column].
  ///
  /// Defaults to 480.
  final double breakpoint;

  /// Main axis alignment when rendered as a [Row].
  final MainAxisAlignment rowMainAxisAlignment;

  /// Cross axis alignment when rendered as a [Row].
  final CrossAxisAlignment rowCrossAxisAlignment;

  /// Main axis alignment when rendered as a [Column].
  final MainAxisAlignment columnMainAxisAlignment;

  /// Cross axis alignment when rendered as a [Column].
  final CrossAxisAlignment columnCrossAxisAlignment;

  /// Gap between children (applied via [SizedBox]).
  final double? gap;

  /// The mode used to determine the layout switch.
  final _FlowRowMode _mode;

  /// Standard constructor that adapts based on local constraints.
  ///
  /// If the available width is less than [breakpoint], it renders as a [Column].
  const FlowRow({
    super.key,
    required this.children,
    this.breakpoint = 480,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.stretch,
    this.gap,
  }) : _mode = _FlowRowMode.constraints;

  /// Explicitly adapts based on a fixed breakpoint relative to screen width.
  const FlowRow.breakpoint({
    super.key,
    required this.children,
    this.breakpoint = 480,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.stretch,
    this.gap,
  }) : _mode = _FlowRowMode.breakpoint;

  /// Adapts based on device orientation.
  ///
  /// Stacks as a [Column] in portrait, and as a [Row] in landscape.
  const FlowRow.orientation({
    super.key,
    required this.children,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.stretch,
    this.gap,
  })  : _mode = _FlowRowMode.orientation,
        breakpoint = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact;

        switch (_mode) {
          case _FlowRowMode.breakpoint:
            final flow = FlowScope.of(context);
            isCompact = flow.screen.width < breakpoint;
          case _FlowRowMode.orientation:
            final orientation = MediaQuery.orientationOf(context);
            isCompact = orientation == Orientation.portrait;
          case _FlowRowMode.constraints:
            isCompact = constraints.maxWidth < breakpoint;
        }

        final spacedChildren = gap != null
            ? _intersperse(
                children,
                isCompact ? SizedBox(height: gap) : SizedBox(width: gap),
              )
            : children;

        if (isCompact) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: columnMainAxisAlignment,
            crossAxisAlignment: columnCrossAxisAlignment,
            children: _unwrapFlex(spacedChildren),
          );
        }

        return Row(
          mainAxisAlignment: rowMainAxisAlignment,
          crossAxisAlignment: rowCrossAxisAlignment,
          children: spacedChildren,
        );
      },
    );
  }

  /// Unwraps [Expanded] and [Flexible] widgets to their inner child.
  List<Widget> _unwrapFlex(List<Widget> widgets) {
    return widgets.map((w) {
      if (w is Expanded) return w.child;
      if (w is Flexible) return w.child;
      return w;
    }).toList();
  }

  List<Widget> _intersperse(List<Widget> widgets, Widget separator) {
    final result = <Widget>[];
    for (var i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i < widgets.length - 1) result.add(separator);
    }
    return result;
  }
}
