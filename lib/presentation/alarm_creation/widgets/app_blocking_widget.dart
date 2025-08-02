import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppBlockingWidget extends StatefulWidget {
  final bool isEnabled;
  final int duration;
  final List<String> blockedApps;
  final Function(bool) onToggleChanged;
  final Function(int) onDurationChanged;
  final Function(List<String>) onAppsChanged;

  const AppBlockingWidget({
    Key? key,
    required this.isEnabled,
    required this.duration,
    required this.blockedApps,
    required this.onToggleChanged,
    required this.onDurationChanged,
    required this.onAppsChanged,
  }) : super(key: key);

  @override
  State<AppBlockingWidget> createState() => _AppBlockingWidgetState();
}

class _AppBlockingWidgetState extends State<AppBlockingWidget> {
  final List<Map<String, dynamic>> _availableApps = [
    {'name': 'Instagram', 'icon': 'photo_camera', 'color': Color(0xFFE4405F)},
    {'name': 'TikTok', 'icon': 'music_note', 'color': Color(0xFF000000)},
    {'name': 'Facebook', 'icon': 'facebook', 'color': Color(0xFF1877F2)},
    {'name': 'Twitter', 'icon': 'alternate_email', 'color': Color(0xFF1DA1F2)},
    {'name': 'YouTube', 'icon': 'play_circle', 'color': Color(0xFFFF0000)},
    {'name': 'Snapchat', 'icon': 'camera_alt', 'color': Color(0xFFFFFC00)},
    {'name': 'Reddit', 'icon': 'forum', 'color': Color(0xFFFF4500)},
    {'name': 'WhatsApp', 'icon': 'chat', 'color': Color(0xFF25D366)},
  ];

  void _showAppSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 60.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Apps to Block',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 1.h,
                ),
                itemCount: _availableApps.length,
                itemBuilder: (context, index) {
                  final app = _availableApps[index];
                  final isSelected = widget.blockedApps.contains(app['name']);

                  return GestureDetector(
                    onTap: () {
                      final updatedApps = List<String>.from(widget.blockedApps);
                      if (isSelected) {
                        updatedApps.remove(app['name']);
                      } else {
                        updatedApps.add(app['name']);
                      }
                      widget.onAppsChanged(updatedApps);
                    },
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: app['color'],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: app['icon'],
                                color: Colors.white,
                                size: 4.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              app['name'],
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          isSelected
                              ? CustomIconWidget(
                                  iconName: 'check_circle',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 5.w,
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'block',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'App Blocking',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
              Switch(
                value: widget.isEnabled,
                onChanged: widget.onToggleChanged,
              ),
            ],
          ),
          widget.isEnabled ? SizedBox(height: 3.h) : const SizedBox.shrink(),
          widget.isEnabled ? _buildDurationSlider() : const SizedBox.shrink(),
          widget.isEnabled ? SizedBox(height: 3.h) : const SizedBox.shrink(),
          widget.isEnabled ? _buildBlockedAppsList() : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildDurationSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Block Duration',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            Text(
              '${widget.duration} minutes',
              style: AppTheme.getDataTextStyle(
                isLight: true,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ).copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.lightTheme.colorScheme.primary,
            inactiveTrackColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            thumbColor: AppTheme.lightTheme.colorScheme.primary,
            overlayColor:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
            trackHeight: 1.h,
          ),
          child: Slider(
            value: widget.duration.toDouble(),
            min: 30,
            max: 120,
            divisions: 9,
            onChanged: (value) => widget.onDurationChanged(value.round()),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '30 min',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '120 min',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBlockedAppsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Blocked Apps (${widget.blockedApps.length})',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: _showAppSelector,
              child: Text(
                widget.blockedApps.isEmpty ? 'Add Apps' : 'Edit',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        widget.blockedApps.isEmpty
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'apps',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 8.w,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'No apps selected',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Tap "Add Apps" to select dopamine apps to block',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: widget.blockedApps.map((appName) {
                  final app = _availableApps.firstWhere(
                    (a) => a['name'] == appName,
                    orElse: () => {
                      'name': appName,
                      'icon': 'apps',
                      'color': AppTheme.lightTheme.colorScheme.primary
                    },
                  );

                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5.w,
                          height: 5.w,
                          decoration: BoxDecoration(
                            color: app['color'],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: app['icon'],
                              color: Colors.white,
                              size: 3.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          app['name'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }
}
