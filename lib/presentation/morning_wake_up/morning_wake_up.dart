import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dismissal_method_widget.dart';
import './widgets/play_oath_button_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/snooze_option_widget.dart';
import './widgets/why_statement_widget.dart';

class MorningWakeUp extends StatefulWidget {
  const MorningWakeUp({Key? key}) : super(key: key);

  @override
  State<MorningWakeUp> createState() => _MorningWakeUpState();
}

class _MorningWakeUpState extends State<MorningWakeUp>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _contentController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock user data
  final Map<String, dynamic> userData = {
    "userId": "user_001",
    "name": "Alex Johnson",
    "whyStatement":
        "I wake up early because I want to build the discipline to achieve my fitness goals and create a successful morning routine that sets the tone for productive days.",
    "oathAudioPath": "/storage/oath_recordings/alex_morning_oath.mp3",
    "dismissalMethod": "keyword", // keyword, fullTranscription, physicalCombo
    "targetKeyword": "commitment",
    "snoozeEnabled": true,
    "snoozeMinutes": 5,
    "alarmTime": "06:00 AM",
    "currentStreak": 12,
    "settings": {
      "requirePartialCompletion": true,
      "enableHapticFeedback": true,
      "volumeControlsEnabled": true,
    }
  };

  // State variables
  bool _isPlaying = false;
  bool _hasPlayedOnce = false;
  bool _showDismissalMethod = false;
  bool _alarmDismissed = false;
  int _currentStep = 1;
  final int _totalSteps = 3;
  final List<String> _stepLabels = ['Listen', 'Verify', 'Complete'];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _preventSystemNavigation();
    _startWakeUpSequence();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _backgroundController.forward();
    _contentController.forward();
  }

  void _preventSystemNavigation() {
    // Prevent system navigation gestures
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _startWakeUpSequence() {
    // Simulate alarm sound playing
    if ((userData["settings"]
            as Map<String, dynamic>)["enableHapticFeedback"] ==
        true) {
      HapticFeedback.heavyImpact();
    }
  }

  void _playOath() async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
    });

    // Simulate audio playback
    await Future.delayed(const Duration(seconds: 8));

    if (mounted) {
      setState(() {
        _isPlaying = false;
        _hasPlayedOnce = true;
        _showDismissalMethod = true;
        _currentStep = 2;
      });

      if ((userData["settings"]
              as Map<String, dynamic>)["enableHapticFeedback"] ==
          true) {
        HapticFeedback.lightImpact();
      }
    }
  }

  void _handleDismissalComplete() {
    setState(() {
      _currentStep = 3;
      _alarmDismissed = true;
    });

    if ((userData["settings"]
            as Map<String, dynamic>)["enableHapticFeedback"] ==
        true) {
      HapticFeedback.mediumImpact();
    }

    // Celebrate completion
    _showSuccessAnimation();
  }

  void _showSuccessAnimation() async {
    // Show success message briefly
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Navigate to morning routine dashboard
      Navigator.pushReplacementNamed(context, '/app-blocking-shield');
    }
  }

  void _handleSnooze() {
    if ((userData["settings"]
            as Map<String, dynamic>)["enableHapticFeedback"] ==
        true) {
      HapticFeedback.selectionClick();
    }

    // Simulate snooze functionality
    Navigator.pop(context);

    // In real implementation, this would reschedule the alarm
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Alarm snoozed for ${userData["snoozeMinutes"]} minutes',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  DismissalMethod _getDismissalMethod() {
    switch (userData["dismissalMethod"] as String) {
      case "fullTranscription":
        return DismissalMethod.fullTranscription;
      case "physicalCombo":
        return DismissalMethod.physicalCombo;
      default:
        return DismissalMethod.keyword;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0F1419).withValues(alpha: 0.95),
                    const Color(0xFF1A1F2E).withValues(alpha: 0.9),
                    const Color(0xFF2D3748).withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: SafeArea(
                child: AnimatedBuilder(
                  animation: _contentController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: _buildContent(),
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

  Widget _buildContent() {
    if (_alarmDismissed) {
      return _buildSuccessContent();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        children: [
          // Header
          _buildHeader(),

          SizedBox(height: 4.h),

          // Progress Indicator
          ProgressIndicatorWidget(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
            stepLabels: _stepLabels,
          ),

          SizedBox(height: 4.h),

          // Why Statement
          WhyStatementWidget(
            whyStatement: userData["whyStatement"] as String,
          ),

          SizedBox(height: 4.h),

          // Play Oath Button
          PlayOathButtonWidget(
            onPressed: _playOath,
            isPlaying: _isPlaying,
            hasPlayedOnce: _hasPlayedOnce,
          ),

          SizedBox(height: 4.h),

          // Dismissal Method (shown after oath is played)
          if (_showDismissalMethod) ...[
            DismissalMethodWidget(
              method: _getDismissalMethod(),
              onDismissalComplete: _handleDismissalComplete,
              targetKeyword: userData["targetKeyword"] as String,
            ),
            SizedBox(height: 3.h),
          ],

          // Snooze Option (if enabled and oath hasn't been played yet)
          if (userData["snoozeEnabled"] == true &&
              (!_hasPlayedOnce ||
                  !(userData["settings"] as Map<String, dynamic>)[
                      "requirePartialCompletion"])) ...[
            SnoozeOptionWidget(
              isEnabled: true,
              onSnooze: _handleSnooze,
              snoozeMinutes: userData["snoozeMinutes"] as int,
              requiresPartialCompletion: (userData["settings"]
                  as Map<String, dynamic>)["requirePartialCompletion"] as bool,
            ),
            SizedBox(height: 2.h),
          ],

          // Footer info
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning,',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  userData["name"] as String,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'local_fire_department',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${userData["currentStreak"]} days',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Alarm: ${userData["alarmTime"]}',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info_outline',
                color: Colors.white.withValues(alpha: 0.6),
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'This alarm cannot be dismissed until you complete your commitment verification.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          if ((userData["settings"]
                  as Map<String, dynamic>)["volumeControlsEnabled"] ==
              true) ...[
            SizedBox(height: 1.h),
            Text(
              'Volume controls remain available for accessibility',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 10.w,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Commitment Verified!',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'Your morning routine awaits...',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Container(
            width: 80.w,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'local_fire_department',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 6.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Streak: ${userData["currentStreak"] + 1} Days',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Another day of commitment achieved!',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _contentController.dispose();

    // Restore system navigation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }
}
