import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUser();
      Provider.of<PointsProvider>(context, listen: false).fetchPointsBalance();
      Provider.of<PointsProvider>(context, listen: false).fetchTransactions();
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {
                  // Navigate to notifications
                },
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<PointsProvider>(context, listen: false).fetchPointsBalance();
          await Provider.of<PointsProvider>(context, listen: false).fetchTransactions();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    final user = userProvider.user;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Good morning,',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        Text(
                          user?.name ?? 'Loading...',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppTheme.spacingL),
                
                // Points card
                Consumer<PointsProvider>(
                  builder: (context, pointsProvider, child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.cardGradient,
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        boxShadow: AppTheme.shadowMD,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Points',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            Text(
                              '${pointsProvider.totalPoints}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingM),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Switch to Redeem tab (index 2)
                                      // This assumes MainNavigation is handling the index. 
                                      // Ideally we use a provider for navigation state or callback.
                                      // For now, let's just use a provider or skip if complex.
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppTheme.primaryBlue,
                                    ),
                                    child: const Text('Redeem Points'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppTheme.spacingL),
                
                // Quick actions
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                Row(
                  children: [
                    _buildActionCard(
                      context,
                      icon: Icons.task,
                      title: 'View Tasks',
                      onTap: () {
                        // Navigate to Tasks
                      },
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    _buildActionCard(
                      context,
                      icon: Icons.qr_code,
                      title: 'Redeem Code',
                      onTap: () {
                        // Navigate to Redeem
                      },
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    _buildActionCard(
                      context,
                      icon: Icons.history,
                      title: 'History',
                      onTap: () {
                        // Navigate to History
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingL),
                
                // Recent activity
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                ),
                Consumer<PointsProvider>(
                  builder: (context, pointsProvider, child) {
                    final recentTransactions = pointsProvider.getRecentTransactions(5);
                    
                    if (pointsProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (recentTransactions.isEmpty) {
                      return const Center(child: Text('No recent activity'));
                    }

                    return Column(
                      children: recentTransactions.map((tx) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
                          decoration: BoxDecoration(
                            color: AppTheme.cardBackground,
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                            boxShadow: AppTheme.shadowSM,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: tx.isGain ? AppTheme.success : AppTheme.error,
                              child: Icon(
                                tx.isGain ? Icons.add : Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(tx.description),
                            subtitle: Text(tx.displayType),
                            trailing: Text(
                              tx.displayPoints,
                              style: TextStyle(
                                color: tx.isGain ? AppTheme.success : AppTheme.error,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spacingM,
              horizontal: AppTheme.spacingS,
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: AppTheme.primaryBlue,
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}