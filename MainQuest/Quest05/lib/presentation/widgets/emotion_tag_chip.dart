import 'package:flutter/material.dart';

class EmotionTagChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final Function()? onTap;
  final double fontSize;

  const EmotionTagChip({
    Key? key,
    required this.label,
    required this.color,
    this.isSelected = false,
    this.onTap,
    this.fontSize = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withOpacity(0.2) 
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? color 
                : theme.colorScheme.outlineVariant.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: isSelected 
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ] 
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: isSelected 
                ? color.withOpacity(0.9) 
                : theme.colorScheme.onSurface.withOpacity(0.75),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
} 