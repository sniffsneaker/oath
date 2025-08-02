import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlayOathButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isPlaying;
  final bool hasPlayedOnce;

  const PlayOathButtonWidget({
    Key? key,
    required this.onPressed,
    this.isPlaying = false,
    this.hasPlayedOnce = false,
  }) : super(key: key);

  @override
  State<PlayOathButtonWidget> createState() => _PlayOathButtonWidgetState();
}

class _PlayOathButtonWidgetState extends State<PlayOathButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isPlaying) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PlayOathButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isPlaying ? _scaleAnimation.value : 1.0,
          child: Container(
            width: 80.w,
            height: 8.h,
            decoration: BoxDecoration(
              gradient: widget.hasPlayedOnce
                  ? LinearGradient(
                      colors: [
                        AppTheme.lightTheme.colorScheme.tertiary,
                        AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.8),
                      ],
                    )
                  : AppTheme.getDawnGradient(),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.isPlaying
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.4)
                      : Colors.black.withValues(alpha: 0.2),
                  blurRadius: widget.isPlaying ? 20 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isPlaying) ...[
                        Container(
                          width: 6.w,
                          height: 6.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 3.w),
                      ] else ...[
                        CustomIconWidget(
                          iconName: widget.hasPlayedOnce
                              ? 'check_circle'
                              : 'play_arrow',
                          color: Colors.white,
                          size: 6.w,
                        ),
                        SizedBox(width: 3.w),
                      ],
                      Flexible(
                        child: Text(
                          widget.isPlaying
                              ? 'Playing Your Oath...'
                              : widget.hasPlayedOnce
                                  ? 'Oath Completed'
                                  : 'Play My Oath',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
