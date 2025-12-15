import '../models/task.dart';
import 'api_service.dart';

class TaskService {
  final ApiService _apiService = ApiService();

  /// Get all tasks with optional filters
  Future<List<Task>> getTasks({
    String? status,
    String? searchQuery,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (status != null) queryParams['status'] = status;
      if (searchQuery != null) queryParams['search'] = searchQuery;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final queryString = Uri(queryParameters: queryParams).query;
      final endpoint = '/tasks${queryString.isNotEmpty ? '?$queryString' : ''}';
      
      final response = await _apiService.get(endpoint);
      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        final List<Task> tasks = [];
        for (var taskData in data['data']) {
          tasks.add(Task.fromJson(taskData));
        }
        return tasks;
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch tasks');
      }
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  /// Get task by ID
  Future<Task> getTaskById(String taskId) async {
    try {
      final response = await _apiService.get('/tasks/$taskId');
      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        return Task.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch task');
      }
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }

  /// Submit task completion
  Future<Map<String, dynamic>> submitTask({
    required String taskId,
    String? notes,
    List<String>? attachments,
  }) async {
    try {
      final response = await _apiService.post('/tasks/$taskId/submit', {
        'notes': notes,
        'attachments': attachments,
      });

      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        return {
          'message': data['message'],
          'task': Task.fromJson(data['data']),
        };
      } else {
        throw Exception(data['message'] ?? 'Failed to submit task');
      }
    } catch (e) {
      throw Exception('Failed to submit task: $e');
    }
  }

  /// Get user's completed tasks
  Future<List<Task>> getCompletedTasks({
    int? page,
    int? limit,
  }) async {
    return getTasks(status: 'completed', page: page, limit: limit);
  }

  /// Get user's available tasks
  Future<List<Task>> getAvailableTasks({
    int? page,
    int? limit,
  }) async {
    return getTasks(status: 'available', page: page, limit: limit);
  }
}