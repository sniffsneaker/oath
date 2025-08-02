import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MotivationalMessageWidget extends StatefulWidget {
  final String userName;
  final String primaryGoal;

  const MotivationalMessageWidget({
    Key? key,
    required this.userName,
    required this.primaryGoal,
  }) : super(key: key);

  @override
  State<MotivationalMessageWidget> createState() =>
      _MotivationalMessageWidgetState();
}

class _MotivationalMessageWidgetState extends State<MotivationalMessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentMessageIndex = 0;

  final List<Map<String, dynamic>> _motivationalMessages = [
    {
      'icon': 'self_improvement',
      'title': 'Stay Strong',
      'message': 'Your future self will thank you for this discipline',
    },
    {
      'icon': 'psychology',
      'title': 'Remember Your Why',
      'message': 'Every small step brings you closer to your goals',
    },
    {
      'icon': 'trending_up',
      'title': 'Progress Over Perfection',
      'message': 'Consistency in small actions creates lasting change',
    },
    {
      'icon': 'wb_sunny',
      'title': 'Morning Momentum',
      'message': 'How you start your morning sets the tone for your entire day',
    },
    {
      'icon': 'favorite',
      'title': 'Self-Love in Action',
      'message': 'Choosing discipline is choosing to love your future self',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOut)));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.2, 0.8, curve: Curves.easeOut)));

    _animationController.forward();
    _startMessageRotation();
  }

  void _startMessageRotation() {
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        _animationController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _currentMessageIndex =
                  (_currentMessageIndex + 1) % _motivationalMessages.length;
            });
            _animationController.forward();
            _startMessageRotation();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentMessage = _motivationalMessages[_currentMessageIndex];

    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                      width: 85.w,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.lightTheme.colorScheme.secondary
                                    .withValues(alpha: 0.1),
                                AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.05),
                              ]),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(width: 1)),
                      child: Column(children: [
                        // Icon and title
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(2.5.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: CustomIconWidget(
                                      iconName: currentMessage['icon'],
                                      size: 6.w)),
                              SizedBox(width: 3.w),
                              Text(currentMessage['title'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp)),
                            ]),

                        SizedBox(height: 3.h),

                        // Motivational message
                        Text(currentMessage['message'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5),
                            textAlign: TextAlign.center),

                        SizedBox(height: 3.h),

                        // Personalized message
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 4.w),
                            decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppTheme.lightTheme.primaryColor
                                        .withValues(alpha: 0.1),
                                    width: 1)),
                            child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontSize: 13.sp, height: 1.4),
                                    children: [
                                      TextSpan(
                                          text: '${widget.userName}, ',
                                          style: TextStyle(
                                              color: AppTheme
                                                  .lightTheme.primaryColor,
                                              fontWeight: FontWeight.w600)),
                                      TextSpan(
                                          text: 'your commitment to ',
                                          style: TextStyle(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.onSurface)),
                                      TextSpan(
                                          text:
                                              widget.primaryGoal.toLowerCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                      TextSpan(
                                          text: ' starts with this moment.',
                                          style: TextStyle(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.onSurface)),
                                    ]))),

                        SizedBox(height: 2.h),

                        // Progress indicator dots
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                _motivationalMessages.length,
                                (index) => Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 1.w),
                                    width: index == _currentMessageIndex
                                        ? 3.w
                                        : 2.w,
                                    height: index == _currentMessageIndex
                                        ? 3.w
                                        : 2.w,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index == _currentMessageIndex
                                            ? AppTheme.lightTheme.colorScheme.secondary
                                            : AppTheme
                                                .lightTheme.colorScheme.outline
                                                .withValues(alpha: 0.3))))),
                      ]))));
        });
  }
}