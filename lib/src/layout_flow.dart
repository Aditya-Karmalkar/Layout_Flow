import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/widgets.dart';
import 'flow_config.dart';
import 'flow_scope.dart';

/// Determines how [LayoutFlow] calculates the current screen size for scaling.
enum FlowAdaptiveMode {
  /// Scales based on the global screen width (via [MediaQuery]).
  ///
  /// This is the standard behavior for most responsive apps.
  screen,

  /// Scales based on the immediate parent's constraints (via [LayoutBuilder]).
  ///
  /// Useful for widgets that should scale relative to their container rather
  /// than the whole screen (e.g. iframes, sidebars, or embedded views).
  constraints,
}

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
class LayoutFlow extends StatefulWidget {
  /// The child widget — typically your [MaterialApp] or [CupertinoApp].
  final Widget child;

  /// The screen dimensions of your design reference frame.
  ///
  /// Defaults to Size(375, 812) if not specified.
  final Size designSize;

  /// How dimensions are calculated for scaling.
  ///
  /// Defaults to [FlowAdaptiveMode.constraints].
  final FlowAdaptiveMode mode;

  const LayoutFlow({
    super.key,
    required this.child,
    this.designSize = const Size(375, 812),
    this.mode = FlowAdaptiveMode.constraints,
  });

  @override
  State<LayoutFlow> createState() => _LayoutFlowState();
}

class _LayoutFlowState extends State<LayoutFlow> {
  FlowConfig? _lastConfig;

  @override
  void initState() {
    super.initState();
    _registerServiceExtension();
  }

  void _registerServiceExtension() {
    // Only register in debug mode
    assert(() {
      developer.registerExtension('ext.layout_flow.getConfig', (method, parameters) async {
        if (_lastConfig == null) {
          return developer.ServiceExtensionResponse.error(
            developer.ServiceExtensionResponse.extensionError,
            'LayoutFlow has not been built yet.',
          );
        }
        
        final config = _lastConfig!;
        return developer.ServiceExtensionResponse.result(json.encode({
          'designSize': {'width': config.design.width, 'height': config.design.height},
          'screenSize': {'width': config.screen.width, 'height': config.screen.height},
          'scaleW': config.scaleW,
          'scaleH': config.scaleH,
          'scaleText': config.scaleText,
          'breakpoint': config.breakpoint.name,
        }));
      });
      return true;
    }());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == FlowAdaptiveMode.screen) {
      final media = MediaQuery.of(context);
      _lastConfig = FlowConfig(media.size, widget.designSize, padding: media.padding);
      return FlowScope(config: _lastConfig!, child: widget.child);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final media = MediaQuery.of(context);
        final screen = constraints.biggest;
        // Fallback to MediaQuery if constraints are unconstrained
        final effectiveScreen = (screen.isInfinite || screen.isEmpty)
            ? media.size
            : screen;

        _lastConfig = FlowConfig(effectiveScreen, widget.designSize, padding: media.padding);

        return FlowScope(
          config: _lastConfig!,
          child: widget.child,
        );
      },
    );
  }
}
