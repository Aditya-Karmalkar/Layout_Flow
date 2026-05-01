import 'package:flutter/material.dart';
import '../flow_scope.dart';
import 'flow_theme.dart';

/// Adaptive spacing tokens for layout_flow.
///
/// All values scale automatically with the screen size via [FlowConfig.sp].
/// Use these instead of raw numbers to keep spacing consistent across devices.
///
/// These tokens derive from [FlowTheme.spacingBase] (default 8.0).
///
/// ```dart
/// Padding(
///   padding: EdgeInsets.all(FlowSpacing.md(context)),
///   child: ...,
/// )
/// ```
class FlowSpacing {
  FlowSpacing._();

  /// 0.5x base — use for tight internal gaps (default 4dp).
  static double xs(BuildContext context) {
    final base = FlowTheme.of(context).spacingBase;
    return FlowScope.of(context).sp(base * 0.5);
  }

  /// 1x base — use for small gaps between related items (default 8dp).
  static double sm(BuildContext context) {
    final base = FlowTheme.of(context).spacingBase;
    return FlowScope.of(context).sp(base);
  }

  /// 2x base — standard content padding / card padding (default 16dp).
  static double md(BuildContext context) {
    final base = FlowTheme.of(context).spacingBase;
    return FlowScope.of(context).sp(base * 2);
  }

  /// 3x base — section gaps (default 24dp).
  static double lg(BuildContext context) {
    final base = FlowTheme.of(context).spacingBase;
    return FlowScope.of(context).sp(base * 3);
  }

  /// 4x base — major section separators (default 32dp).
  static double xl(BuildContext context) {
    final base = FlowTheme.of(context).spacingBase;
    return FlowScope.of(context).sp(base * 4);
  }

  /// 6x base — screen-level vertical rhythm (default 48dp).
  static double xxl(BuildContext context) {
    final base = FlowTheme.of(context).spacingBase;
    return FlowScope.of(context).sp(base * 6);
  }

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
  /// Uses [sp] scaling for consistency.
  static EdgeInsets all(BuildContext context, double value) =>
      EdgeInsets.all(FlowScope.of(context).sp(value));

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
