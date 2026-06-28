import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';

/// A card widget with glassmorphism effect (frosted glass look).
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? borderColor;
  final double blur;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = NutrifitTheme.radiusLg,
    this.onTap,
    this.borderColor,
    this.blur = NutrifitTheme.glassBlur,
  });

  @override
  Widget build(BuildContext context) {
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: NutrifitTheme.glassOpacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ??
                  Colors.white.withValues(
                    alpha: NutrifitTheme.glassBorderOpacity,
                  ),
            ),
          ),
          padding: padding ??
              const EdgeInsets.all(NutrifitTheme.spacingMd),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
