import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/notification.dart';
import '../../providers/auth_provider.dart';
import '../../services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notificationService = NotificationService();
      final notifications = await notificationService.getNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load notifications';
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      final notificationService = NotificationService();
      await notificationService.markAsRead(notificationId);
      
      setState(() {
        _notifications = _notifications.map((notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList();
      });
    } catch (e) {
      // Handle error silently or show snackbar
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      final notificationService = NotificationService();
      await notificationService.markAllAsRead();
      
      setState(() {
        _notifications = _notifications.map((notification) {
          return notification.copyWith(isRead: true);
        }).toList();
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications marked as read')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to mark notifications as read')),
        );
      }
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    try {
      final notificationService = NotificationService();
      await notificationService.deleteNotification(notificationId);
      
      setState(() {
        _notifications.removeWhere((notification) => notification.id == notificationId);
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete notification')),
        );
      }
    }
  }

  IconData _getIconForNotificationType(String type) {
    switch (type) {
      case 'task_approved':
        return Icons.check_circle;
      case 'task_rejected':
        return Icons.cancel;
      case 'points_credited':
        return Icons.add_circle;
      case 'redemption_update':
        return Icons.info;
      case 'system_announcement':
        return Icons.campaign;
      case 'promotion':
        return Icons.local_offer;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForNotificationType(String type) {
    switch (type) {
      case 'task_approved':
        return AppTheme.success;
      case 'task_rejected':
        return AppTheme.error;
      case 'points_credited':
        return AppTheme.success;
      case 'redemption_update':
        return AppTheme.info;
      case 'system_announcement':
        return AppTheme.warning;
      case 'promotion':
        return AppTheme.primaryBlue;
      default:
        return AppTheme.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_notifications.any((notification) => !notification.isRead))
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: _markAllAsRead,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 60,
                        color: AppTheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadNotifications,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 80,
                            color: AppTheme.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No notifications yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'We\'ll notify you when something important happens',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return Dismissible(
                          key: Key(notification.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _deleteNotification(notification.id);
                          },
                          background: Container(
                            color: AppTheme.error,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: notification.isRead
                                    ? AppTheme.divider
                                    : _getColorForNotificationType(notification.type).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getIconForNotificationType(notification.type),
                                color: notification.isRead
                                    ? AppTheme.textTertiary
                                    : _getColorForNotificationType(notification.type),
                              ),
                            ),
                            title: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notification.message),
                                const SizedBox(height: 4),
                                Text(
                                  timeago.format(notification.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                            trailing: !notification.isRead
                                ? Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.primaryBlue,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : null,
                            onTap: () {
                              if (!notification.isRead) {
                                _markAsRead(notification.id);
                              }
                              // Handle notification tap if needed
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}