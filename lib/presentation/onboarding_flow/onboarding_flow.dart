import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/app_blocking_demo_widget.dart';
import './widgets/navigation_button_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/streak_progress_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Transform Your Morning Routine',
      'description':
          'Record your daily commitments with your own voice and create powerful accountability through personal audio reminders that you can\'t ignore.',
      'imageUrl':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'showAnimation': true,
    },
    {
      'title': 'Block Distracting Apps',
      'description':
          'Automatically block social media and entertainment apps during your morning routine. Stay focused until you complete your commitments.',
      'imageUrl':
          'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'showAnimation': false,
    },
    {
      'title': 'Track Your Progress',
      'description':
          'Build unstoppable momentum with streak tracking and consistency scores. See how morning success correlates with daily fulfillment.',
      'imageUrl':
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'showAnimation': false,
    },
  ];

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToPermissionSetup();
    }
  }

  void _skipOnboarding() {
    _navigateToPermissionSetup();
  }

  void _navigateToPermissionSetup() {
    Navigator.pushReplacementNamed(context, '/permission-setup');
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onVoiceAnimationTap() {
    // Simulate voice recording animation feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tap to record your daily commitment',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Skip button
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 2.h,
                    right: 6.w,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _skipOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.h,
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // PageView content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _totalPages,
                  itemBuilder: (context, index) {
                    final data = _onboardingData[index];

                    // Special handling for different pages
                    if (index == 1) {
                      // App blocking demo page
                      return SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          child: Column(
                            children: [
                              // Demo widget area
                              Expanded(
                                flex: 6,
                                child: Center(
                                  child: const AppBlockingDemoWidget(),
                                ),
                              ),

                              // Content area
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data['title'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.headlineMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 3.h),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      child: Text(
                                        data['description'] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyLarge
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (index == 2) {
                      // Streak tracking page
                      return SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          child: Column(
                            children: [
                              // Progress widget area
                              Expanded(
                                flex: 6,
                                child: Center(
                                  child: const StreakProgressWidget(),
                                ),
                              ),

                              // Content area
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data['title'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.headlineMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 3.h),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      child: Text(
                                        data['description'] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyLarge
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      // Default onboarding page
                      return OnboardingPageWidget(
                        title: data['title'] as String,
                        description: data['description'] as String,
                        imageUrl: data['imageUrl'] as String,
                        showAnimation: data['showAnimation'] as bool,
                        onAnimationTap: _onVoiceAnimationTap,
                      );
                    }
                  },
                ),
              ),

              // Bottom navigation area
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 3.h,
                  ),
                  child: Column(
                    children: [
                      // Page indicators
                      PageIndicatorWidget(
                        currentPage: _currentPage,
                        totalPages: _totalPages,
                      ),

                      SizedBox(height: 4.h),

                      // Navigation button
                      NavigationButtonWidget(
                        text: _currentPage == _totalPages - 1
                            ? 'Get Started'
                            : 'Next',
                        onPressed: _nextPage,
                        isPrimary: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Gesture detector for swipe navigation
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! > 0) {
                  // Swipe right - previous page
                  if (_currentPage > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                } else if (details.primaryVelocity! < 0) {
                  // Swipe left - next page
                  _nextPage();
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
