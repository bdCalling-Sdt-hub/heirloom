import '../views/auth/others_info_screen.dart';
import '../views/auth/password_changed_ui.dart';
import '../views/auth/select_age_screen.dart';
import '../views/home/notification/notification.dart';

import '../views/profile/journal/journal_screen.dart';
import '../views/profile/legacy/add_legacy_message_screen.dart';
import '../views/profile/legacy/legacy_message_view_screen.dart';
import '../views/profile/legacy/legacy_screen.dart';
import '../views/splash screen/onBoardingScreen.dart';
import 'exports.dart';

class AppRoutes {
  static const String splashScreen = "/SplashScreen";

  static const String signInScreen = "/SignInScreen";
  static const String signUpScreen = "/SignUpScreen";
  static const String emailPassScreen = "/EmailPassScreen";
  static const String otpVerificationScreen = "/OtpVerificationScreen";
  static const String resetPassScreen = "/ResetPassScreen";
  static const String passwordChangedUi = "/PasswordChangedUi";
  static const String customNavBar = "/CustomNavBar";
  static const String onboardingScreen = "/OnboardingScreen";
  static const String selectAgeScreen = "/SelectAgeScreen";
  static const String othersInfoScreen = "/OthersInfoScreen";
  static const String journalScreen = "/JournalScreen";
  static const String legacyScreen = "/LegacyScreen";
  static const String addLegacyMessageScreen = "/AddLegacyMessageScreen";
  static const String legacyMessageViewScreen = "/LegacyMessageViewScreen";





  static const String notificationScreen = "/NotificationScreen";

  static List<GetPage> get routes => [
        GetPage(name: splashScreen, page: () => const SplashScreen()),
        GetPage(name: onboardingScreen, page: () => const OnboardingScreen()),
        GetPage(name: signInScreen, page: () => SignInScreen()),

        GetPage(name: signUpScreen, page: () => SignUpScreen()),
        GetPage(name: emailPassScreen, page: () => EmailPassScreen()),
        GetPage(name: otpVerificationScreen, page: () => OtpVerificationScreen()),
        GetPage(name: resetPassScreen, page: () => ResetPassScreen()),
        GetPage(name: passwordChangedUi, page: () => PasswordChangedUi()),
        GetPage(name: customNavBar, page: () => const CustomNavBar()),

        GetPage(name: notificationScreen, page: () =>  NotificationScreen()),
        GetPage(name: selectAgeScreen, page: () =>  SelectAgeScreen()),
        GetPage(name: othersInfoScreen, page: () =>  OthersInfoScreen()),
        GetPage(name: journalScreen, page: () =>  JournalScreen()),
        GetPage(name: legacyScreen, page: () =>  LegacyScreen()),
        GetPage(name: addLegacyMessageScreen, page: () =>  AddLegacyMessageScreen()),
        GetPage(name: legacyMessageViewScreen, page: () =>  LegacyMessageViewScreen()),
      ];
}
