import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool isHighlighted;
  final Color? highlightColor;

  const GlassCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 16.0,
    this.isHighlighted = false,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isHighlighted
                  ? (highlightColor ?? Colors.red.withOpacity(0.15))
                  : (isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: isHighlighted
                    ? (highlightColor?.withOpacity(0.3) ?? Colors.red.withOpacity(0.3))
                    : (isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.5)),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: isHighlighted
                      ? (highlightColor?.withOpacity(0.2) ?? Colors.red.withOpacity(0.2))
                      : Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                  blurRadius: 10,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}