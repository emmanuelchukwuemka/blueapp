import 'package:flutter/material.dart';
import '../config/theme.dart';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final VoidCallback? onTap;
  final bool hasBadge;
  final Color? badgeColor;
  final IconData? badgeIcon;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 20,
    this.onTap,
    this.hasBadge = false,
    this.badgeColor,
    this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.divider,
                width: 1,
              ),
            ),
            child: CircleAvatar(
              radius: radius,
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
              backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
              child: imageUrl == null
                  ? Text(
                      name != null && name!.isNotEmpty
                          ? name!.substring(0, 1).toUpperCase()
                          : '',
                      style: TextStyle(
                        fontSize: radius,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    )
                  : null,
            ),
          ),
          if (hasBadge)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: radius * 0.8,
                height: radius * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badgeColor ?? AppTheme.success,
                  border: Border.all(
                    color: AppTheme.cardBackground,
                    width: 2,
                  ),
                ),
                child: Icon(
                  badgeIcon ?? Icons.check,
                  size: radius * 0.5,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}