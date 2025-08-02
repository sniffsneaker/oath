import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/countdown_timer_widget.dart';
import './widgets/motivational_message_widget.dart';
import './widgets/why_statement_card_widget.dart';

class AppBlockingShield extends StatefulWidget {
  const AppBlockingShield({Key? key}) : super(key: key);

  @override
  State<AppBlockingShield> createState() => _AppBlockingShieldState();
}

class _AppBlockingShieldState extends State<AppBlockingShield>
    with TickerProviderStateMixin {
  late AnimationController _backgroundAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideInAnimation;

  Timer? _blockingTimer;
  Duration _remainingTime = const Duration(minutes: 45);
  bool _emergencyBypassEnabled = true;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "userName": "Alex",
    "primaryGoal": "Building Consistent Morning Habits",
    "whyStatement":
        "I want to start each day with intention and purpose because when I have a structured morning routine, I feel more confident, focused, and ready to tackle my goals. My future success depends on the discipline I build today.",
    "currentStreak": 12,
    "weeklyProgress": 5,
    "successRate": 86,
    "blockedApps": ["Instagram", "TikTok", "Twitter", "YouTube", "Facebook"],
    "blockingDuration": 45, // minutes
    "emergencyBypassEnabled": true,
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startBlockingTimer();
    _preventBackNavigation();
  }

  void _initializeAnimations() {
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.linear,
    ));

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideInAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));

    _backgroundAnimationController.repeat();
    _contentAnimationController.forward();
  }

  void _startBlockingTimer() {
    _blockingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        });
      } else {
        _onBlockingComplete();
      }
    });
  }

  void _preventBackNavigation() {
    // Prevent back navigation during blocking
    SystemChannels.platform.setMethodCallHandler((call) async {
      if (call.method == 'SystemNavigator.pop') {
        _showBlockingMessage();
        return;
      }
      return null;
    });
  }

  void _showBlockingMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'block',
              color: AppTheme.lightTheme.colorScheme.onError,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Complete your morning routine to unlock apps',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onError,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onBlockingComplete() {
    _blockingTimer?.cancel();
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'celebration',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 12.w,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Blocking Complete!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                'Great job staying focused! Your apps are now unlocked.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      height: 1.4,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/morning-wake-up');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onReturnToRoutine() {
    Navigator.pushReplacementNamed(context, '/morning-wake-up');
  }

  void _onEmergencyBypass() {
    _blockingTimer?.cancel();

    // Log emergency bypass event
    _logEmergencyBypass();

    // Show bypass confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.onError,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Emergency bypass activated. Streak broken.',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onError,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 5),
      ),
    );

    // Navigate back after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/morning-wake-up');
      }
    });
  }

  void _logEmergencyBypass() {
    // In a real app, this would log to analytics/database
    debugPrint('Emergency bypass used at ${DateTime.now()}');
    debugPrint('User: ${_userData["userName"]}');
    debugPrint('Remaining time: ${_remainingTime.inMinutes} minutes');
  }

  @override
  void dispose() {
    _blockingTimer?.cancel();
    _backgroundAnimationController.dispose();
    _contentAnimationController.dispose();
    SystemChannels.platform.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showBlockingMessage();
        return false;
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.colorScheme.surface,
                    AppTheme.lightTheme.primaryColor.withValues(
                        alpha: 0.05 + (0.05 * _backgroundAnimation.value)),
                    AppTheme.lightTheme.colorScheme.secondary.withValues(
                        alpha: 0.03 + (0.02 * _backgroundAnimation.value)),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
              child: SafeArea(
                child: AnimatedBuilder(
                  animation: _contentAnimationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SlideTransition(
                        position: _slideInAnimation,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Column(
                              children: [
                                // Header with shield icon
                                Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.lightTheme.primaryColor
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme.lightTheme.primaryColor
                                          .withValues(alpha: 0.2),
                                      width: 2,
                                    ),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'shield',
                                    color: AppTheme.lightTheme.primaryColor,
                                    size: 10.w,
                                  ),
                                ),

                                SizedBox(height: 3.h),

                                // Title
                                Text(
                                  'App Blocking Active',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: AppTheme.lightTheme.primaryColor,
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                  textAlign: TextAlign.center,
                                ),

                                SizedBox(height: 1.h),

                                // Subtitle
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Text(
                                    'Stay focused on your morning routine. Distracting apps are temporarily blocked.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                          fontSize: 15.sp,
                                          height: 1.4,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                SizedBox(height: 5.h),

                                // Countdown Timer
                                CountdownTimerWidget(
                                  remainingTime: _remainingTime,
                                  onTimerComplete: _onBlockingComplete,
                                ),

                                SizedBox(height: 5.h),

                                // Why Statement Card
                                WhyStatementCardWidget(
                                  whyStatement: _userData["whyStatement"] as String,
                                  userName: _userData["userName"] as String,
                                ),

                                SizedBox(height: 4.h),

                                // Motivational Message
                                MotivationalMessageWidget(
                                  userName: _userData["userName"] as String,
                                  primaryGoal: _userData["primaryGoal"] as String,
                                ),

                                SizedBox(height: 5.h),

                                // Action Buttons
                                ActionButtonsWidget(
                                  onReturnToRoutine: _onReturnToRoutine,
                                  onEmergencyBypass: _onEmergencyBypass,
                                  emergencyBypassEnabled: _emergencyBypassEnabled,
                                ),

                                SizedBox(height: 4.h),

                                // Blocked apps indicator
                                Container(
                                  width: 85.w,
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.lightTheme.colorScheme.surface
                                        .withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppTheme.lightTheme.colorScheme.outline
                                          .withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomIconWidget(
                                            iconName: 'block',
                                            color: AppTheme
                                                .lightTheme.colorScheme.error,
                                            size: 4.w,
                                          ),
                                          SizedBox(width: 2.w),
                                          Text(
                                            'Blocked Apps',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: AppTheme
                                                      .lightTheme.colorScheme.error,
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2.h),
                                      Wrap(
                                        spacing: 2.w,
                                        runSpacing: 1.h,
                                        children: (_userData["blockedApps"]
                                                as List<String>)
                                            .map((app) {
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 3.w, vertical: 1.h),
                                            decoration: BoxDecoration(
                                              color: AppTheme
                                                  .lightTheme.colorScheme.error
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: AppTheme
                                                    .lightTheme.colorScheme.error
                                                    .withValues(alpha: 0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              app,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: AppTheme.lightTheme
                                                        .colorScheme.error,
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 2.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}