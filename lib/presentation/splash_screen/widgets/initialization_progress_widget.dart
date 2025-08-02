import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class InitializationProgressWidget extends StatefulWidget {
  final Function(String) onProgressUpdate;
  final VoidCallback onInitializationComplete;

  const InitializationProgressWidget({
    Key? key,
    required this.onProgressUpdate,
    required this.onInitializationComplete,
  }) : super(key: key);

  @override
  State<InitializationProgressWidget> createState() =>
      _InitializationProgressWidgetState();
}

class _InitializationProgressWidgetState
    extends State<InitializationProgressWidget> {
  final List<Map<String, dynamic>> _initializationSteps = [
    {
      'message': 'Checking authentication...',
      'duration': 800,
      'key': 'auth',
    },
    {
      'message': 'Loading preferences...',
      'duration': 600,
      'key': 'preferences',
    },
    {
      'message': 'Verifying permissions...',
      'duration': 700,
      'key': 'permissions',
    },
    {
      'message': 'Preparing audio cache...',
      'duration': 900,
      'key': 'audio',
    },
    {
      'message': 'Ready to begin...',
      'duration': 400,
      'key': 'complete',
    },
  ];

  int _currentStepIndex = 0;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _startInitialization();
  }

  Future<void> _startInitialization() async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
    });

    for (int i = 0; i < _initializationSteps.length; i++) {
      final step = _initializationSteps[i];

      setState(() {
        _currentStepIndex = i;
      });

      widget.onProgressUpdate(step['message'] as String);

      // Simulate real initialization tasks
      await Future.delayed(Duration(milliseconds: step['duration'] as int));

      // Perform actual initialization based on step
      await _performInitializationStep(step['key'] as String);
    }

    widget.onInitializationComplete();
  }

  Future<void> _performInitializationStep(String stepKey) async {
    switch (stepKey) {
      case 'auth':
        // Check if user is authenticated
        await _checkAuthenticationStatus();
        break;
      case 'preferences':
        // Load user preferences from storage
        await _loadUserPreferences();
        break;
      case 'permissions':
        // Verify required permissions
        await _verifyPermissions();
        break;
      case 'audio':
        // Prepare audio cache and validate files
        await _prepareAudioCache();
        break;
      case 'complete':
        // Final setup completion
        await _finalizeSetup();
        break;
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate authentication check
    // In real implementation, check SharedPreferences or secure storage
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences
    // In real implementation, load from SharedPreferences
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> _verifyPermissions() async {
    // Simulate permission verification
    // In real implementation, check microphone, notification, and other permissions
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> _prepareAudioCache() async {
    // Simulate audio cache preparation
    // In real implementation, validate cached audio files and prepare playback
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> _finalizeSetup() async {
    // Simulate final setup
    // In real implementation, complete any remaining initialization
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: (_currentStepIndex + 1) / _initializationSteps.length,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.secondary,
            ),
            minHeight: 0.5.h,
          ),
          SizedBox(height: 2.h),
          Text(
            _currentStepIndex < _initializationSteps.length
                ? _initializationSteps[_currentStepIndex]['message'] as String
                : 'Initialization complete',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
