import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onStartTask;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onStartTask,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Icon(
                      _getIconForTaskType(task.type),
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingS,
                      vertical: AppTheme.spacingXS,
                    ),
                    decoration: BoxDecoration(
                      color: _getPointsColor(task.points).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Text(
                      '+${task.points} pts',
                      style: TextStyle(
                        color: _getPointsColor(task.points),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              Text(
                task.description,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getDifficultyText(task.difficulty),
                    style: const TextStyle(
                      color: AppTheme.textTertiary,
                    ),
                  ),
                  if (task.status == 'available')
                    ElevatedButton(
                      onPressed: onStartTask,
                      child: const Text('Start'),
                    )
                  else if (task.status == 'completed')
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else if (task.status == 'pending')
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: const Text(
                        'Pending Review',
                        style: TextStyle(
                          color: AppTheme.warning,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForTaskType(String type) {
    switch (type) {
      case 'survey':
        return Icons.questionnaire;
      case 'video':
        return Icons.play_circle;
      case 'referral':
        return Icons.group;
      case 'purchase':
        return Icons.shopping_cart;
      case 'social':
        return Icons.share;
      default:
        return Icons.task;
    }
  }

  String _getDifficultyText(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return 'Easy';
      case 'medium':
        return 'Medium';
      case 'hard':
        return 'Hard';
      default:
        return difficulty;
    }
  }

  Color _getPointsColor(int points) {
    if (points >= 500) {
      return AppTheme.success;
    } else if (points >= 100) {
      return AppTheme.primaryBlue;
    } else {
      return AppTheme.textSecondary;
    }
  }
}