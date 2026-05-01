import 'package:flutter/widgets.dart';
import 'flow_config.dart';

/// An [InheritedWidget] that propagates [FlowConfig] down the widget tree.
///
/// Wrap your app with [LayoutFlow] — it handles [FlowScope] automatically.
/// You can access the config anywhere via [FlowScope.of(context)].
class FlowScope extends InheritedWidget {
  /// The active [FlowConfig] for the current screen.
  final FlowConfig config;

  const FlowScope({
    super.key,
    required this.config,
    required super.child,
  });

  /// Returns the nearest [FlowConfig] from the widget tree.
  ///
  /// Throws if no [LayoutFlow] ancestor is found. Make sure your app
  /// is wrapped with [LayoutFlow].
  static FlowConfig of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<FlowScope>();
    assert(
      scope != null,
      'No FlowScope found in widget tree.\n'
      'Wrap your app with LayoutFlow:\n\n'
      '  LayoutFlow(\n'
      '    designSize: const Size(375, 812),\n'
      '    child: MyApp(),\n'
      '  )',
    );
    return scope!.config;
  }

  /// Returns the nearest [FlowConfig] or null if not found.
  static FlowConfig? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FlowScope>()
        ?.config;
  }

  @override
  bool updateShouldNotify(FlowScope oldWidget) =>
      config.screen != oldWidget.config.screen ||
      config.design != oldWidget.config.design;
}

/// Helper extensions on [BuildContext] to access [FlowConfig] with less boilerplate.
extension FlowContextX on BuildContext {
  /// Access the current [FlowConfig] directly.
  ///
  /// Equivalent to [FlowScope.of(context)].
  FlowConfig get flow => FlowScope.of(this);

  /// Access the current [FlowBreakpoint] directly.
  FlowBreakpoint get flowBreakpoint => flow.breakpoint;

  /// Returns true if the current screen is [FlowBreakpoint.compact].
  bool get isCompact => flow.breakpoint == FlowBreakpoint.compact;

  /// Returns true if the current screen is [FlowBreakpoint.medium].
  bool get isMedium => flow.breakpoint == FlowBreakpoint.medium;

  /// Returns true if the current screen is [FlowBreakpoint.expanded].
  bool get isExpanded => flow.breakpoint == FlowBreakpoint.expanded;
}
