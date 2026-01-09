import 'package:flutter/material.dart';

class OutlinedRichText extends StatelessWidget {
  final List<InlineSpan> spans;
  final double strokeWidth;
  final Color strokeColor;

  const OutlinedRichText({
    super.key,
    required this.spans,
    this.strokeWidth = 2,
    this.strokeColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Outline
        RichText(
          text: TextSpan(
            children: spans.map((span) {
              if (span is TextSpan) {
                return TextSpan(
                  text: span.text,
                  style: span.style?.copyWith(
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = strokeWidth
                      ..color = strokeColor,
                  ),
                );
              }
              return span;
            }).toList(),
          ),
        ),

        // Fill
        RichText(text: TextSpan(children: spans)),
      ],
    );
  }
}
