import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppBlockingDemoWidget extends StatefulWidget {
  const AppBlockingDemoWidget({Key? key}) : super(key: key);

  @override
  State<AppBlockingDemoWidget> createState() => _AppBlockingDemoWidgetState();
}

class _AppBlockingDemoWidgetState extends State<AppBlockingDemoWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showBlockedOverlay = false;

  final List<Map<String, dynamic>> _socialApps = [
    {
      'name': 'Instagram',
      'icon': 'camera_alt',
      'color': const Color(0xFFE4405F),
    },
    {
      'name': 'TikTok',
      'icon': 'music_note',
      'color': const Color(0xFF000000),
    },
    {
      'name': 'Twitter',
      'icon': 'alternate_email',
      'color': const Color(0xFF1DA1F2),
    },
    {
      'name': 'Facebook',
      'icon': 'facebook',
      'color': const Color(0xFF1877F2),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Auto-trigger blocking demo
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _showBlockingDemo();
      }
    });
  }

  void _showBlockingDemo() {
    setState(() {
      _showBlockedOverlay = true;
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      height: 45.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Mock phone interface
          Column(
            children: [
              // Status bar
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '9:41',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'signal_cellular_4_bar',
                          size: 4.w,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: 'battery_full',
                          size: 4.w,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // App grid
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _socialApps.length,
                    itemBuilder: (context, index) {
                      final app = _socialApps[index];
                      return GestureDetector(
                        onTap: _showBlockingDemo,
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _showBlockedOverlay
                                  ? _scaleAnimation.value
                                  : 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (app['color'] as Color)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: app['color'] as Color,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 12.w,
                                      height: 12.w,
                                      decoration: BoxDecoration(
                                        color: app['color'] as Color,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: CustomIconWidget(
                                        iconName: app['icon'] as String,
                                        color: Colors.white,
                                        size: 6.w,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      app['name'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          // Blocking overlay
          if (_showBlockedOverlay)
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'block',
                    size: 15.w,
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Apps Blocked',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'Complete your morning routine to unlock',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary
                            .withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
