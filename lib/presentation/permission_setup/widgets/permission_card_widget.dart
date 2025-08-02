import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionCardWidget extends StatelessWidget {
  final String iconName;
  final String title;
  final String description;
  final PermissionStatus status;
  final VoidCallback onGrantPressed;

  const PermissionCardWidget({
    Key? key,
    required this.iconName,
    required this.title,
    required this.description,
    required this.status,
    required this.onGrantPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _getIconBackgroundColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: _getIconColor(),
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getStatusBackgroundColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: _getStatusTextColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              description,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            status != PermissionStatus.granted
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onGrantPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: status == PermissionStatus.denied
                            ? AppTheme.errorLight
                            : AppTheme.primaryLight,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        status == PermissionStatus.denied
                            ? 'Retry'
                            : 'Grant Permission',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.successLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.successLight,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.successLight,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Permission Granted',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.successLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Color _getBorderColor() {
    switch (status) {
      case PermissionStatus.granted:
        return AppTheme.successLight;
      case PermissionStatus.denied:
        return AppTheme.errorLight;
      case PermissionStatus.pending:
      default:
        return AppTheme.secondaryLight;
    }
  }

  Color _getIconColor() {
    switch (status) {
      case PermissionStatus.granted:
        return AppTheme.successLight;
      case PermissionStatus.denied:
        return AppTheme.errorLight;
      case PermissionStatus.pending:
      default:
        return AppTheme.secondaryLight;
    }
  }

  Color _getIconBackgroundColor() {
    switch (status) {
      case PermissionStatus.granted:
        return AppTheme.successLight.withValues(alpha: 0.1);
      case PermissionStatus.denied:
        return AppTheme.errorLight.withValues(alpha: 0.1);
      case PermissionStatus.pending:
      default:
        return AppTheme.secondaryLight.withValues(alpha: 0.1);
    }
  }

  Color _getStatusBackgroundColor() {
    switch (status) {
      case PermissionStatus.granted:
        return AppTheme.successLight.withValues(alpha: 0.1);
      case PermissionStatus.denied:
        return AppTheme.errorLight.withValues(alpha: 0.1);
      case PermissionStatus.pending:
      default:
        return AppTheme.secondaryLight.withValues(alpha: 0.1);
    }
  }

  Color _getStatusTextColor() {
    switch (status) {
      case PermissionStatus.granted:
        return AppTheme.successLight;
      case PermissionStatus.denied:
        return AppTheme.errorLight;
      case PermissionStatus.pending:
      default:
        return AppTheme.secondaryLight;
    }
  }

  String _getStatusText() {
    switch (status) {
      case PermissionStatus.granted:
        return 'Granted';
      case PermissionStatus.denied:
        return 'Denied';
      case PermissionStatus.pending:
      default:
        return 'Pending';
    }
  }
}

enum PermissionStatus { pending, granted, denied }
