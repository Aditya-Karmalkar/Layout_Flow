import 'package:flutter/widgets.dart';
import '../flow_scope.dart';

/// A smart layout widget that renders as a [Row] on wider screens
/// and collapses to a [Column] on compact screens.
///
/// ```dart
/// FlowRow(
///   children: [
///     Expanded(child: Card(...)),
///     Expanded(child: Card(...)),
///   ],
/// )
/// ```
///
/// On phones (< [breakpoint]): children stack vertically as a [Column].
/// On tablets and web (>= [breakpoint]): children sit side-by-side as a [Row].
class FlowRow extends StatelessWidget {
  /// The children to display.
  final List<Widget> children;

  /// The screen width threshold (in logical pixels) below which
  /// the layout switches from [Row] to [Column].
  ///
  /// Defaults to 480 (aligns with [FlowBreakpoint.compact]).
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

  const FlowRow({
    super.key,
    required this.children,
    this.breakpoint = 480,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.stretch,
    this.gap,
  });

  @override
  Widget build(BuildContext context) {
    final flow = FlowScope.of(context);
    final isCompact = flow.screen.width < breakpoint;

    final spacedChildren = gap != null
        ? _intersperse(
            children,
            isCompact
                ? SizedBox(height: gap)
                : SizedBox(width: gap),
          )
        : children;

    if (isCompact) {
      return Column(
        mainAxisAlignment: columnMainAxisAlignment,
        crossAxisAlignment: columnCrossAxisAlignment,
        children: spacedChildren,
      );
    }

    return Row(
      mainAxisAlignment: rowMainAxisAlignment,
      crossAxisAlignment: rowCrossAxisAlignment,
      children: spacedChildren,
    );
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
