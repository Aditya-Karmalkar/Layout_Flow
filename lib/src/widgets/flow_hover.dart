import 'package:flutter/material.dart';

/// A convenience widget for adding hover states and custom cursors,
/// optimized for desktop and web platforms.
class FlowHover extends StatefulWidget {
  /// The widget to apply hover effects to.
  final Widget child;

  /// The builder function that provides the hover state.
  final Widget Function(BuildContext context, bool isHovered, Widget? child)? builder;

  /// The color to overlay or use as background when hovered.
  final Color? hoverColor;

  /// The cursor to display when hovering. Defaults to [SystemMouseCursors.click].
  final MouseCursor cursor;

  /// Called when the hover state changes.
  final ValueChanged<bool>? onHoverChanged;

  /// Duration for the hover transition.
  final Duration duration;

  const FlowHover({
    super.key,
    required this.child,
    this.builder,
    this.hoverColor,
    this.cursor = SystemMouseCursors.click,
    this.onHoverChanged,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<FlowHover> createState() => _FlowHoverState();
}

class _FlowHoverState extends State<FlowHover> {
  bool _isHovered = false;

  void _handleHover(bool hovering) {
    if (_isHovered != hovering) {
      setState(() {
        _isHovered = hovering;
      });
      widget.onHoverChanged?.call(hovering);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return MouseRegion(
        cursor: widget.cursor,
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: widget.builder!(context, _isHovered, widget.child),
      );
    }

    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedContainer(
        duration: widget.duration,
        decoration: BoxDecoration(
          color: _isHovered ? (widget.hoverColor ?? Colors.black12) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: widget.child,
      ),
    );
  }
}
