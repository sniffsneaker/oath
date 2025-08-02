import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SnoozeOptionWidget extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback onSnooze;
  final int snoozeMinutes;
  final bool requiresPartialCompletion;

  const SnoozeOptionWidget({
    Key? key,
    required this.isEnabled,
    required this.onSnooze,
    this.snoozeMinutes = 5,
    this.requiresPartialCompletion = true,
  }) : super(key: key);

  @override
  State<SnoozeOptionWidget> createState() => _SnoozeOptionWidgetState();
}

class _SnoozeOptionWidgetState extends State<SnoozeOptionWidget> {
  bool _showConfirmation = false;

  void _handleSnoozePress() {
    if (widget.requiresPartialCompletion) {
      setState(() {
        _showConfirmation = true;
      });
    } else {
      widget.onSnooze();
    }
  }

  void _confirmSnooze() {
    setState(() {
      _showConfirmation = false;
    });
    widget.onSnooze();
  }

  void _cancelSnooze() {
    setState(() {
      _showConfirmation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 90.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: _showConfirmation
          ? _buildConfirmationContent()
          : _buildSnoozeButton(),
    );
  }

  Widget _buildSnoozeButton() {
    return Column(
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'snooze',
              color: Colors.white.withValues(alpha: 0.7),
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Need ${widget.snoozeMinutes} more minutes?',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          height: 5.h,
          child: OutlinedButton(
            onPressed: _handleSnoozePress,
            child: Text(
              'Snooze ${widget.snoozeMinutes} Minutes',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        if (widget.requiresPartialCompletion) ...[
          SizedBox(height: 1.h),
          Text(
            'Requires listening to your oath first',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildConfirmationContent() {
    return Column(
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Snoozing weakens your commitment',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          'Your morning routine is designed to build discipline. Are you sure you want to delay your commitment?',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 5.h,
                child: OutlinedButton(
                  onPressed: _cancelSnooze,
                  child: Text(
                    'Stay Strong',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Container(
                height: 5.h,
                child: ElevatedButton(
                  onPressed: _confirmSnooze,
                  child: Text(
                    'Snooze Anyway',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
