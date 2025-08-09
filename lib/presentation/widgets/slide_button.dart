import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Botón deslizante sencillo y reutilizable
class SlideButton extends StatefulWidget {
  const SlideButton({
    super.key,
    required this.text,
    required this.onSlideCompleted,
    this.height = 64,
    this.hapticFeedback = true,
  });

  final String text;
  final VoidCallback onSlideCompleted;
  final double height;
  final bool hapticFeedback;

  @override
  State<SlideButton> createState() => _SlideButtonState();
}

class _SlideButtonState extends State<SlideButton> {
  double _dragPx = 0;
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final radius = BorderRadius.circular(widget.height / 2);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double thumbSize = widget.height;
        final double maxDx = (width - thumbSize).clamp(0.0, double.infinity);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) {
            if (_completed) return;
            setState(() {
              _dragPx = (_dragPx + details.delta.dx).clamp(0.0, maxDx);
            });
          },
          onHorizontalDragEnd: (_) {
            if (_completed) return;
            if (_dragPx >= maxDx * 0.85) {
              _completed = true;
              if (widget.hapticFeedback) HapticFeedback.mediumImpact();
              widget.onSlideCompleted();
            } else {
              setState(() => _dragPx = 0);
            }
          },
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: radius,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Track
                Positioned.fill(
                  child: Container(color: colors.primaryContainer),
                ),
                // Thumb
                Positioned(
                  left: _dragPx,
                  child: Container(
                    height: widget.height,
                    width: widget.height,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_forward, color: colors.onPrimary),
                  ),
                ),
                // Text centered
                Positioned.fill(
                  child: Center(
                    child: Text(
                      widget.text,
                      style: theme.textTheme.titleMedium?.copyWith(color: colors.onPrimary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


