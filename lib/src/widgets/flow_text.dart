import 'package:flutter/widgets.dart';
import '../flow_scope.dart';

/// An adaptive text widget that automatically scales font size
/// based on the current screen size — no manual [fontSize] required.
///
/// ```dart
/// FlowText('Hello World')
/// FlowText('Subtitle', style: TextStyle(fontSize: 14, color: Colors.grey))
/// ```
///
/// Font size defaults to 16sp and is scaled within safe bounds.
/// You can provide a base [style] and [fontSize] will be scaled automatically.
class FlowText extends StatelessWidget {
  /// The text content to display.
  final String data;

  /// Optional base style. If [style.fontSize] is set, it will be
  /// used as the base and scaled automatically.
  final TextStyle? style;

  /// Text alignment.
  final TextAlign? textAlign;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// Maximum number of lines before overflow is applied.
  final int? maxLines;

  const FlowText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final flow = FlowScope.of(context);
    final baseFontSize = style?.fontSize ?? 16.0;
    final scaledFontSize = flow.text(baseFontSize);

    final resolvedStyle = (style ?? const TextStyle()).copyWith(
      fontSize: scaledFontSize,
    );

    return Text(
      data,
      style: resolvedStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
