import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _completedTasks = [];
  bool _isLoading = false;
  String? _error;
  String _selectedFilter = 'all';
  String _searchQuery = '';

  List<Task> get tasks => _filteredTasks();
  List<Task> get completedTasks => _completedTasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedFilter => _selectedFilter;

  final TaskService _taskService = TaskService();

  // Fetch available tasks
  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      // MOCK DATA
      await Future.delayed(const Duration(milliseconds: 1200));
      
      _tasks = [
        Task(
          id: 'task_1',
          title: 'Complete User Profile',
          description: 'Fill in all your profile details including full name, phone number, and preferences.',
          pointsReward: 150,
          status: 'available',
          category: 'Profile',
          expiryDate: DateTime.now().add(const Duration(days: 7)),
          requirements: ['Upload profile picture', 'Verify email', 'Add phone number'],
          instructions: ['Go to Profile', 'Click Edit', 'Save Changes'],
          isMultiStep: true,
          totalSteps: 3,
          currentStep: 1,
        ),
        Task(
          id: 'task_2',
          title: 'Watch Intro Video',
          description: 'Watch a short video about how BluePoint works and earn instant points.',
          pointsReward: 50,
          status: 'available',
          category: 'Video',
          proofType: 'text',
        ),
        Task(
          id: 'task_3',
          title: 'Invite a Friend',
          description: 'Share your referral code with a friend. Points awarded when they sign up.',
          pointsReward: 500,
          status: 'available',
          category: 'Social',
        ),
        Task(
          id: 'task_4',
          title: 'Daily Check-in',
          description: 'Open the app and check in to keep your streak alive.',
          pointsReward: 10,
          status: 'completed',
          category: 'Daily',
          completedAt: DateTime.now(),
        ),
        Task(
          id: 'task_5',
          title: 'Upload Receipt',
          description: 'Upload a clear photo of your purchase receipt from a partner store.',
          pointsReward: 200,
          status: 'pending',
          category: 'Shopping',
          submittedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch completed tasks
  Future<void> fetchCompletedTasks() async {
    try {
      _completedTasks = await _taskService.getCompletedTasks();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get single task details
  Future<Task?> getTaskDetails(String taskId) async {
    try {
      return await _taskService.getTaskDetails(taskId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Submit task
  Future<bool> submitTask(String taskId, List<String> proofs, String? notes) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _taskService.submitTask(taskId, proofs, notes);
      
      // Update task status in local list
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = Task.fromJson({
          ..._tasks[index].toJson(),
          'status': 'pending',
          'submitted_at': DateTime.now().toIso8601String(),
        });
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Filter tasks
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // Search tasks
  void searchTasks(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  // Get filtered tasks
  List<Task> _filteredTasks() {
    var filtered = _tasks;

    // Apply status filter
    if (_selectedFilter != 'all') {
      filtered = filtered.where((task) => task.status == _selectedFilter).toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) =>
        task.title.toLowerCase().contains(_searchQuery) ||
        task.description.toLowerCase().contains(_searchQuery)
      ).toList();
    }

    return filtered;
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
