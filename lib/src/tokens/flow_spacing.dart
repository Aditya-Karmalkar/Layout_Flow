import 'package:flutter/widgets.dart';
import '../flow_scope.dart';

/// Adaptive spacing tokens for layout_flow.
///
/// All values scale automatically with the screen size via [FlowConfig.w].
/// Use these instead of raw numbers to keep spacing consistent across devices.
///
/// ```dart
/// Padding(
///   padding: EdgeInsets.all(FlowSpacing.md(context)),
///   child: ...,
/// )
/// ```
class FlowSpacing {
  FlowSpacing._();

  /// 4dp base — use for tight internal gaps.
  static double xs(BuildContext context) => FlowScope.of(context).w(4);

  /// 8dp base — use for small gaps between related items.
  static double sm(BuildContext context) => FlowScope.of(context).w(8);

  /// 16dp base — standard content padding / card padding.
  static double md(BuildContext context) => FlowScope.of(context).w(16);

  /// 24dp base — section gaps.
  static double lg(BuildContext context) => FlowScope.of(context).w(24);

  /// 32dp base — major section separators.
  static double xl(BuildContext context) => FlowScope.of(context).w(32);

  /// 48dp base — screen-level vertical rhythm.
  static double xxl(BuildContext context) => FlowScope.of(context).w(48);

  /// Returns a symmetric [EdgeInsets] scaled to the screen.
  static EdgeInsets symmetric(
    BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
  }) {
    final flow = FlowScope.of(context);
    return EdgeInsets.symmetric(
      horizontal: flow.w(horizontal),
      vertical: flow.h(vertical),
    );
  }

  /// Returns an [EdgeInsets] with all sides equal, scaled to the screen.
  static EdgeInsets all(BuildContext context, double value) =>
      EdgeInsets.all(FlowScope.of(context).w(value));

  /// Returns an [EdgeInsets] with individual sides, each scaled.
  static EdgeInsets only(
    BuildContext context, {
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    final flow = FlowScope.of(context);
    return EdgeInsets.only(
      left: flow.w(left),
      top: flow.h(top),
      right: flow.w(right),
      bottom: flow.h(bottom),
    );
  }
}
