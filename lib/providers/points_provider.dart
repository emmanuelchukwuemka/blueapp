import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/points_service.dart';

class PointsProvider with ChangeNotifier {
  int _totalPoints = 0;
  List<Transaction> _transactions = [];
  List<Transaction> _gainedTransactions = [];
  List<Transaction> _redeemedTransactions = [];
  bool _isLoading = false;
  String? _error;

  int get totalPoints => _totalPoints;
  List<Transaction> get transactions => _transactions;
  List<Transaction> get gainedTransactions => _gainedTransactions;
  List<Transaction> get redeemedTransactions => _redeemedTransactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final PointsService _pointsService = PointsService();

  // Fetch points balance
  Future<void> fetchPointsBalance() async {
    try {
      // MOCK DATA
      await Future.delayed(const Duration(milliseconds: 500));
      _totalPoints = 12500;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Fetch transaction history
  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      // MOCK DATA
      await Future.delayed(const Duration(milliseconds: 1000));
      
      _transactions = [
        Transaction(
          id: 'tx_1',
          type: 'task_completion',
          points: 150,
          description: 'Complete User Profile',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          status: 'completed',
        ),
        Transaction(
          id: 'tx_2',
          type: 'code_redemption',
          points: 500,
          description: 'Welcome Bonus Code',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          status: 'completed',
        ),
        Transaction(
          id: 'tx_3',
          type: 'redemption',
          points: -1000,
          description: 'Gift Card Redemption',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          status: 'processing',
          referenceNumber: 'REF-12345',
        ),
        Transaction(
          id: 'tx_4',
          type: 'task_completion',
          points: 50,
          description: 'Daily Login Reward',
          createdAt: DateTime.now().subtract(const Duration(days: 6)),
          status: 'completed',
        ),
        Transaction(
          id: 'tx_5',
          type: 'adjustment',
          points: 10,
          description: 'System Adjustment',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          status: 'completed',
        ),
      ];
      
      // Separate gained and redeemed
      _gainedTransactions = _transactions
          .where((t) => t.isGain)
          .toList();
      _redeemedTransactions = _transactions
          .where((t) => t.isRedemption)
          .toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Request redemption
  Future<Map<String, dynamic>?> requestRedemption(int points) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _pointsService.requestRedemption(points);
      
      // Update local points balance
      _totalPoints -= points;
      
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Redeem code
  Future<Map<String, dynamic>?> redeemCode(String code) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _pointsService.redeemCode(code);
      
      // Update local points balance
      if (result['points'] != null) {
        _totalPoints += result['points'] as int;
      }
      
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Get recent transactions
  List<Transaction> getRecentTransactions(int limit) {
    return _transactions.take(limit).toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
