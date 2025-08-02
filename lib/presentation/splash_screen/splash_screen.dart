import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import './widgets/animated_logo_widget.dart';
import './widgets/background_gradient_widget.dart';
import './widgets/initialization_progress_widget.dart';
import './widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _showLogo = false;
  bool _showProgress = false;
  String _currentLoadingText = 'Initializing...';
  bool _isInitializationComplete = false;

  // Mock user data for navigation logic
  final Map<String, dynamic> _mockUserData = {
    'isFirstTime': true, // Set to false to simulate returning user
    'hasCompletedOnboarding': false,
    'hasRequiredPermissions': false,
    'hasActiveAlarms': false,
  };

  @override
  void initState() {
    super.initState();
    _initializeSplashSequence();
  }

  Future<void> _initializeSplashSequence() async {
    // Hide system status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Start logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _showLogo = true;
      });
    }

    // Show progress after logo animation
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _showProgress = true;
      });
    }
  }

  void _onProgressUpdate(String message) {
    if (mounted) {
      setState(() {
        _currentLoadingText = message;
      });
    }
  }

  void _onInitializationComplete() {
    if (mounted) {
      setState(() {
        _isInitializationComplete = true;
      });
      _navigateToNextScreen();
    }
  }

  void _onLogoAnimationComplete() {
    // Logo animation completed, initialization will continue
  }

  Future<void> _navigateToNextScreen() async {
    // Restore system UI before navigation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Add slight delay for smooth transition
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Navigation logic based on user state
    String targetRoute = _determineNavigationRoute();

    Navigator.pushReplacementNamed(context, targetRoute);
  }

  String _determineNavigationRoute() {
    // Check if user is new or returning
    if (_mockUserData['isFirstTime'] == true) {
      return '/onboarding-flow';
    }

    // Check if user has completed onboarding
    if (_mockUserData['hasCompletedOnboarding'] == false) {
      return '/onboarding-flow';
    }

    // Check if user has required permissions
    if (_mockUserData['hasRequiredPermissions'] == false) {
      return '/permission-setup';
    }

    // Check if user has active alarms
    if (_mockUserData['hasActiveAlarms'] == false) {
      return '/alarm-creation';
    }

    // Default to morning wake-up for existing users with setup complete
    return '/morning-wake-up';
  }

  @override
  void dispose() {
    // Ensure system UI is restored
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradientWidget(
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _showLogo
                            ? AnimatedLogoWidget(
                                onAnimationComplete: _onLogoAnimationComplete,
                              )
                            : Container(
                                height: 35.h,
                              ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _showProgress
                          ? InitializationProgressWidget(
                              onProgressUpdate: _onProgressUpdate,
                              onInitializationComplete:
                                  _onInitializationComplete,
                            )
                          : Container(),
                      SizedBox(height: 4.h),
                      LoadingIndicatorWidget(
                        loadingText: _currentLoadingText,
                        isVisible: _showProgress,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
