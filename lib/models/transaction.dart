class Transaction {
  final String id;
  final String type; // task_completion, code_redemption, bonus, redemption, adjustment
  final int points;
  final String description;
  final DateTime createdAt;
  final String? status; // For redemptions: pending, processing, completed, rejected
  final String? referenceNumber;
  final String? taskId;
  final String? code;
  final Map<String, dynamic>? metadata;

  Transaction({
    required this.id,
    required this.type,
    required this.points,
    required this.description,
    required this.createdAt,
    this.status,
    this.referenceNumber,
    this.taskId,
    this.code,
    this.metadata,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      points: json['points'] ?? 0,
      description: json['description'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      status: json['status'],
      referenceNumber: json['reference_number'],
      taskId: json['task_id'],
      code: json['code'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'points': points,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'status': status,
      'reference_number': referenceNumber,
      'task_id': taskId,
      'code': code,
      'metadata': metadata,
    };
  }

  bool get isGain => points > 0;
  bool get isRedemption => points < 0;

  String get displayType {
    switch (type) {
      case 'task_completion':
        return 'Task Completed';
      case 'code_redemption':
        return 'Code Redeemed';
      case 'bonus':
        return 'Bonus Points';
      case 'redemption':
        return 'Points Redeemed';
      case 'adjustment':
        return 'Points Adjustment';
      default:
        return 'Transaction';
    }
  }

  String get displayPoints {
    if (points > 0) {
      return '+${points.abs()}';
    } else {
      return '-${points.abs()}';
    }
  }
}
