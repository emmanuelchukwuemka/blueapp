class Task {
  final String id;
  final String title;
  final String description;
  final int pointsReward;
  final String status; // available, completed, pending, rejected, expired
  final String category;
  final String? iconUrl;
  final DateTime? expiryDate;
  final List<String> requirements;
  final List<String> instructions;
  final String? proofType; // image, document, text
  final bool isMultiStep;
  final int? currentStep;
  final int? totalSteps;
  final DateTime? completedAt;
  final DateTime? submittedAt;
  final String? rejectionReason;
  final List<String>? uploadedProofs;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsReward,
    required this.status,
    required this.category,
    this.iconUrl,
    this.expiryDate,
    this.requirements = const [],
    this.instructions = const [],
    this.proofType,
    this.isMultiStep = false,
    this.currentStep,
    this.totalSteps,
    this.completedAt,
    this.submittedAt,
    this.rejectionReason,
    this.uploadedProofs,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      pointsReward: json['points_reward'] ?? 0,
      status: json['status'] ?? 'available',
      category: json['category'] ?? 'General',
      iconUrl: json['icon_url'],
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'])
          : null,
      requirements: json['requirements'] != null
          ? List<String>.from(json['requirements'])
          : [],
      instructions: json['instructions'] != null
          ? List<String>.from(json['instructions'])
          : [],
      proofType: json['proof_type'],
      isMultiStep: json['is_multi_step'] ?? false,
      currentStep: json['current_step'],
      totalSteps: json['total_steps'],
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'])
          : null,
      rejectionReason: json['rejection_reason'],
      uploadedProofs: json['uploaded_proofs'] != null
          ? List<String>.from(json['uploaded_proofs'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points_reward': pointsReward,
      'status': status,
      'category': category,
      'icon_url': iconUrl,
      'expiry_date': expiryDate?.toIso8601String(),
      'requirements': requirements,
      'instructions': instructions,
      'proof_type': proofType,
      'is_multi_step': isMultiStep,
      'current_step': currentStep,
      'total_steps': totalSteps,
      'completed_at': completedAt?.toIso8601String(),
      'submitted_at': submittedAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
      'uploaded_proofs': uploadedProofs,
    };
  }

  bool get isExpired =>
      expiryDate != null && expiryDate!.isBefore(DateTime.now());

  bool get isAvailable => status == 'available' && !isExpired;

  int get progressPercentage {
    if (!isMultiStep || totalSteps == null || currentStep == null) return 0;
    return ((currentStep! / totalSteps!) * 100).round();
  }
}
