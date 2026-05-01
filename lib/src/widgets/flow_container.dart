import 'package:flutter/widgets.dart';
import '../flow_scope.dart';
import '../tokens/flow_spacing.dart';

/// An adaptive container that applies token-based padding and
/// optional decoration — without requiring explicit width or height.
///
/// ```dart
/// FlowContainer(
///   child: Column(
///     children: [
///       FlowText('Welcome'),
///       FlowText('Sign in to continue'),
///     ],
///   ),
/// )
/// ```
///
/// Padding and decoration scale automatically with the screen size.
class FlowContainer extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// Custom padding. Defaults to [FlowSpacing.md] on all sides.
  final EdgeInsetsGeometry? padding;

  /// Optional margin around the container.
  final EdgeInsetsGeometry? margin;

  /// Optional decoration (background, border, shadow, etc).
  final BoxDecoration? decoration;

  /// Optional explicit width. Prefer leaving this null to let
  /// the container size itself based on content and constraints.
  final double? width;

  /// Optional explicit height.
  final double? height;

  /// Alignment of the child within the container.
  final AlignmentGeometry? alignment;

  const FlowContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.decoration,
    this.width,
    this.height,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final flow = FlowScope.of(context);
    final effectivePadding =
        padding ?? EdgeInsets.all(FlowSpacing.md(context));

    return Container(
      width: width != null ? flow.w(width!) : null,
      height: height != null ? flow.h(height!) : null,
      padding: effectivePadding,
      margin: margin,
      decoration: decoration,
      alignment: alignment,
      child: child,
    );
  }
}
