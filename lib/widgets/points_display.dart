import 'package:flutter/material.dart';
import '../config/theme.dart';

class PointsDisplay extends StatelessWidget {
  final int points;
  final String label;
  final bool isLarge;
  final VoidCallback? onTap;

  const PointsDisplay({
    super.key,
    required this.points,
    this.label = 'Points',
    this.isLarge = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isLarge ? AppTheme.spacingL : AppTheme.spacingM),
        decoration: BoxDecoration(
          gradient: isLarge ? AppTheme.cardGradient : null,
          color: isLarge ? null : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          boxShadow: isLarge ? AppTheme.shadowMD : AppTheme.shadowSM,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isLarge ? 16 : 14,
                color: isLarge ? Colors.white70 : AppTheme.textSecondary,
                fontWeight: isLarge ? FontWeight.normal : FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              points.toString(),
              style: TextStyle(
                fontSize: isLarge ? 32 : 24,
                fontWeight: FontWeight.bold,
                color: isLarge ? Colors.white : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}