import '../../providers/task_provider.dart';
import '../../models/task.dart';
import 'package:provider/provider.dart';
import 'task_detail_screen.dart';
import '../../widgets/common/loading_overlay.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Open search
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return LoadingOverlay(
            isLoading: taskProvider.isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('all', 'All', taskProvider),
                        const SizedBox(width: AppTheme.spacingS),
                        _buildFilterChip('available', 'Available', taskProvider),
                        const SizedBox(width: AppTheme.spacingS),
                        _buildFilterChip('completed', 'Completed', taskProvider),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Task list header
                  Text(
                    '${_getFilterLabel(taskProvider.selectedFilter)} Tasks',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Task cards
                  if (taskProvider.tasks.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No tasks found'),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: taskProvider.tasks.length,
                      itemBuilder: (context, index) {
                        return _buildTaskCard(context, taskProvider.tasks[index]);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String filterValue, String label, TaskProvider provider) {
    final isSelected = provider.selectedFilter == filterValue;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          provider.setFilter(filterValue);
        }
      },
      backgroundColor: AppTheme.cardBackground,
      selectedColor: AppTheme.primaryBlue.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryBlue : AppTheme.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
  
  String _getFilterLabel(String filter) {
    switch (filter) {
      case 'available': return 'Available';
      case 'completed': return 'Completed';
      case 'pending': return 'Pending';
      default: return 'All';
    }
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusM)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(taskId: task.id),
            ),
          ).then((_) {
            // Refresh tasks when returning
            Provider.of<TaskProvider>(context, listen: false).fetchTasks();
          });
        },
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
                      color: _getCategoryColor(task.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Icon(
                      _getCategoryIcon(task.category),
                      color: _getCategoryColor(task.category),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (task.expiryDate != null)
                           Text(
                            'Expires: ${_formatDate(task.expiryDate!)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.error,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingS,
                      vertical: AppTheme.spacingXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Text(
                      '+${task.pointsReward} pts',
                      style: const TextStyle(
                        color: AppTheme.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.divider,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.category,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ),
                  _buildStatusText(task.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusText(String status) {
    Color color;
    String text;
    
    switch (status) {
      case 'completed':
        color = AppTheme.success;
        text = 'Completed';
        break;
      case 'pending':
        color = Colors.orange;
        text = 'Pending';
        break;
      default:
        color = AppTheme.primaryBlue;
        text = 'Start >';
    }
    
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'profile': return Icons.person;
      case 'video': return Icons.play_circle;
      case 'social': return Icons.share;
      case 'shopping': return Icons.shopping_bag;
      default: return Icons.task;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'profile': return Colors.purple;
      case 'video': return Colors.red;
      case 'social': return Colors.blue;
      case 'shopping': return Colors.green;
      default: return AppTheme.primaryBlue;
    }
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
}