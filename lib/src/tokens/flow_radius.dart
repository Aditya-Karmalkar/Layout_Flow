import 'package:flutter/widgets.dart';
import '../flow_scope.dart';

/// Adaptive border radius tokens for layout_flow.
///
/// All values scale with the screen via [FlowConfig.sp].
///
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     borderRadius: FlowRadius.md(context),
///   ),
/// )
/// ```
class FlowRadius {
  FlowRadius._();

  /// 4dp base — subtle rounding (inputs, chips).
  static BorderRadius sm(BuildContext context) =>
      BorderRadius.circular(FlowScope.of(context).sp(4));

  /// 8dp base — standard cards and containers.
  static BorderRadius md(BuildContext context) =>
      BorderRadius.circular(FlowScope.of(context).sp(8));

  /// 12dp base — prominent cards, bottom sheets.
  static BorderRadius lg(BuildContext context) =>
      BorderRadius.circular(FlowScope.of(context).sp(12));

  /// 16dp base — modals, dialogs.
  static BorderRadius xl(BuildContext context) =>
      BorderRadius.circular(FlowScope.of(context).sp(16));

  /// 24dp base — large surfaces, full rounded buttons.
  static BorderRadius xxl(BuildContext context) =>
      BorderRadius.circular(FlowScope.of(context).sp(24));

  /// Fully circular (pill-shaped buttons, avatars).
  static BorderRadius full(BuildContext context) =>
      BorderRadius.circular(FlowScope.of(context).sp(999));
}
