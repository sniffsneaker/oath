import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/morning_wake_up/morning_wake_up.dart';
import '../presentation/permission_setup/permission_setup.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/app_blocking_shield/app_blocking_shield.dart';
import '../presentation/alarm_creation/alarm_creation.dart';
import '../presentation/main_navigation/main_navigation_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String morningWakeUp = '/morning-wake-up';
  static const String permissionSetup = '/permission-setup';
  static const String onboardingFlow = '/onboarding-flow';
  static const String appBlockingShield = '/app-blocking-shield';
  static const String alarmCreation = '/alarm-creation';
  static const String mainNavigation = '/main-navigation';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    morningWakeUp: (context) => const MorningWakeUp(),
    permissionSetup: (context) => const PermissionSetup(),
    onboardingFlow: (context) => const OnboardingFlow(),
    appBlockingShield: (context) => const AppBlockingShield(),
    alarmCreation: (context) => const AlarmCreation(),
    mainNavigation: (context) => const MainNavigationScreen(),
    // TODO: Add your other routes here
  };
}
