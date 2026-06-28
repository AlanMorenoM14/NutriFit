import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme.dart';

/// Animated checkbox with bounce effect for the meal tracker.
class AnimatedCheckbox extends StatelessWidget {
  final bool checked;
  final ValueChanged<bool>? onChanged;
  final double size;
  final Color? activeColor;

  const AnimatedCheckbox({
    super.key,
    required this.checked,
    this.onChanged,
    this.size = 28,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? NutrifitTheme.primary;

    return GestureDetector(
      onTap: () => onChanged?.call(!checked),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: checked ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(size * 0.3),
          border: Border.all(
            color: checked
                ? color
                : Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: checked
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: checked
            ? Icon(
                Icons.check_rounded,
                size: size * 0.65,
                color: NutrifitTheme.background,
              )
                .animate()
                .scale(
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(1.0, 1.0),
                  duration: 300.ms,
                  curve: Curves.elasticOut,
                )
            : null,
      ),
    );
  }
}
