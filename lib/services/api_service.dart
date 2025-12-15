import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String _baseUrl = AppConstants.baseUrl;
  final String _apiVersion = AppConstants.apiVersion;

  String get baseUrl => '$_baseUrl/$_apiVersion';

  /// Get authorization header with token from shared preferences
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.authTokenKey);
    
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  /// Perform GET request
  Future<http.Response> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    return await http.get(uri, headers: headers);
  }

  /// Perform POST request
  Future<http.Response> post(String endpoint, Object? body) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    return await http.post(uri, headers: headers, body: jsonEncode(body));
  }

  /// Perform PUT request
  Future<http.Response> put(String endpoint, Object? body) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    return await http.put(uri, headers: headers, body: jsonEncode(body));
  }

  /// Perform DELETE request
  Future<http.Response> delete(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    return await http.delete(uri, headers: headers);
  }

  /// Handle API response and parse JSON
  dynamic handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw Exception('Failed to parse response: ${response.body}');
      }
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}