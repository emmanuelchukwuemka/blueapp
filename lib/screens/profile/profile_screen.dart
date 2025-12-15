import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../providers/user_provider.dart';
import '../../providers/points_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/loading_overlay.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Consumer2<UserProvider, PointsProvider>(
        builder: (context, userProvider, pointsProvider, child) {
          final user = userProvider.user;
          final totalPoints = pointsProvider.totalPoints;
          final totalRedeemed = pointsProvider.redeemedTransactions.fold<int>(
            0, (sum, tx) => sum + tx.points.abs());

          return LoadingOverlay(
            isLoading: userProvider.isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                children: [
                  // Profile header
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground,
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      boxShadow: AppTheme.shadowSM,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: AppTheme.primaryBlue,
                                backgroundImage: user?.profilePicture != null
                                    ? NetworkImage(user!.profilePicture!)
                                    : null,
                                child: user?.profilePicture == null
                                    ? const Icon(Icons.person, color: Colors.white, size: 40)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.edit, color: Colors.white, size: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          Text(
                            user?.name ?? 'Guest User',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildAccountTypeBadge(user?.accountType ?? 'User'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Stats cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '$totalPoints',
                          'Points Balance',
                          AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: _buildStatCard(
                          '$totalRedeemed',
                          'Total Redeemed',
                          AppTheme.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  
                   // Bank Details Warning Card
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(color: Colors.amber.withOpacity(0.5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, color: Colors.amber),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bank Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                AppConstants.bankDetailsMessage,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Menu items
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.account_circle, color: AppTheme.primaryBlue),
                          title: const Text('Account Information'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // View account info
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.notifications, color: AppTheme.primaryBlue),
                          title: const Text('Notifications'),
                          trailing: const Switch(value: true, onChanged: (val) {}), 
                        ),
                         const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.privacy_tip, color: AppTheme.primaryBlue),
                          title: const Text('Privacy Policy'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Open Privacy Policy
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.description, color: AppTheme.primaryBlue),
                          title: const Text('Terms & Conditions'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Open Terms
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.help, color: AppTheme.primaryBlue),
                          title: const Text('Help & Support'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Navigate to help
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.logout, color: AppTheme.error),
                          title: const Text('Logout', style: TextStyle(color: AppTheme.error)),
                          onTap: () => _confirmLogout(context),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  TextButton(
                    onPressed: () {
                      // Delete account flow
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Account'),
                          content: const Text('Are you sure? This action cannot be undone and you will lose all your points.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                            TextButton(
                              onPressed: () { 
                                // Call delete API 
                                Navigator.pop(context);
                              },
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Delete Account', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: AppTheme.shadowSM,
        border: Border(top: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTypeBadge(String type) {
    Color color;
    switch (type.toLowerCase()) {
      case 'partner':
        color = Colors.purple;
        break;
      case 'admin':
        color = Colors.red;
        break;
      default:
        color = AppTheme.primaryBlue;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                final pointsProvider = Provider.of<PointsProvider>(context, listen: false);
                
                authProvider.logout();
                userProvider.clearUser();
                // Navigate to Login (Main uses auth state changes to redirect usually)
                // But if purely manual:
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}