import 'dart:ui';
import 'package:flutter/material.dart';

/// A [ThemeExtension] that allows customizing the behavior of layout_flow
/// tokens globally via your [ThemeData].
///
/// This enables design system teams to override the default 8dp spacing grid
/// or change scaling behaviors without modifying the package.
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       FlowTheme(
///         spacingBase: 10.0, // Changes the base unit for all FlowSpacing tokens
///       ),
///     ],
///   ),
/// )
/// ```
class FlowTheme extends ThemeExtension<FlowTheme> {
  /// The base multiplier for spacing tokens. Defaults to 8.0.
  final double spacingBase;

  const FlowTheme({
    this.spacingBase = 8.0,
  });

  @override
  FlowTheme copyWith({double? spacingBase}) {
    return FlowTheme(
      spacingBase: spacingBase ?? this.spacingBase,
    );
  }

  @override
  FlowTheme lerp(
    covariant ThemeExtension<FlowTheme>? other,
    double t,
  ) {
    if (other is! FlowTheme) return this;
    return FlowTheme(
      spacingBase: lerpDouble(spacingBase, other.spacingBase, t) ?? spacingBase,
    );
  }

  /// Helper to get the active [FlowTheme] from context.
  ///
  /// Returns a default [FlowTheme] with 8.0 spacing base if none is found
  /// in the current [Theme].
  static FlowTheme of(BuildContext context) {
    return Theme.of(context).extension<FlowTheme>() ?? const FlowTheme();
  }
}
