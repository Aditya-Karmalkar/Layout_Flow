import 'package:flutter/widgets.dart';

/// The core scaling engine for layout_flow.
///
/// Computes scale factors by comparing the actual screen size
/// against the design reference size provided in [LayoutFlow].
class FlowConfig {
  /// The actual screen (or parent constraint) size.
  final Size screen;

  /// The design reference size (e.g. Size(375, 812) for iPhone 14).
  final Size design;

  /// The device's safe area padding.
  final EdgeInsets padding;

  /// The horizontal scale factor: screen.width / design.width.
  late final double scaleW;

  /// The vertical scale factor: screen.height / design.height.
  late final double scaleH;

  /// A clamped scale factor used for text, preventing text from
  /// becoming too small on compact screens or too large on wide ones.
  late final double scaleText;

  /// The current device breakpoint inferred from screen width.
  late final FlowBreakpoint breakpoint;

  FlowConfig(this.screen, this.design, {this.padding = EdgeInsets.zero}) {
    scaleW = screen.width / design.width;
    scaleH = screen.height / design.height;
    scaleText = scaleW.clamp(0.85, 1.25);
    breakpoint = _resolveBreakpoint(screen.width);
  }

  /// Scales a horizontal/width-based value.
  double w(double value) => value * scaleW;

  /// Scales a vertical/height-based value.
  double h(double value) => value * scaleH;

  /// Scales a font size value with safe clamping.
  double text(double value) => value * scaleText;

  /// Scales a value using the smaller of [scaleW] and [scaleH],
  /// useful for symmetric elements like icons or border radii.
  double sp(double value) {
    final scale = scaleW < scaleH ? scaleW : scaleH;
    return value * scale.clamp(0.85, 1.3);
  }

  static FlowBreakpoint _resolveBreakpoint(double width) {
    if (width < 480) return FlowBreakpoint.compact;
    if (width < 840) return FlowBreakpoint.medium;
    return FlowBreakpoint.expanded;
  }

  /// Returns true if the screen is compact (phone portrait).
  bool get isCompact => breakpoint == FlowBreakpoint.compact;

  /// Returns true if the screen is medium (phone landscape / small tablet).
  bool get isMedium => breakpoint == FlowBreakpoint.medium;

  /// Returns true if the screen is expanded (tablet / desktop).
  bool get isExpanded => breakpoint == FlowBreakpoint.expanded;

  @override
  String toString() =>
      'FlowConfig(screen: $screen, design: $design, '
      'scaleW: ${scaleW.toStringAsFixed(2)}, '
      'breakpoint: ${breakpoint.name})';
}

/// Breakpoint tiers aligned with Material Design 3 guidelines.
enum FlowBreakpoint {
  /// < 480dp — compact phones in portrait
  compact,

  /// 480–840dp — large phones / small tablets
  medium,

  /// > 840dp — tablets, desktops, web
  expanded,
}
