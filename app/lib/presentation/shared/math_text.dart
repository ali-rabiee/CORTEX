import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../core/theme/app_colors.dart';

/// Renders text with inline LaTeX math ($...$) and display math ($$...$$).
///
/// Convention:
/// - `$expression$` renders inline math
/// - `$$expression$$` renders centered display math on its own line
/// - Everything else renders as normal text
class MathText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const MathText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = style ??
        const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          height: 1.6,
        );

    final segments = _parse(text);

    // If there are any display math blocks, we need a Column layout
    final hasDisplayMath = segments.any((s) => s.type == _SegmentType.displayMath);

    if (!hasDisplayMath) {
      // All inline — use a single Wrap/RichText
      return _buildInlineOnly(segments, defaultStyle);
    }

    // Mix of inline and display — use Column
    return _buildMixed(segments, defaultStyle);
  }

  Widget _buildInlineOnly(List<_Segment> segments, TextStyle style) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: segments.map((seg) {
        if (seg.type == _SegmentType.text) {
          return Text(seg.content, style: style);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Math.tex(
            seg.content,
            textStyle: style.copyWith(
              color: AppColors.primaryLight,
            ),
            mathStyle: MathStyle.text,
            onErrorFallback: (err) => Text(
              '\$${seg.content}\$',
              style: style.copyWith(
                color: AppColors.primaryLight,
                fontFamily: 'monospace',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMixed(List<_Segment> segments, TextStyle style) {
    final children = <Widget>[];
    var inlineBuffer = <_Segment>[];

    void flushInline() {
      if (inlineBuffer.isNotEmpty) {
        children.add(_buildInlineOnly(inlineBuffer, style));
        inlineBuffer = [];
      }
    }

    for (final seg in segments) {
      if (seg.type == _SegmentType.displayMath) {
        flushInline();
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Math.tex(
                  seg.content,
                  textStyle: style.copyWith(
                    color: AppColors.primaryLight,
                    fontSize: (style.fontSize ?? 14) + 2,
                  ),
                  mathStyle: MathStyle.display,
                  onErrorFallback: (err) => Text(
                    seg.content,
                    style: style.copyWith(
                      color: AppColors.primaryLight,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        inlineBuffer.add(seg);
      }
    }
    flushInline();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  /// Parses text into segments of plain text, inline math, and display math.
  static List<_Segment> _parse(String input) {
    final segments = <_Segment>[];
    var remaining = input;

    while (remaining.isNotEmpty) {
      // Try display math first ($$...$$)
      final displayStart = remaining.indexOf(r'$$');
      final inlineStart = remaining.indexOf(r'$');

      if (displayStart != -1 &&
          (inlineStart == -1 || displayStart <= inlineStart)) {
        // Found display math marker
        if (displayStart > 0) {
          segments.add(_Segment(_SegmentType.text, remaining.substring(0, displayStart)));
        }
        final displayEnd = remaining.indexOf(r'$$', displayStart + 2);
        if (displayEnd == -1) {
          // Unclosed — treat as text
          segments.add(_Segment(_SegmentType.text, remaining.substring(displayStart)));
          break;
        }
        final math = remaining.substring(displayStart + 2, displayEnd).trim();
        segments.add(_Segment(_SegmentType.displayMath, math));
        remaining = remaining.substring(displayEnd + 2);
      } else if (inlineStart != -1) {
        // Found inline math marker
        if (inlineStart > 0) {
          segments.add(_Segment(_SegmentType.text, remaining.substring(0, inlineStart)));
        }
        final inlineEnd = remaining.indexOf(r'$', inlineStart + 1);
        if (inlineEnd == -1) {
          // Unclosed — treat as text
          segments.add(_Segment(_SegmentType.text, remaining.substring(inlineStart)));
          break;
        }
        final math = remaining.substring(inlineStart + 1, inlineEnd).trim();
        segments.add(_Segment(_SegmentType.inlineMath, math));
        remaining = remaining.substring(inlineEnd + 1);
      } else {
        // No more math — rest is plain text
        segments.add(_Segment(_SegmentType.text, remaining));
        break;
      }
    }

    return segments;
  }
}

enum _SegmentType { text, inlineMath, displayMath }

class _Segment {
  final _SegmentType type;
  final String content;
  const _Segment(this.type, this.content);
}
