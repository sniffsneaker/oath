import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WhyStatementCardWidget extends StatelessWidget {
  final String whyStatement;
  final String userName;

  const WhyStatementCardWidget({
    Key? key,
    required this.whyStatement,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 85.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                width: 1.5),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0),
            ]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Header with icon and title
          Row(children: [
            Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: CustomIconWidget(
                    iconName: 'psychology',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w)),
            SizedBox(width: 4.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Your Why Statement',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp)),
                  SizedBox(height: 0.5.h),
                  Text('Remember your commitment, $userName',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontSize: 12.sp)),
                ])),
          ]),

          SizedBox(height: 4.h),

          // Quote decoration
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomIconWidget(
                iconName: 'format_quote',
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                size: 8.w),
            SizedBox(width: 2.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(whyStatement,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                          letterSpacing: 0.2),
                      textAlign: TextAlign.left),
                  SizedBox(height: 2.h),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CustomIconWidget(
                        iconName: 'format_quote',
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.3),
                        size: 6.w),
                  ]),
                ])),
          ]),

          SizedBox(height: 3.h),

          // Motivational footer
          Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
              decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      width: 1)),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CustomIconWidget(iconName: 'favorite', size: 4.w),
                SizedBox(width: 2.w),
                Text('Stay committed to your morning routine',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500)),
              ])),
        ]));
  }
}
