import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/transaction.dart';
import 'package:timeago/timeago.dart' as timeago;

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getTypeColor(transaction.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: Icon(
            _getTypeIcon(transaction.type),
            color: _getTypeColor(transaction.type),
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          timeago.format(transaction.createdAt),
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: Text(
          '${transaction.points > 0 ? '+' : ''}${transaction.points} pts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: transaction.points > 0 ? AppTheme.success : AppTheme.error,
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'task_completion':
        return Icons.task;
      case 'code_redemption':
        return Icons.qr_code;
      case 'bonus':
        return Icons.card_giftcard;
      case 'redemption':
        return Icons.redeem;
      case 'adjustment':
        return Icons.edit;
      default:
        return Icons.info;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'task_completion':
        return AppTheme.success;
      case 'code_redemption':
        return AppTheme.primaryBlue;
      case 'bonus':
        return AppTheme.secondaryBlue;
      case 'redemption':
        return AppTheme.error;
      case 'adjustment':
        return AppTheme.warning;
      default:
        return AppTheme.textPrimary;
    }
  }
}