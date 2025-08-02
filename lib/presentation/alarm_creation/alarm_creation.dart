import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_blocking_widget.dart';
import './widgets/dismissal_method_widget.dart';
import './widgets/repeat_options_widget.dart';
import './widgets/time_picker_widget.dart';
import './widgets/voice_recording_widget.dart';
import './widgets/why_statement_widget.dart';

class AlarmCreation extends StatefulWidget {
  const AlarmCreation({Key? key}) : super(key: key);

  @override
  State<AlarmCreation> createState() => _AlarmCreationState();
}

class _AlarmCreationState extends State<AlarmCreation> {
  // Form state variables
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedRepeatOption = 'Daily';
  String? _recordingPath;
  String _whyStatement = '';
  String _selectedDismissalMethod = 'keyword';
  bool _appBlockingEnabled = false;
  int _blockingDuration = 60;
  List<String> _blockedApps = [];

  // Form validation
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    // Set default time to 7:00 AM
    _selectedTime = const TimeOfDay(hour: 7, minute: 0);
  }

  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  bool _isFormValid() {
    return _recordingPath != null && _whyStatement.trim().isNotEmpty;
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Unsaved Changes',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            content: Text(
              'You have unsaved changes. Are you sure you want to leave?',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Leave',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _saveAlarm() {
    if (!_isFormValid()) {
      Fluttertoast.showToast(
        msg: "Please complete all required fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: AppTheme.lightTheme.colorScheme.onError,
      );
      return;
    }

    // Simulate saving alarm
    final alarmData = {
      'time': _selectedTime,
      'repeat': _selectedRepeatOption,
      'recording': _recordingPath,
      'whyStatement': _whyStatement,
      'dismissalMethod': _selectedDismissalMethod,
      'appBlocking': _appBlockingEnabled,
      'blockingDuration': _blockingDuration,
      'blockedApps': _blockedApps,
      'createdAt': DateTime.now(),
    };

    // Show success message
    Fluttertoast.showToast(
      msg: "Alarm created successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      textColor: AppTheme.lightTheme.colorScheme.onTertiary,
    );

    // Navigate back to dashboard
    Navigator.pushReplacementNamed(context, '/morning-wake-up');
  }

  void _cancelCreation() async {
    if (await _onWillPop()) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Create Alarm',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            onPressed: _cancelCreation,
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isFormValid() ? _saveAlarm : null,
              child: Text(
                'Save',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: _isFormValid()
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 2.w),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Picker Section
                TimePickerWidget(
                  selectedTime: _selectedTime,
                  onTimeChanged: (time) {
                    setState(() {
                      _selectedTime = time;
                    });
                    _markAsChanged();
                  },
                ),

                SizedBox(height: 3.h),

                // Repeat Options Section
                RepeatOptionsWidget(
                  selectedOption: _selectedRepeatOption,
                  onOptionChanged: (option) {
                    setState(() {
                      _selectedRepeatOption = option;
                    });
                    _markAsChanged();
                  },
                ),

                SizedBox(height: 3.h),

                // Voice Recording Section
                VoiceRecordingWidget(
                  recordingPath: _recordingPath,
                  onRecordingChanged: (path) {
                    setState(() {
                      _recordingPath = path;
                    });
                    _markAsChanged();
                  },
                ),

                SizedBox(height: 3.h),

                // Why Statement Section
                WhyStatementWidget(
                  whyStatement: _whyStatement,
                  onStatementChanged: (statement) {
                    setState(() {
                      _whyStatement = statement;
                    });
                    _markAsChanged();
                  },
                ),

                SizedBox(height: 3.h),

                // Dismissal Method Section
                DismissalMethodWidget(
                  selectedMethod: _selectedDismissalMethod,
                  onMethodChanged: (method) {
                    setState(() {
                      _selectedDismissalMethod = method;
                    });
                    _markAsChanged();
                  },
                ),

                SizedBox(height: 3.h),

                // App Blocking Section
                AppBlockingWidget(
                  isEnabled: _appBlockingEnabled,
                  duration: _blockingDuration,
                  blockedApps: _blockedApps,
                  onToggleChanged: (enabled) {
                    setState(() {
                      _appBlockingEnabled = enabled;
                    });
                    _markAsChanged();
                  },
                  onDurationChanged: (duration) {
                    setState(() {
                      _blockingDuration = duration;
                    });
                    _markAsChanged();
                  },
                  onAppsChanged: (apps) {
                    setState(() {
                      _blockedApps = apps;
                    });
                    _markAsChanged();
                  },
                ),

                SizedBox(height: 4.h),

                // Save Button (Full Width)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid() ? _saveAlarm : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid()
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.3),
                      foregroundColor: _isFormValid()
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.5),
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: _isFormValid() ? 4 : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'alarm_add',
                          color: _isFormValid()
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                          size: 6.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Create Commitment Alarm',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: _isFormValid()
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Form Validation Hint
                !_isFormValid()
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'info',
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Complete these steps to create your alarm:',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  if (_recordingPath == null)
                                    Text(
                                      '• Record your voice commitment',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  if (_whyStatement.trim().isEmpty)
                                    Text(
                                      '• Write why this commitment is important',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
