import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onReturnToRoutine;
  final VoidCallback? onEmergencyBypass;
  final bool emergencyBypassEnabled;

  const ActionButtonsWidget({
    Key? key,
    required this.onReturnToRoutine,
    this.onEmergencyBypass,
    this.emergencyBypassEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 85.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(children: [
          // Primary action button
          SizedBox(
              width: double.infinity,
              height: 7.h,
              child: ElevatedButton(
                  onPressed: onReturnToRoutine,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      elevation: 4,
                      shadowColor: AppTheme.lightTheme.colorScheme.shadow
                          .withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                            iconName: 'arrow_back',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 5.w),
                        SizedBox(width: 3.w),
                        Text('Return to Morning Routine',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600)),
                      ]))),

          SizedBox(height: 3.h),

          // Secondary helpful actions
          Row(children: [
            Expanded(
                child: Container(
                    height: 6.h,
                    child: OutlinedButton(
                        onPressed: () => _showProgressDialog(context),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.lightTheme.primaryColor,
                            side: BorderSide(
                                color: AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.3),
                                width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                  iconName: 'timeline',
                                  color: AppTheme.lightTheme.primaryColor,
                                  size: 4.w),
                              SizedBox(width: 2.w),
                              Text('Progress',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color:
                                              AppTheme.lightTheme.primaryColor,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500)),
                            ])))),
            SizedBox(width: 3.w),
            Expanded(
                child: Container(
                    height: 6.h,
                    child: OutlinedButton(
                        onPressed: () => _showTipsDialog(context),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                  iconName: 'lightbulb', size: 4.w),
                              SizedBox(width: 2.w),
                              Text('Tips',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500)),
                            ])))),
          ]),

          // Emergency bypass button (if enabled)
          emergencyBypassEnabled
              ? Column(children: [
                  SizedBox(height: 4.h),
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.error
                              .withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.error
                                  .withValues(alpha: 0.2),
                              width: 1)),
                      child: Column(children: [
                        Row(children: [
                          CustomIconWidget(
                              iconName: 'warning',
                              color: AppTheme.lightTheme.colorScheme.error,
                              size: 4.w),
                          SizedBox(width: 2.w),
                          Text('Emergency Access',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      color:
                                          AppTheme.lightTheme.colorScheme.error,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600)),
                        ]),
                        SizedBox(height: 2.h),
                        Text(
                            'Only use in genuine emergencies. This will be logged and may affect your streak.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    fontSize: 11.sp,
                                    height: 1.4),
                            textAlign: TextAlign.center),
                        SizedBox(height: 2.h),
                        SizedBox(
                            width: double.infinity,
                            height: 5.h,
                            child: TextButton(
                                onPressed: () =>
                                    _showEmergencyBypassDialog(context),
                                style: TextButton.styleFrom(
                                    foregroundColor:
                                        AppTheme.lightTheme.colorScheme.error,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                child: Text('Emergency Bypass',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: AppTheme
                                                .lightTheme.colorScheme.error,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500)))),
                      ])),
                ])
              : const SizedBox.shrink(),
        ]));
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Row(children: [
                CustomIconWidget(
                    iconName: 'timeline',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w),
                SizedBox(width: 3.w),
                Text('Your Progress',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600)),
              ]),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                _buildProgressItem(context, 'Current Streak', '12 days',
                    'local_fire_department'),
                SizedBox(height: 2.h),
                _buildProgressItem(
                    context, 'This Week', '5/7 days', 'calendar_today'),
                SizedBox(height: 2.h),
                _buildProgressItem(
                    context, 'Success Rate', '86%', 'trending_up'),
              ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close',
                        style: TextStyle(
                            color: AppTheme.lightTheme.primaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500))),
              ]);
        });
  }

  Widget _buildProgressItem(
      BuildContext context, String label, String value, String iconName) {
    return Row(children: [
      CustomIconWidget(iconName: iconName, size: 5.w),
      SizedBox(width: 3.w),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 12.sp)),
        Text(value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600)),
      ])),
    ]);
  }

  void _showTipsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Row(children: [
                CustomIconWidget(iconName: 'lightbulb', size: 6.w),
                SizedBox(width: 3.w),
                Text('Morning Tips',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18.sp, fontWeight: FontWeight.w600)),
              ]),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTipItem(
                        context, 'Take 3 deep breaths to center yourself'),
                    _buildTipItem(context, 'Drink a glass of water to hydrate'),
                    _buildTipItem(
                        context, 'Stretch for 30 seconds to wake up your body'),
                    _buildTipItem(
                        context, 'Think of one thing you\'re grateful for'),
                  ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Got it!',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w500))),
              ]);
        });
  }

  Widget _buildTipItem(BuildContext context, String tip) {
    return Padding(
        padding: EdgeInsets.only(bottom: 1.5.h),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              margin: EdgeInsets.only(top: 0.5.h),
              width: 1.5.w,
              height: 1.5.w,
              decoration: BoxDecoration(shape: BoxShape.circle)),
          SizedBox(width: 3.w),
          Expanded(
              child: Text(tip,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontSize: 14.sp,
                      height: 1.4))),
        ]));
  }

  void _showEmergencyBypassDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Row(children: [
                CustomIconWidget(
                    iconName: 'warning',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 6.w),
                SizedBox(width: 3.w),
                Text('Emergency Bypass',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600)),
              ]),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Are you sure you need emergency access? This will:',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 14.sp, height: 1.4)),
                SizedBox(height: 2.h),
                _buildWarningItem(context, 'Break your current streak'),
                _buildWarningItem(
                    context, 'Be logged in your accountability report'),
                _buildWarningItem(context, 'Affect your consistency score'),
              ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel',
                        style: TextStyle(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500))),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onEmergencyBypass?.call();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightTheme.colorScheme.error,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onError),
                    child: Text('Proceed',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w600))),
              ]);
        });
  }

  Widget _buildWarningItem(BuildContext context, String warning) {
    return Padding(
        padding: EdgeInsets.only(bottom: 1.h),
        child: Row(children: [
          CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 4.w),
          SizedBox(width: 2.w),
          Expanded(
              child: Text(warning,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontSize: 13.sp))),
        ]));
  }
}
