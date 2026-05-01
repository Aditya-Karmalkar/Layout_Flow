import 'package:flutter/widgets.dart';
import '../flow_scope.dart';

/// Adaptive typography tokens for layout_flow.
///
/// Each style scales its [fontSize] automatically via [FlowConfig.text].
/// These follow a standard type scale: display → headline → title → body → label.
///
/// ```dart
/// FlowText('Welcome', style: FlowTextStyle.headline(context))
/// ```
class FlowTextStyle {
  FlowTextStyle._();

  /// 48sp base — large hero text.
  static TextStyle display(BuildContext context, {FontWeight? weight}) {
    final flow = FlowScope.of(context);
    return TextStyle(
      fontSize: flow.text(48),
      fontWeight: weight ?? FontWeight.w700,
      height: 1.1,
    );
  }

  /// 32sp base — section or page headings.
  static TextStyle headline(BuildContext context, {FontWeight? weight}) {
    final flow = FlowScope.of(context);
    return TextStyle(
      fontSize: flow.text(32),
      fontWeight: weight ?? FontWeight.w700,
      height: 1.2,
    );
  }

  /// 22sp base — card titles, dialog headings.
  static TextStyle title(BuildContext context, {FontWeight? weight}) {
    final flow = FlowScope.of(context);
    return TextStyle(
      fontSize: flow.text(22),
      fontWeight: weight ?? FontWeight.w600,
      height: 1.3,
    );
  }

  /// 16sp base — standard body copy.
  static TextStyle body(BuildContext context, {FontWeight? weight}) {
    final flow = FlowScope.of(context);
    return TextStyle(
      fontSize: flow.text(16),
      fontWeight: weight ?? FontWeight.w400,
      height: 1.5,
    );
  }

  /// 14sp base — secondary body text.
  static TextStyle bodySmall(BuildContext context, {FontWeight? weight}) {
    final flow = FlowScope.of(context);
    return TextStyle(
      fontSize: flow.text(14),
      fontWeight: weight ?? FontWeight.w400,
      height: 1.5,
    );
  }

  /// 12sp base — labels, captions, helper text.
  static TextStyle label(BuildContext context, {FontWeight? weight}) {
    final flow = FlowScope.of(context);
    return TextStyle(
      fontSize: flow.text(12),
      fontWeight: weight ?? FontWeight.w500,
      height: 1.4,
    );
  }

  /// 10sp base — micro labels, badges.
  static TextStyle micro(BuildContext context, {FontWeight? weight}) {
    final flow = FlowScope.of(context);
    return TextStyle(
      fontSize: flow.text(10),
      fontWeight: weight ?? FontWeight.w400,
      height: 1.4,
    );
  }
}
