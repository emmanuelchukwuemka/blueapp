class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.bluepoint.com'; // Replace with actual API URL
  static const String apiVersion = 'v1';
  
  // Endpoints
  static const String authEndpoint = '/auth';
  static const String tasksEndpoint = '/tasks';
  static const String pointsEndpoint = '/points';
  static const String redemptionEndpoint = '/redemptions';
  static const String codeRedemptionEndpoint = '/code-redemption';
  static const String historyEndpoint = '/history';
  static const String profileEndpoint = '/profile';
  static const String notificationsEndpoint = '/notifications';
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  static const String rememberMeKey = 'remember_me';
  static const String themeKey = 'theme_mode';
  static const String biometricEnabledKey = 'biometric_enabled';
  
  // App Configuration
  static const String appName = 'BluePoint';
  static const String appVersion = '1.0.0';
  static const int splashDuration = 3; // seconds
  static const int otpLength = 6;
  static const int otpResendTime = 60; // seconds
  static const int sessionTimeout = 30; // minutes
  
  // Points & Redemption
  static const int minimumRedemptionPoints = 1000;
  static const int codeLength = 8;
  
  // Pagination
  static const int pageSize = 20;
  static const int taskPreviewLimit = 5;
  static const int recentActivityLimit = 5;
  static const int recentCodesLimit = 5;
  
  // File Upload
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxDocumentSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentFormats = ['pdf', 'doc', 'docx'];
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  
  // Account Types
  static const String accountTypeUser = 'user';
  static const String accountTypePartner = 'partner';
  
  // Task Status
  static const String taskStatusAvailable = 'available';
  static const String taskStatusCompleted = 'completed';
  static const String taskStatusPending = 'pending';
  static const String taskStatusRejected = 'rejected';
  static const String taskStatusExpired = 'expired';
  
  // Redemption Status
  static const String redemptionStatusPending = 'pending';
  static const String redemptionStatusProcessing = 'processing';
  static const String redemptionStatusCompleted = 'completed';
  static const String redemptionStatusRejected = 'rejected';
  
  // Transaction Types
  static const String transactionTypeTaskCompletion = 'task_completion';
  static const String transactionTypeCodeRedemption = 'code_redemption';
  static const String transactionTypeBonus = 'bonus';
  static const String transactionTypeRedemption = 'redemption';
  static const String transactionTypeAdjustment = 'adjustment';
  
  // Notification Types
  static const String notificationTaskApproved = 'task_approved';
  static const String notificationTaskRejected = 'task_rejected';
  static const String notificationPointsCredited = 'points_credited';
  static const String notificationRedemptionUpdate = 'redemption_update';
  static const String notificationSystemAnnouncement = 'system_announcement';
  static const String notificationPromotion = 'promotion';
  
  // Messages
  static const String bankDetailsMessage = 
      'Bank details are managed on MyFigPoint Web App. Please update your bank details there before requesting redemption.';
  static const String learnMoreBankDetails = 
      'To ensure secure processing of your redemptions, bank account details must be managed through the MyFigPoint web application. Visit myfigpoint.com to add or update your banking information.';
  static const String redemptionSuccessMessage = 
      'Your redemption request has been submitted successfully. Admin will contact you soon with further details.';
  static const String insufficientPointsMessage = 
      'You do not have enough points for this redemption.';
  static const String minimumRedemptionMessage = 
      'Minimum redemption amount is $minimumRedemptionPoints points.';
  
  // External Links
  static const String webAppUrl = 'https://myfigpoint.com';
  static const String termsUrl = 'https://bluepoint.com/terms';
  static const String privacyUrl = 'https://bluepoint.com/privacy';
  static const String helpUrl = 'https://bluepoint.com/help';
  static const String supportEmail = 'support@bluepoint.com';
  
  // Animation Durations (milliseconds)
  static const int animationFast = 200;
  static const int animationNormal = 300;
  static const int animationSlow = 500;
  static const int splashAnimationDuration = 1500;
  
  // Regular Expressions
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phoneRegex = RegExp(
    r'^\+?[\d\s-]{10,}$',
  );
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
  );
}
