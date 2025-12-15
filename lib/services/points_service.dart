import '../models/transaction.dart';
import 'api_service.dart';

class PointsService {
  final ApiService _apiService = ApiService();

  /// Get user's current points balance
  Future<int> getPointsBalance() async {
    try {
      final response = await _apiService.get('/points/balance');
      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        return data['data']['balance'] as int;
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch points balance');
      }
    } catch (e) {
      throw Exception('Failed to fetch points balance: $e');
    }
  }

  /// Request points redemption
  Future<Map<String, dynamic>> redeemPoints(int points) async {
    try {
      final response = await _apiService.post('/points/redeem', {
        'points': points,
      });

      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        return {
          'message': data['message'],
          'transaction': Transaction.fromJson(data['data']),
        };
      } else {
        throw Exception(data['message'] ?? 'Failed to redeem points');
      }
    } catch (e) {
      throw Exception('Failed to redeem points: $e');
    }
  }

  /// Redeem points using a code
  Future<Map<String, dynamic>> redeemCode(String code) async {
    try {
      final response = await _apiService.post('/points/redeem-code', {
        'code': code,
      });

      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        return {
          'message': data['message'],
          'transaction': Transaction.fromJson(data['data']),
        };
      } else {
        throw Exception(data['message'] ?? 'Failed to redeem code');
      }
    } catch (e) {
      throw Exception('Failed to redeem code: $e');
    }
  }

  /// Get transaction history
  Future<List<Transaction>> getTransactionHistory({
    String? type,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (type != null) queryParams['type'] = type;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final queryString = Uri(queryParameters: queryParams).query;
      final endpoint = '/points/history${queryString.isNotEmpty ? '?$queryString' : ''}';
      
      final response = await _apiService.get(endpoint);
      final data = _apiService.handleResponse(response);
      
      if (data['success'] == true) {
        final List<Transaction> transactions = [];
        for (var transactionData in data['data']) {
          transactions.add(Transaction.fromJson(transactionData));
        }
        return transactions;
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch transaction history');
      }
    } catch (e) {
      throw Exception('Failed to fetch transaction history: $e');
    }
  }

  /// Get points gained transactions
  Future<List<Transaction>> getPointsGained({
    int? page,
    int? limit,
  }) async {
    return getTransactionHistory(type: 'gained', page: page, limit: limit);
  }

  /// Get points redeemed transactions
  Future<List<Transaction>> getPointsRedeemed({
    int? page,
    int? limit,
  }) async {
    return getTransactionHistory(type: 'redeemed', page: page, limit: limit);
  }
}