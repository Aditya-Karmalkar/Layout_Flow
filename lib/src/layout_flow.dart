import 'package:flutter/widgets.dart';
import 'flow_config.dart';
import 'flow_scope.dart';

/// The root widget for layout_flow. Wrap your [MaterialApp] or
/// [CupertinoApp] with this widget to activate the adaptive layout system.
///
/// ```dart
/// void main() {
///   runApp(
///     LayoutFlow(
///       designSize: const Size(375, 812),
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
///
/// The [designSize] should match the screen size of your design reference
/// (e.g. your Figma frame). Common values:
/// - iPhone 14 Pro: Size(393, 852)
/// - iPhone SE / compact: Size(375, 812)
/// - Pixel 7: Size(412, 915)
class LayoutFlow extends StatelessWidget {
  /// The child widget — typically your [MaterialApp] or [CupertinoApp].
  final Widget child;

  /// The screen dimensions of your design reference frame.
  ///
  /// Defaults to Size(375, 812) if not specified.
  final Size designSize;

  const LayoutFlow({
    super.key,
    required this.child,
    this.designSize = const Size(375, 812),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screen = constraints.biggest;
        // Fallback to MediaQuery if constraints are unconstrained
        final effectiveScreen = (screen.isInfinite || screen.isEmpty)
            ? MediaQuery.sizeOf(context)
            : screen;

        final config = FlowConfig(effectiveScreen, designSize);

        return FlowScope(
          config: config,
          child: child,
        );
      },
    );
  }
}
