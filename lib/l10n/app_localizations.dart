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
