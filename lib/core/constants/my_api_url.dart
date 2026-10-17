class MyApiUrl {
  static const String baseUrl = 'https://backend.goneurova.com';
  //'https://tutor-ai-app.up.railway.app/';
  // "https://tutor-ai.up.railway.app";
  static const String version = "api/v1";

  // auth
  static const String authSession = "auth/session";
  static const String authRefresh = "auth/refresh";
  static const String authOnboarding = "auth/onboarding";
  static const String authProfile = "auth/profile";
  static const String authAccountDelete = "auth/account";
  static const String authAccountDelete2 = "auth/me";
  static const String authAccountDelete3 = "auth/user";

  /// dashboard
  static const String dashboard = "dashboard";

  /// Study Sets
  static const String studyHistory = "study-sets/history";
  static const String studyUploadPdf = "upload/pdf";
  static const String studySetsGenerate = "study-sets/generate";
  String getStudySetDetail(String studySetId, String type) =>
      "study-sets/$studySetId/$type";
  String getStudySetProgress(String studySetId) =>
      "study-sets/$studySetId/progress";

  // study sets --> submit & delete
  String submitMcqAnswers(String studySetId) =>
      "study-sets/$studySetId/mcq/answer";
  String submitFillInTheBlankAnswers(String studySetId) =>
      "study-sets/$studySetId/fill_blank/answer";
  String submitFlashcardAnswers(String studySetId) =>
      "study-sets/$studySetId/flashcard/review";
  String deleteStudySet(String studySetId) => "study-sets/$studySetId";

  // study sets --> chat
  static String chatSession({required String studySetId}) =>
      "study-sets/$studySetId/chat/sessions";
  static String chatSessionHistory({
    required String studySetId,
    required String conversationId,
  }) => "study-sets/$studySetId/chat/sessions/$conversationId";
  static String createChatSession({required String studySetId}) =>
      "study-sets/$studySetId/chat";

  /// Settings
  static const String creditsBalance = "credits/balance";
  static const String creditsHistory = "credits/history";
  static const String userSubscription = "payments/subscription";
  static const String userPlans = "payments/plans";
  static const String userPacks = "payments/packs";
  static const String personalization = "personalization";

  // syllabus
  static const String syllabusHistory = "syllabus/history";
  static const String syllabusUploadPdf = "syllabus/upload/pdf";
  String getSyllabusAnalysis(String analysisId) => "syllabus/$analysisId";
  String getSyllabus(String syllabusId) => "syllabus/$syllabusId/full";
  String deleteSyllabus(String syllabusId) => "syllabus/$syllabusId";

  // grader
  static const String graderHistory = "grader/history";
  static const String graderSubmit = "grader/submit";
  String graderResult(String submissionId) => "grader/result/$submissionId";
  String deleteGraderResult(String submissionId) =>
      "grader/result/$submissionId";

  // billing
  static const String billingSubscriptionIntent =
      "billing/mobile/create-subscription-intent";
  static const String billingTopupIntent = "payments/topup/mobile";
  static const String billingAppleConfig = "payments/apple/config";
  static const String billingAppleVerifyTransaction =
      "payments/apple/transactions/verify";

  // Settings - support
  static const String helpCenter = "https://www.goneurova.com/contact";
  static const String privacyPolicy =
      "https://www.goneurova.com/privacy-policy";
  static const String termsOfService =
      "https://www.goneurova.com/terms-of-service";
  static const String refundPolicy = "https://www.goneurova.com/refund-policy";

  // Settings - personalized AI
  static const String personalizedAi = "personalization/questions";
  static const String personalizedAiAnswers = "personalization/answers";
}
