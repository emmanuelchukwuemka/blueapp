import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/task.dart';
import '../../providers/task_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_overlay.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  Task? _task;
  bool _isLoading = true;
  final TextEditingController _notesController = TextEditingController();
  
  // Mock file selection
  bool _isFileSelected = false;
  String? _selectedFileName;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    final task = await Provider.of<TaskProvider>(context, listen: false).getTaskDetails(widget.taskId);
    if (mounted) {
      setState(() {
        _task = task;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submitTask() async {
    if (_task == null) return;
    
    // Validation
    if (_task!.proofType == 'image' && !_isFileSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a proof image')),
      );
      return;
    }

    final success = await Provider.of<TaskProvider>(context, listen: false).submitTask(
      _task!.id,
      _selectedFileName != null ? [_selectedFileName!] : [],
      _notesController.text,
    );

    if (mounted) {
      if (success) {
        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit task')),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: AppTheme.success, size: 60),
            SizedBox(height: 16),
            Text('Task Submitted!'),
          ],
        ),
        content: const Text(
          'Your task has been submitted for review. Points will be credited once approved.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to list
            },
            child: const Text('Back to Tasks'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task Details')),
        body: const Center(child: Text('Task not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_task!.category),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return LoadingOverlay(
            isLoading: taskProvider.isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Reward
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _task!.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                          vertical: AppTheme.spacingS,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: Text(
                          '${_task!.pointsReward} pts',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Status Badge
                  _buildStatusBadge(_task!.status),
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    _task!.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Requirements
                  if (_task!.requirements.isNotEmpty) ...[
                    const Text(
                      'Requirements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    ..._task!.requirements.map((req) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline, size: 20, color: AppTheme.primaryBlue),
                          const SizedBox(width: 8),
                          Expanded(child: Text(req)),
                        ],
                      ),
                    )),
                    const SizedBox(height: AppTheme.spacingL),
                  ],

                  // Instructions
                  if (_task!.instructions.isNotEmpty) ...[
                    const Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    ..._task!.instructions.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppTheme.divider,
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(entry.value)),
                        ],
                      ),
                    )),
                    const SizedBox(height: AppTheme.spacingL),
                  ],

                  // Submission Section (Only if available)
                  if (_task!.status == 'available') ...[
                    const Divider(),
                    const SizedBox(height: AppTheme.spacingM),
                    const Text(
                      'Submit Proof',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    
                    if (_task!.proofType == 'image')
                      InkWell(
                        onTap: () {
                          // Mock file picking
                          setState(() {
                            _isFileSelected = true;
                            _selectedFileName = 'proof_image.jpg';
                          });
                        },
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.divider),
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                            color: AppTheme.cardBackground,
                          ),
                          child: _isFileSelected
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle, size: 40, color: AppTheme.success),
                                    const SizedBox(height: 8),
                                    Text(_selectedFileName!),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isFileSelected = false;
                                          _selectedFileName = null;
                                        });
                                      },
                                      child: const Text('Remove'),
                                    ),
                                  ],
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt, size: 40, color: AppTheme.textSecondary),
                                    SizedBox(height: 8),
                                    Text('Tap to upload image'),
                                  ],
                                ),
                        ),
                      ),
                      
                    const SizedBox(height: AppTheme.spacingM),
                    CustomButton(
                      onPressed: _submitTask,
                      text: 'Submit Task',
                    ),
                  ],
                  
                  if (_task!.status == 'pending')
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.access_time, color: Colors.orange, size: 32),
                          SizedBox(height: 8),
                          Text(
                            'Task Under Review',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                          ),
                          Text(
                            'We are reviewing your submission.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                    
                   if (_task!.status == 'completed')
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        border: Border.all(color: AppTheme.success.withOpacity(0.3)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.check_circle, color: AppTheme.success, size: 32),
                          SizedBox(height: 8),
                          Text(
                            'Task Completed',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.success),
                          ),
                          Text(
                            'You have earned the reward.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.success),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'completed':
        color = AppTheme.success;
        label = 'Completed';
        break;
      case 'pending':
        color = Colors.orange;
        label = 'Pending Review';
        break;
      case 'rejected':
        color = AppTheme.error;
        label = 'Rejected';
        break;
      default:
        color = AppTheme.primaryBlue;
        label = 'Available';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
