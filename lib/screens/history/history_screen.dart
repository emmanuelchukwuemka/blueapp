import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/points_provider.dart';
import '../../models/transaction.dart';
import '../../widgets/common/loading_overlay.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PointsProvider>(context, listen: false).fetchTransactions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Gained'),
            Tab(text: 'Redeemed'),
          ],
        ),
      ),
      body: Consumer<PointsProvider>(
        builder: (context, pointsProvider, child) {
          return LoadingOverlay(
            isLoading: pointsProvider.isLoading,
            child: Column(
              children: [
                // Total Points Summary
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  color: AppTheme.primaryBlue.withOpacity(0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${pointsProvider.totalPoints} pts',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Gained Points Tab
                      _buildTransactionList(pointsProvider.gainedTransactions, true),
                      // Redeemed Points Tab
                      _buildTransactionList(pointsProvider.redeemedTransactions, false),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions, bool isGained) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isGained ? Icons.add_circle_outline : Icons.remove_circle_outline,
              size: 64,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              isGained ? 'No points earned yet' : 'No points redeemed yet',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusM)),
          child: InkWell(
            onTap: () => _showTransactionDetails(tx),
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (isGained ? AppTheme.success : AppTheme.error).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: Icon(
                  isGained ? Icons.add : Icons.remove,
                  color: isGained ? AppTheme.success : AppTheme.error,
                ),
              ),
              title: Text(tx.description),
              subtitle: Text(DateFormat('MMM d, yyyy • h:mm a').format(tx.createdAt)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    tx.displayPoints,
                    style: TextStyle(
                      color: isGained ? AppTheme.success : AppTheme.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (tx.status != null)
                    Text(
                      tx.status!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: _getStatusColor(tx.status!),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed': return AppTheme.success;
      case 'pending': return Colors.orange;
      case 'processing': return Colors.blue;
      case 'rejected': return AppTheme.error;
      default: return AppTheme.textSecondary;
    }
  }

  void _showTransactionDetails(Transaction tx) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusL)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            const Text(
              'Transaction Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            _buildDetailRow('Description', tx.description),
            _buildDetailRow('Type', tx.displayType),
            _buildDetailRow('Date', DateFormat('MMMM d, yyyy').format(tx.createdAt)),
            _buildDetailRow('Time', DateFormat('h:mm a').format(tx.createdAt)),
            _buildDetailRow('Points', tx.displayPoints, isBold: true, 
              color: tx.isGain ? AppTheme.success : AppTheme.error),
            if (tx.status != null)
              _buildDetailRow('Status', tx.status!.toUpperCase()),
            if (tx.referenceNumber != null)
              _buildDetailRow('Reference No.', tx.referenceNumber!),
            const SizedBox(height: AppTheme.spacingL),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color ?? AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}