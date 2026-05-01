import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../flow_scope.dart';

/// A debug overlay that displays the current layout_flow state.
///
/// Use this in debug mode to see current screen dimensions, active
/// breakpoints, and scale factors.
///
/// ```dart
/// FlowDebugOverlay(
///   enabled: kDebugMode,
///   child: MyApp(),
/// )
/// ```
class FlowDebugOverlay extends StatelessWidget {
  /// The widget below this overlay in the tree.
  final Widget child;

  /// Whether the overlay is visible. Usually set to [kDebugMode].
  final bool enabled;

  const FlowDebugOverlay({
    super.key,
    required this.child,
    this.enabled = kDebugMode,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Stack(
      children: [
        child,
        Positioned(
          bottom: 16,
          right: 16,
          child: IgnorePointer(
            child: Material(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _DebugContent(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DebugContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access flow info via context extension
    final flow = context.flow;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DebugRow('Screen', '${flow.screen.width.toInt()} x ${flow.screen.height.toInt()}'),
        _DebugRow('Breakpoint', context.flowBreakpoint.name.toUpperCase()),
        const Divider(color: Colors.white24, height: 12),
        _DebugRow('Scale W', flow.scaleW.toStringAsFixed(2)),
        _DebugRow('Scale H', flow.scaleH.toStringAsFixed(2)),
        _DebugRow('Scale Text', flow.scaleText.toStringAsFixed(2)),
      ],
    );
  }
}

class _DebugRow extends StatelessWidget {
  final String label;
  final String value;

  const _DebugRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
