import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../flow_scope.dart';

/// A debug overlay that displays the current layout_flow state.
///
/// Use this in debug mode to see current screen dimensions, active
/// breakpoints, and scale factors.
///
/// The overlay is draggable and can be repositioned anywhere on the screen.
///
/// ```dart
/// FlowDebugOverlay(
///   enabled: kDebugMode,
///   child: MyApp(),
/// )
/// ```
class FlowDebugOverlay extends StatefulWidget {
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
  State<FlowDebugOverlay> createState() => _FlowDebugOverlayState();
}

class _FlowDebugOverlayState extends State<FlowDebugOverlay> {
  Offset _offset = const Offset(-1, -1);
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Initialize or validate position
          if (_offset.dx == -1) {
            _offset = Offset(
              constraints.maxWidth - 200,
              constraints.maxHeight - 180,
            );
          } else {
            // Ensure it stays within new boundaries after resize
            _offset = Offset(
              _offset.dx.clamp(0, constraints.maxWidth - (_isExpanded ? 180 : 50)),
              _offset.dy.clamp(0, constraints.maxHeight - 50),
            );
          }

          return Stack(
            children: [
              widget.child,
              Positioned(
                left: _offset.dx,
                top: _offset.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _offset += details.delta;
                      // Keep within bounds
                      _offset = Offset(
                        _offset.dx.clamp(0, constraints.maxWidth - 40),
                        _offset.dy.clamp(0, constraints.maxHeight - 40),
                      );
                    });
                  },
                  child: Material(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                    elevation: 8,
                    child: Container(
                      width: _isExpanded ? 180 : 50,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.drag_indicator,
                                  size: 14, color: Colors.white38),
                              if (_isExpanded)
                                const Text(
                                  'FLOW DEBUG',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _isExpanded = !_isExpanded),
                                child: Icon(
                                  _isExpanded
                                      ? Icons.keyboard_arrow_down
                                      : Icons.bug_report,
                                  size: 16,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ],
                          ),
                          if (_isExpanded) ...[
                            const SizedBox(height: 8),
                            const _DebugContent(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DebugContent extends StatelessWidget {
  const _DebugContent();

  @override
  Widget build(BuildContext context) {
    final flow = context.flow;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DebugRow('Screen',
            '${flow.screen.width.toInt()}x${flow.screen.height.toInt()}'),
        _DebugRow('BP', context.flowBreakpoint.name.toUpperCase()),
        const Divider(color: Colors.white24, height: 12),
        _DebugRow('Scale W', flow.scaleW.toStringAsFixed(2)),
        _DebugRow('Scale H', flow.scaleH.toStringAsFixed(2)),
        _DebugRow('Scale T', flow.scaleText.toStringAsFixed(2)),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
