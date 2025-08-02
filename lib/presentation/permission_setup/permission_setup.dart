import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/permission_card_widget.dart';
import './widgets/permission_explanation_widget.dart';
import './widgets/progress_indicator_widget.dart';

class PermissionSetup extends StatefulWidget {
  const PermissionSetup({Key? key}) : super(key: key);

  @override
  State<PermissionSetup> createState() => _PermissionSetupState();
}

class _PermissionSetupState extends State<PermissionSetup> {
  final Map<String, permission_handler.PermissionStatus> _permissionStatuses = {
    'microphone': permission_handler.PermissionStatus.denied,
    'notification': permission_handler.PermissionStatus.denied,
    'camera': permission_handler.PermissionStatus.denied,
    'storage': permission_handler.PermissionStatus.denied,
    'system_alert_window': permission_handler.PermissionStatus.denied,
  };

  final List<Map<String, dynamic>> _permissionData = [
    {
      'key': 'microphone',
      'icon': 'mic',
      'title': 'Microphone Access',
      'description':
          'Record your daily commitments and voice oaths to create personalized accountability reminders.',
      'critical': true,
      'permission': permission_handler.Permission.microphone,
    },
    {
      'key': 'notification',
      'icon': 'notifications',
      'title': 'Notifications',
      'description':
          'Receive morning alarms and evening preparation reminders to maintain your routine consistency.',
      'critical': true,
      'permission': permission_handler.Permission.notification,
    },
    {
      'key': 'camera',
      'icon': 'camera_alt',
      'title': 'Camera Access',
      'description':
          'Scan QR codes for advanced alarm dismissal challenges that ensure you\'re fully awake.',
      'critical': false,
      'permission': permission_handler.Permission.camera,
    },
    {
      'key': 'storage',
      'icon': 'storage',
      'title': 'Storage Access',
      'description':
          'Save your voice recordings and maintain your commitment history for streak tracking.',
      'critical': true,
      'permission': permission_handler.Permission.storage,
    },
    {
      'key': 'system_alert_window',
      'icon': 'block',
      'title': 'App Blocking Overlay',
      'description':
          'Display blocking screens over distracting apps during your morning routine focus time.',
      'critical': true,
      'permission': permission_handler.Permission.systemAlertWindow,
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkAllPermissions();
  }

  Future<void> _checkAllPermissions() async {
    if (kIsWeb) {
      // Web platform - simulate granted status for supported features
      setState(() {
        _permissionStatuses['microphone'] =
            permission_handler.PermissionStatus.granted;
        _permissionStatuses['notification'] =
            permission_handler.PermissionStatus.granted;
        _permissionStatuses['camera'] =
            permission_handler.PermissionStatus.granted;
        _permissionStatuses['storage'] =
            permission_handler.PermissionStatus.granted;
        _permissionStatuses['system_alert_window'] =
            permission_handler.PermissionStatus.denied; // Not supported on web
      });
      return;
    }

    for (final permissionData in _permissionData) {
      try {
        final permission =
            permissionData['permission'] as permission_handler.Permission;
        final status = await permission.status;
        setState(() {
          _permissionStatuses[permissionData['key']] =
              _convertPermissionStatus(status);
        });
      } catch (e) {
        // Handle unsupported permissions gracefully
        setState(() {
          _permissionStatuses[permissionData['key']] =
              permission_handler.PermissionStatus.denied;
        });
      }
    }
  }

  permission_handler.PermissionStatus _convertPermissionStatus(
      permission_handler.PermissionStatus status) {
    switch (status) {
      case permission_handler.PermissionStatus.granted:
        return permission_handler.PermissionStatus.granted;
      case permission_handler.PermissionStatus.denied:
      case permission_handler.PermissionStatus.permanentlyDenied:
      case permission_handler.PermissionStatus.restricted:
        return permission_handler.PermissionStatus.denied;
      default:
        return permission_handler.PermissionStatus.denied;
    }
  }

  PermissionStatus _convertToCustomPermissionStatus(
      permission_handler.PermissionStatus status) {
    switch (status) {
      case permission_handler.PermissionStatus.granted:
        return PermissionStatus.granted;
      case permission_handler.PermissionStatus.denied:
      case permission_handler.PermissionStatus.permanentlyDenied:
      case permission_handler.PermissionStatus.restricted:
        return PermissionStatus.denied;
      default:
        return PermissionStatus.pending;
    }
  }

  Future<void> _requestPermission(String permissionKey) async {
    if (kIsWeb) {
      // Web platform - handle browser permissions
      await _handleWebPermission(permissionKey);
      return;
    }

    final permissionData = _permissionData.firstWhere(
      (data) => data['key'] == permissionKey,
    );

    try {
      final permission =
          permissionData['permission'] as permission_handler.Permission;
      final status = await permission.request();

      setState(() {
        _permissionStatuses[permissionKey] = _convertPermissionStatus(status);
      });

      if (status.isPermanentlyDenied) {
        _showPermissionDeniedDialog(permissionData['title']);
      }
    } catch (e) {
      // Handle permission request errors
      setState(() {
        _permissionStatuses[permissionKey] =
            permission_handler.PermissionStatus.denied;
      });
    }
  }

  Future<void> _handleWebPermission(String permissionKey) async {
    // Simulate web permission handling
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      if (permissionKey == 'system_alert_window') {
        _permissionStatuses[permissionKey] =
            permission_handler.PermissionStatus.denied;
      } else {
        _permissionStatuses[permissionKey] =
            permission_handler.PermissionStatus.granted;
      }
    });
  }

  void _showPermissionDeniedDialog(String permissionTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Permission Required',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            '$permissionTitle permission is required for Oath to function properly. Please enable it in your device settings.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                permission_handler.openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  int get _grantedCount {
    return _permissionStatuses.values
        .where(
            (status) => status == permission_handler.PermissionStatus.granted)
        .length;
  }

  int get _criticalGrantedCount {
    return _permissionData
        .where((data) => data['critical'] == true)
        .where((data) =>
            _permissionStatuses[data['key']] ==
            permission_handler.PermissionStatus.granted)
        .length;
  }

  int get _criticalTotalCount {
    return _permissionData.where((data) => data['critical'] == true).length;
  }

  bool get _canContinue {
    return _criticalGrantedCount >=
        (_criticalTotalCount -
            1); // Allow one critical permission to be missing
  }

  void _navigateToNextScreen() {
    if (_canContinue) {
      Navigator.pushReplacementNamed(context, '/alarm-creation');
    }
  }

  void _navigateBack() {
    Navigator.pushReplacementNamed(context, '/onboarding-flow');
  }

  void _navigateToMainApp() {
    Navigator.pushReplacementNamed(context, AppRoutes.mainNavigation);
  }

  Future<void> _requestPermissions() async {
    if (kIsWeb) {
      // Web platform - handle browser permissions
      await _handleWebPermission('system_alert_window');
      return;
    }

    final permissionData = _permissionData.firstWhere(
      (data) => data['key'] == 'system_alert_window',
    );

    try {
      final permission =
          permissionData['permission'] as permission_handler.Permission;
      final status = await permission.request();

      setState(() {
        _permissionStatuses['system_alert_window'] = _convertPermissionStatus(status);
      });

      if (status.isPermanentlyDenied) {
        _showPermissionDeniedDialog(permissionData['title']);
      }
    } catch (e) {
      // Handle permission request errors
      setState(() {
        _permissionStatuses['system_alert_window'] =
            permission_handler.PermissionStatus.denied;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Permission Setup',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          onPressed: _navigateBack,
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimaryLight,
            size: 6.w,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Progress Indicator
                    ProgressIndicatorWidget(
                      completedCount: _grantedCount,
                      totalCount: _permissionData.length,
                    ),

                    SizedBox(height: 2.h),

                    // Permission Explanation
                    PermissionExplanationWidget(
                      title: 'Why We Need These Permissions',
                      description:
                          'Oath requires specific device permissions to create an effective self-accountability system that helps you build consistent morning routines.',
                      benefits: [
                        'Record personalized voice commitments',
                        'Block distracting apps during focus time',
                        'Send timely reminders and alarms',
                        'Track your consistency and progress',
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Permission Cards
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _permissionData.length,
                      itemBuilder: (context, index) {
                        final permission = _permissionData[index];
                        final status = _permissionStatuses[permission['key']] ??
                            permission_handler.PermissionStatus.denied;

                        return PermissionCardWidget(
                          iconName: permission['icon'],
                          title: permission['title'],
                          description: permission['description'],
                          status: _convertToCustomPermissionStatus(status),
                          onGrantPressed: () =>
                              _requestPermission(permission['key']),
                        );
                      },
                    ),

                    SizedBox(height: 4.h),

                    // Alternative Solutions Info
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryLight.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.secondaryLight.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'lightbulb_outline',
                                color: AppTheme.secondaryLight,
                                size: 5.w,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'Alternative Options',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.secondaryLight,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Some features can work with limited permissions, but the full Oath experience requires all critical permissions. You can always enable them later in your device settings.',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.textSecondaryLight,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h), // Space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_canContinue) ...[
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'warning',
                        color: AppTheme.secondaryLight,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Grant critical permissions to continue',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.secondaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canContinue ? _navigateToNextScreen : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canContinue
                        ? AppTheme.primaryLight
                        : AppTheme.textDisabledLight,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _canContinue
                        ? 'Continue to Alarm Setup'
                        : 'Grant Permissions to Continue',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}