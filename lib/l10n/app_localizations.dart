import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Flutter Project Template'**
  String get appTitle;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success text
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Cancel text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Save text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Delete text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Retry text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Close text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// OK text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Settings navigation label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Profile navigation label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Back navigation label
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next navigation label
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// About page label
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Login text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Logout text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Edit text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Register text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Forgot password text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// Server error message
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverError;

  /// Unauthorized error message
  ///
  /// In en, this message translates to:
  /// **'Unauthorized. Please login again.'**
  String get unauthorizedError;

  /// Session expired message
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please login again.'**
  String get sessionExpired;

  /// Validation error message
  ///
  /// In en, this message translates to:
  /// **'Please check your input.'**
  String get validationError;

  /// Empty list message
  ///
  /// In en, this message translates to:
  /// **'No items found.'**
  String get emptyList;

  /// Operation success message
  ///
  /// In en, this message translates to:
  /// **'Operation completed successfully.'**
  String get operationSuccess;

  /// Save success message
  ///
  /// In en, this message translates to:
  /// **'Saved successfully.'**
  String get saveSuccess;

  /// Delete success message
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully.'**
  String get deleteSuccess;

  /// Template features header text
  ///
  /// In en, this message translates to:
  /// **'This template includes:'**
  String get templateIncludes;

  /// Clean Architecture feature item
  ///
  /// In en, this message translates to:
  /// **'Clean Architecture structure'**
  String get featureCleanArchitecture;

  /// Riverpod feature item
  ///
  /// In en, this message translates to:
  /// **'Riverpod state management'**
  String get featureRiverpod;

  /// go_router feature item
  ///
  /// In en, this message translates to:
  /// **'go_router navigation'**
  String get featureGoRouter;

  /// Dio feature item
  ///
  /// In en, this message translates to:
  /// **'Dio HTTP client'**
  String get featureDio;

  /// Drift feature item
  ///
  /// In en, this message translates to:
  /// **'Drift database'**
  String get featureDrift;

  /// json_serializable feature item
  ///
  /// In en, this message translates to:
  /// **'json_serializable'**
  String get featureJsonSerializable;

  /// Lint rules feature item
  ///
  /// In en, this message translates to:
  /// **'Comprehensive lint rules'**
  String get featureLintRules;

  /// i18n feature item
  ///
  /// In en, this message translates to:
  /// **'Internationalization support'**
  String get featureI18n;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Guest user name
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Chinese language option
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// System language option
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get languageSystem;

  /// Language selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get themeSystem;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Account section title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Preferences section title
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// Notifications setting label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Sound setting label
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// Vibration setting label
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// Security section title
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Change password label
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// About app section title
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Privacy policy label
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Terms of service label
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Welcome back message
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Sign in prompt
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// Create account header
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Sign up prompt
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get signUpToGetStarted;

  /// Username label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Confirm password label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// WeChat login button
  ///
  /// In en, this message translates to:
  /// **'Continue with WeChat'**
  String get continueWithWeChat;

  /// Apple login button
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// Google login button
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No account prompt
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// Have account prompt
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// Enter email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enterEmail;

  /// Valid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get enterValidEmail;

  /// Enter password validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enterPassword;

  /// Password min length validation message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Enter username validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a username'**
  String get enterUsername;

  /// Username min length validation message
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get usernameMinLength;

  /// Confirm password validation message
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmYourPassword;

  /// Passwords match validation message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Developer options section title
  ///
  /// In en, this message translates to:
  /// **'Developer Options'**
  String get developerOptions;

  /// Environment selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Environment'**
  String get selectEnvironment;

  /// Development environment option
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get environmentDevelopment;

  /// Staging environment option
  ///
  /// In en, this message translates to:
  /// **'Staging'**
  String get environmentStaging;

  /// Production environment option
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get environmentProduction;

  /// Current environment label
  ///
  /// In en, this message translates to:
  /// **'Current Environment'**
  String get currentEnvironment;

  /// Restart required title
  ///
  /// In en, this message translates to:
  /// **'Restart Required'**
  String get restartRequired;

  /// Restart required message
  ///
  /// In en, this message translates to:
  /// **'The app needs to restart for the environment change to take effect. Do you want to restart now?'**
  String get restartRequiredMessage;

  /// Restart now button text
  ///
  /// In en, this message translates to:
  /// **'Restart Now'**
  String get restartNow;

  /// Restart later button text
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get restartLater;

  /// Legal section title
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// Build date label
  ///
  /// In en, this message translates to:
  /// **'Build Date'**
  String get buildDate;

  /// ICP registration number
  ///
  /// In en, this message translates to:
  /// **'ICP License No. XXXXXXXX-1'**
  String get icpNumber;

  /// Default WebView title
  ///
  /// In en, this message translates to:
  /// **'WebView'**
  String get webViewTitle;

  /// WebView loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get webViewLoading;

  /// WebView error message
  ///
  /// In en, this message translates to:
  /// **'Failed to load page'**
  String get webViewError;

  /// WebView refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get webViewRefresh;

  /// WebView forward button tooltip
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get webViewForward;

  /// Clear WebView cache
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get webViewClearCache;

  /// Cache cleared success message
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get webViewClearCacheSuccess;

  /// Download started message
  ///
  /// In en, this message translates to:
  /// **'Download started'**
  String get webViewDownloadStarted;

  /// Download complete message
  ///
  /// In en, this message translates to:
  /// **'Download complete'**
  String get webViewDownloadComplete;

  /// Download failed message
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get webViewDownloadFailed;

  /// File saved message
  ///
  /// In en, this message translates to:
  /// **'File saved'**
  String get webViewFileSaved;

  /// Open in browser option
  ///
  /// In en, this message translates to:
  /// **'Open in Browser'**
  String get webViewOpenInBrowser;

  /// Share URL option
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get webViewShare;

  /// Copy URL option
  ///
  /// In en, this message translates to:
  /// **'Copy URL'**
  String get webViewCopyUrl;

  /// URL copied message
  ///
  /// In en, this message translates to:
  /// **'URL copied to clipboard'**
  String get webViewUrlCopied;

  /// Privacy consent dialog title
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy & User Agreement'**
  String get privacyConsentTitle;

  /// Privacy consent dialog description
  ///
  /// In en, this message translates to:
  /// **'Before using this app, please read and agree to our Privacy Policy and User Agreement. We take your privacy seriously and are committed to protecting your personal information.'**
  String get privacyConsentDescription;

  /// Read more text in privacy consent
  ///
  /// In en, this message translates to:
  /// **'Read the following documents for more details:'**
  String get privacyConsentReadMore;

  /// Privacy consent required message
  ///
  /// In en, this message translates to:
  /// **'You must agree to the privacy policy to use this app.'**
  String get privacyConsentRequired;

  /// Exit confirmation title
  ///
  /// In en, this message translates to:
  /// **'Exit App?'**
  String get privacyConsentExitTitle;

  /// Exit confirmation message
  ///
  /// In en, this message translates to:
  /// **'If you do not agree with the privacy policy, you will not be able to use this app. Are you sure you want to exit?'**
  String get privacyConsentExitMessage;

  /// Agree button text
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// Disagree button text
  ///
  /// In en, this message translates to:
  /// **'Disagree'**
  String get disagree;

  /// Show privacy consent button text
  ///
  /// In en, this message translates to:
  /// **'Show Privacy Consent'**
  String get showPrivacyConsent;

  /// Privacy settings screen title
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// Legal documents section title
  ///
  /// In en, this message translates to:
  /// **'Legal Documents'**
  String get legalDocuments;

  /// Data preferences section title
  ///
  /// In en, this message translates to:
  /// **'Data Preferences'**
  String get dataPreferences;

  /// Data collection setting
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get dataCollection;

  /// Data collection description
  ///
  /// In en, this message translates to:
  /// **'Allow app to collect usage data to improve services'**
  String get dataCollectionDescription;

  /// Analytics setting
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// Analytics description
  ///
  /// In en, this message translates to:
  /// **'Help us improve by sharing anonymous usage data'**
  String get analyticsDescription;

  /// App permissions section title
  ///
  /// In en, this message translates to:
  /// **'App Permissions'**
  String get appPermissions;

  /// Camera permission
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Photo library permission
  ///
  /// In en, this message translates to:
  /// **'Photo Library'**
  String get photoLibrary;

  /// Location permission
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Region settings section title
  ///
  /// In en, this message translates to:
  /// **'Region Settings'**
  String get regionSettings;

  /// Market region setting
  ///
  /// In en, this message translates to:
  /// **'Market Region'**
  String get marketRegion;

  /// Select region dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Region'**
  String get selectRegion;

  /// China region option
  ///
  /// In en, this message translates to:
  /// **'China (PIPL)'**
  String get regionChina;

  /// International region option
  ///
  /// In en, this message translates to:
  /// **'International (GDPR)'**
  String get regionInternational;

  /// Delete account button
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Delete account subtitle
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all data'**
  String get deleteAccountSubtitle;

  /// Account deletion warning title
  ///
  /// In en, this message translates to:
  /// **'Warning: This action cannot be undone'**
  String get accountDeletionWarningTitle;

  /// Account deletion warning description
  ///
  /// In en, this message translates to:
  /// **'Deleting your account will permanently remove all your data, including your profile, messages, and settings. This action cannot be undone.'**
  String get accountDeletionWarningDescription;

  /// Data to be deleted label
  ///
  /// In en, this message translates to:
  /// **'Data to be deleted:'**
  String get dataToBeDeleted;

  /// Profile information item
  ///
  /// In en, this message translates to:
  /// **'Profile information'**
  String get profileInformation;

  /// Chat history item
  ///
  /// In en, this message translates to:
  /// **'Chat history'**
  String get chatHistory;

  /// Settings and preferences item
  ///
  /// In en, this message translates to:
  /// **'Settings and preferences'**
  String get settingsAndPreferences;

  /// Saved data item
  ///
  /// In en, this message translates to:
  /// **'Saved data'**
  String get savedData;

  /// First confirmation checkbox
  ///
  /// In en, this message translates to:
  /// **'I understand that all my data will be permanently deleted'**
  String get accountDeletionConfirm1;

  /// Second confirmation checkbox
  ///
  /// In en, this message translates to:
  /// **'I understand this action cannot be undone'**
  String get accountDeletionConfirm2;

  /// Delete account permanently button
  ///
  /// In en, this message translates to:
  /// **'Delete Account Permanently'**
  String get deleteAccountPermanently;

  /// Deleting in progress text
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deleting;

  /// Account deleted success message
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccess;

  /// Account deleted failed message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get accountDeletedFailed;

  /// Please confirm all checkboxes message
  ///
  /// In en, this message translates to:
  /// **'Please confirm all checkboxes'**
  String get pleaseConfirmAllCheckboxes;

  /// Camera permission title
  ///
  /// In en, this message translates to:
  /// **'Camera Access'**
  String get cameraPermissionTitle;

  /// Camera permission subtitle
  ///
  /// In en, this message translates to:
  /// **'Required for taking photos'**
  String get cameraPermissionSubtitle;

  /// Camera permission description
  ///
  /// In en, this message translates to:
  /// **'We need access to your camera to take photos for your profile picture and share with others. Your photos will only be shared with your consent.'**
  String get cameraPermissionDescription;

  /// Photo library permission title
  ///
  /// In en, this message translates to:
  /// **'Photo Library Access'**
  String get photoLibraryPermissionTitle;

  /// Photo library permission subtitle
  ///
  /// In en, this message translates to:
  /// **'Required for selecting photos'**
  String get photoLibraryPermissionSubtitle;

  /// Photo library permission description
  ///
  /// In en, this message translates to:
  /// **'We need access to your photo library to select and share photos. Your photos will only be shared with your consent.'**
  String get photoLibraryPermissionDescription;

  /// Location permission title
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get locationPermissionTitle;

  /// Location permission subtitle
  ///
  /// In en, this message translates to:
  /// **'Required for location features'**
  String get locationPermissionSubtitle;

  /// Location permission description
  ///
  /// In en, this message translates to:
  /// **'We need access to your location to provide location-based features such as finding nearby users and sharing your location. Your location data is handled securely.'**
  String get locationPermissionDescription;

  /// Notification permission title
  ///
  /// In en, this message translates to:
  /// **'Notification Access'**
  String get notificationPermissionTitle;

  /// Notification permission subtitle
  ///
  /// In en, this message translates to:
  /// **'Required for notifications'**
  String get notificationPermissionSubtitle;

  /// Notification permission description
  ///
  /// In en, this message translates to:
  /// **'We need permission to send you notifications about messages, updates, and important alerts. You can customize notification settings anytime.'**
  String get notificationPermissionDescription;

  /// Grant permission button
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// Skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Permission permanently denied title
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get permissionPermanentlyDeniedTitle;

  /// Permission permanently denied message
  ///
  /// In en, this message translates to:
  /// **'This permission has been permanently denied. Please enable it in app settings.'**
  String get permissionPermanentlyDeniedMessage;

  /// Open settings button
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Permission already granted message
  ///
  /// In en, this message translates to:
  /// **'Permission already granted'**
  String get permissionAlreadyGranted;

  /// Privacy consent status label
  ///
  /// In en, this message translates to:
  /// **'Privacy Consent Status'**
  String get privacyConsentStatus;

  /// Privacy consent date
  ///
  /// In en, this message translates to:
  /// **'Consented on: {date}'**
  String privacyConsentDate(Object date);

  /// Privacy policy version
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy Version: {version}'**
  String privacyPolicyVersion(Object version);

  /// Terms of service subtitle
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get termsOfServiceSubtitle;

  /// Privacy consent text part 1
  ///
  /// In en, this message translates to:
  /// **'Before using this app, please read and agree to our '**
  String get privacyConsentPart1;

  /// Privacy policy link text
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyConsentLinkPrivacy;

  /// Privacy consent text part 2
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get privacyConsentPart2;

  /// Terms of service link text
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get privacyConsentLinkTerms;

  /// Privacy consent text part 3
  ///
  /// In en, this message translates to:
  /// **'. We take your privacy seriously and are committed to protecting your personal information.'**
  String get privacyConsentPart3;

  /// Action cannot be undone warning
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get actionCannotBeUndone;

  /// OR divider text
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Enter email or username validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your email or username'**
  String get enterEmailOrUsername;

  /// Chats screen title
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// Search conversations hint
  ///
  /// In en, this message translates to:
  /// **'Search conversations...'**
  String get searchConversations;

  /// No conversations empty state title
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noConversationsYet;

  /// Start new chat hint
  ///
  /// In en, this message translates to:
  /// **'Start a new chat by tapping the button below'**
  String get startNewChatHint;

  /// No search results title
  ///
  /// In en, this message translates to:
  /// **'No conversations found'**
  String get noConversationsFound;

  /// Try different search hint
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// New chat title
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// Default chat title
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Start conversation title
  ///
  /// In en, this message translates to:
  /// **'Start a conversation'**
  String get startConversation;

  /// Send message to begin hint
  ///
  /// In en, this message translates to:
  /// **'Send a message to begin chatting with AI'**
  String get sendMessageToBegin;

  /// Delete conversation menu item
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation'**
  String get deleteConversation;

  /// Rename menu item
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// Copy menu item
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Message copied snackbar
  ///
  /// In en, this message translates to:
  /// **'Message copied'**
  String get messageCopied;

  /// Message deleted snackbar
  ///
  /// In en, this message translates to:
  /// **'Message deleted'**
  String get messageDeleted;

  /// Rename conversation dialog title
  ///
  /// In en, this message translates to:
  /// **'Rename Conversation'**
  String get renameConversation;

  /// Enter new title hint
  ///
  /// In en, this message translates to:
  /// **'Enter new title'**
  String get enterNewTitle;

  /// Conversation renamed snackbar
  ///
  /// In en, this message translates to:
  /// **'Conversation renamed'**
  String get conversationRenamed;

  /// Type a message hint
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// Forgot password screen title
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// Forgot password screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter your email or phone number to reset your password'**
  String get forgotPasswordSubtitle;

  /// Phone label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Phone number label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Enter phone number validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get enterPhoneNumber;

  /// Valid phone number validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get enterValidPhoneNumber;

  /// Verification code label
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// Enter verification code validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter verification code'**
  String get enterVerificationCode;

  /// Enter phone validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get enterPhone;

  /// Valid phone validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get enterValidPhone;

  /// Send verification code button
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendVerificationCode;

  /// Enter verification code title
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterVerificationCodeTitle;

  /// Verification code label
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCodeLabel;

  /// Verification code sent message
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification code to your account'**
  String get verificationCodeSent;

  /// Verification code sent to target message
  ///
  /// In en, this message translates to:
  /// **'Code sent to {target}'**
  String verificationCodeSentTo(Object target);

  /// Send verification code button
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// Resend verification code button
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// Resend countdown message
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(Object seconds);

  /// Code sent to account message
  ///
  /// In en, this message translates to:
  /// **'Code sent to: {account}'**
  String codeSentTo(Object account);

  /// Resend code countdown
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendCodeIn(Object seconds);

  /// Verification code expired error
  ///
  /// In en, this message translates to:
  /// **'Verification code has expired'**
  String get verificationCodeExpired;

  /// Invalid verification code message
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get verificationCodeInvalid;

  /// Avatar label
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// Choose avatar button
  ///
  /// In en, this message translates to:
  /// **'Choose Avatar'**
  String get chooseAvatar;

  /// Take photo option
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Choose from gallery option
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// Nickname label
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// Enter nickname validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your nickname'**
  String get enterNickname;

  /// Nickname min length validation message
  ///
  /// In en, this message translates to:
  /// **'Nickname must be at least 2 characters'**
  String get nicknameMinLength;

  /// Nickname max length validation message
  ///
  /// In en, this message translates to:
  /// **'Nickname must be at most 20 characters'**
  String get nicknameMaxLength;

  /// Password requirement hint
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters with letters and numbers'**
  String get passwordRequirement;

  /// Password strength validation message
  ///
  /// In en, this message translates to:
  /// **'Password must contain both letters and numbers'**
  String get passwordStrength;

  /// Region detected message
  ///
  /// In en, this message translates to:
  /// **'Region detected: {region}'**
  String regionDetected(Object region);

  /// China region name
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get chinaRegion;

  /// International region name
  ///
  /// In en, this message translates to:
  /// **'International'**
  String get internationalRegion;

  /// Verification successful message
  ///
  /// In en, this message translates to:
  /// **'Verification successful'**
  String get verificationSuccessful;

  /// Please verify account first message
  ///
  /// In en, this message translates to:
  /// **'Please verify your account first'**
  String get pleaseVerifyAccountFirst;

  /// Verify code button
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// Password min 8 characters validation message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength8;

  /// Verify button
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Set new password title
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// Create new password subtitle
  ///
  /// In en, this message translates to:
  /// **'Create a new password for your account'**
  String get createNewPassword;

  /// New password label
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Confirm new password label
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// Reset password button
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Password requirements title
  ///
  /// In en, this message translates to:
  /// **'Password Requirements'**
  String get passwordRequirements;

  /// Password minimum length requirement
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordMinLengthReq;

  /// Password complexity requirement
  ///
  /// In en, this message translates to:
  /// **'Must contain letters and numbers'**
  String get passwordComplexityReq;

  /// Password reset success title
  ///
  /// In en, this message translates to:
  /// **'Password Reset Successful'**
  String get passwordResetSuccess;

  /// Password reset success message
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset successfully. You can now log in with your new password.'**
  String get passwordResetSuccessMessage;

  /// Back to login button
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// Invalid verification code error
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get invalidVerificationCode;

  /// Enter verification code validation
  ///
  /// In en, this message translates to:
  /// **'Please enter verification code'**
  String get enterVerificationCodeHint;

  /// Verification code length validation
  ///
  /// In en, this message translates to:
  /// **'Verification code must be 6 digits'**
  String get verificationCodeLength;

  /// Passwords do not match error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatchError;

  /// AI Assistant section title
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// AI configuration screen title
  ///
  /// In en, this message translates to:
  /// **'AI Configuration'**
  String get aiConfiguration;

  /// No AI configuration empty state title
  ///
  /// In en, this message translates to:
  /// **'No AI Configuration'**
  String get noAIConfig;

  /// Add AI configuration hint
  ///
  /// In en, this message translates to:
  /// **'Add an AI model configuration to start chatting with AI'**
  String get addAIConfigHint;

  /// Add AI configuration button
  ///
  /// In en, this message translates to:
  /// **'Add AI Configuration'**
  String get addAIConfig;

  /// AI provider label
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// AI model label
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// Configuration name label
  ///
  /// In en, this message translates to:
  /// **'Configuration Name'**
  String get configName;

  /// Configuration name hint
  ///
  /// In en, this message translates to:
  /// **'e.g., My GPT-4'**
  String get configNameHint;

  /// API key label
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// API key hint
  ///
  /// In en, this message translates to:
  /// **'Enter your API key'**
  String get apiKeyHint;

  /// OpenAI API key help text
  ///
  /// In en, this message translates to:
  /// **'Get your API key from platform.openai.com/api-keys'**
  String get openAIKeyHelp;

  /// Claude API key help text
  ///
  /// In en, this message translates to:
  /// **'Get your API key from console.anthropic.com'**
  String get claudeKeyHelp;

  /// Name required validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get nameRequired;

  /// API key required validation
  ///
  /// In en, this message translates to:
  /// **'Please enter an API key'**
  String get apiKeyRequired;

  /// Invalid API key error
  ///
  /// In en, this message translates to:
  /// **'Invalid API key. Please check and try again.'**
  String get invalidApiKey;

  /// Configuration saved message
  ///
  /// In en, this message translates to:
  /// **'Configuration saved successfully'**
  String get configSaved;

  /// Delete configuration dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Configuration'**
  String get deleteConfig;

  /// Delete configuration confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteConfigConfirm(Object name);

  /// Default label badge
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// Set as default button
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefault;

  /// Export chat menu item
  ///
  /// In en, this message translates to:
  /// **'Export Chat'**
  String get exportChat;

  /// Chat exported message
  ///
  /// In en, this message translates to:
  /// **'Chat exported successfully'**
  String get chatExported;

  /// Export failed message
  ///
  /// In en, this message translates to:
  /// **'Failed to export chat'**
  String get exportFailed;

  /// Tokens used label
  ///
  /// In en, this message translates to:
  /// **'Tokens: {count}'**
  String tokensUsed(Object count);

  /// AI thinking indicator
  ///
  /// In en, this message translates to:
  /// **'AI is thinking...'**
  String get aiThinking;

  /// Configure AI prompt
  ///
  /// In en, this message translates to:
  /// **'Configure AI'**
  String get configureAI;

  /// No AI config message in chat
  ///
  /// In en, this message translates to:
  /// **'Please configure an AI model to start chatting'**
  String get noAIConfigMessage;

  /// Environment section title
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environmentSection;

  /// Custom API URL label
  ///
  /// In en, this message translates to:
  /// **'Custom API URL'**
  String get customApiUrl;

  /// Use default value
  ///
  /// In en, this message translates to:
  /// **'Use Default'**
  String get useDefault;

  /// API base URL hint
  ///
  /// In en, this message translates to:
  /// **'https://api.example.com'**
  String get apiBaseUrlHint;

  /// Reset to default button
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// Logging section title
  ///
  /// In en, this message translates to:
  /// **'Logging'**
  String get loggingSection;

  /// Enable logging toggle
  ///
  /// In en, this message translates to:
  /// **'Enable Logging'**
  String get enableLogging;

  /// Log level label
  ///
  /// In en, this message translates to:
  /// **'Log Level'**
  String get logLevel;

  /// Debug log level
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get logLevelDebug;

  /// Info log level
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get logLevelInfo;

  /// Warning log level
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get logLevelWarning;

  /// Error log level
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get logLevelError;

  /// No logging
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get logLevelNone;

  /// Debug tools section title
  ///
  /// In en, this message translates to:
  /// **'Debug Tools'**
  String get debugTools;

  /// Network logging toggle
  ///
  /// In en, this message translates to:
  /// **'Network Logging'**
  String get networkLogging;

  /// Network logging description
  ///
  /// In en, this message translates to:
  /// **'Log all network requests and responses'**
  String get networkLoggingDescription;

  /// Performance monitor toggle
  ///
  /// In en, this message translates to:
  /// **'Performance Monitor'**
  String get performanceMonitor;

  /// Performance monitor description
  ///
  /// In en, this message translates to:
  /// **'Show performance overlay'**
  String get performanceMonitorDescription;

  /// Show debug info toggle
  ///
  /// In en, this message translates to:
  /// **'Show Debug Info'**
  String get showDebugInfo;

  /// Show debug info description
  ///
  /// In en, this message translates to:
  /// **'Display debug information overlay'**
  String get showDebugInfoDescription;

  /// Cache and data section title
  ///
  /// In en, this message translates to:
  /// **'Cache & Data'**
  String get cacheAndData;

  /// Clear cache button
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// Clear cache description
  ///
  /// In en, this message translates to:
  /// **'Clear application cache data'**
  String get clearCacheDescription;

  /// Clear cache confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear the cache?'**
  String get clearCacheConfirm;

  /// Cache cleared success message
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheCleared;

  /// Clear database button
  ///
  /// In en, this message translates to:
  /// **'Clear Database'**
  String get clearDatabase;

  /// Clear database description
  ///
  /// In en, this message translates to:
  /// **'Delete all local data'**
  String get clearDatabaseDescription;

  /// Clear database confirmation message
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your local data. This action cannot be undone.'**
  String get clearDatabaseConfirm;

  /// Database cleared success message
  ///
  /// In en, this message translates to:
  /// **'Database cleared successfully'**
  String get databaseCleared;

  /// Reset options section title
  ///
  /// In en, this message translates to:
  /// **'Reset Options'**
  String get resetOptions;

  /// Reset to defaults button
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get resetToDefaults;

  /// Reset to defaults description
  ///
  /// In en, this message translates to:
  /// **'Restore all developer options to default values'**
  String get resetToDefaultsDescription;

  /// Reset to defaults confirmation message
  ///
  /// In en, this message translates to:
  /// **'This will reset all developer options to their default values.'**
  String get resetToDefaultsConfirm;

  /// Options reset success message
  ///
  /// In en, this message translates to:
  /// **'Options reset to defaults'**
  String get optionsReset;

  /// Operation failed message
  ///
  /// In en, this message translates to:
  /// **'Operation failed. Please try again.'**
  String get operationFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
