class RedemptionCode {
  final String code;
  final int points;
  final DateTime? expiryDate;
  final bool isUsed;
  final DateTime? usedAt;
  final String? terms;

  RedemptionCode({
    required this.code,
    required this.points,
    this.expiryDate,
    this.isUsed = false,
    this.usedAt,
    this.terms,
  });

  factory RedemptionCode.fromJson(Map<String, dynamic> json) {
    return RedemptionCode(
      code: json['code'] ?? '',
      points: json['points'] ?? 0,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'])
          : null,
      isUsed: json['is_used'] ?? false,
      usedAt: json['used_at'] != null
          ? DateTime.parse(json['used_at'])
          : null,
      terms: json['terms'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'points': points,
      'expiry_date': expiryDate?.toIso8601String(),
      'is_used': isUsed,
      'used_at': usedAt?.toIso8601String(),
      'terms': terms,
    };
  }

  bool get isExpired =>
      expiryDate != null && expiryDate!.isBefore(DateTime.now());

  bool get isValid => !isUsed && !isExpired;
}
