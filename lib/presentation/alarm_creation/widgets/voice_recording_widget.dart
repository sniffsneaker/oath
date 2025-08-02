import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceRecordingWidget extends StatefulWidget {
  final String? recordingPath;
  final Function(String?) onRecordingChanged;

  const VoiceRecordingWidget({
    Key? key,
    this.recordingPath,
    required this.onRecordingChanged,
  }) : super(key: key);

  @override
  State<VoiceRecordingWidget> createState() => _VoiceRecordingWidgetState();
}

class _VoiceRecordingWidgetState extends State<VoiceRecordingWidget>
    with TickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _hasRecording = false;
  int _recordingDuration = 0;
  Timer? _timer;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _hasRecording = widget.recordingPath != null;

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _waveController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<bool> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> _startRecording() async {
    if (!await _requestMicrophonePermission()) {
      _showPermissionDialog();
      return;
    }

    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(const RecordConfig(), path: 'recording.m4a');

        setState(() {
          _isRecording = true;
          _recordingDuration = 0;
        });

        _pulseController.repeat(reverse: true);
        _waveController.repeat();

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordingDuration++;
          });
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to start recording. Please try again.');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();

      _timer?.cancel();
      _pulseController.stop();
      _waveController.stop();

      setState(() {
        _isRecording = false;
        _hasRecording = path != null;
      });

      widget.onRecordingChanged(path);
    } catch (e) {
      _showErrorDialog('Failed to stop recording. Please try again.');
    }
  }

  void _deleteRecording() {
    setState(() {
      _hasRecording = false;
    });
    widget.onRecordingChanged(null);
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Microphone Permission Required',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Please allow microphone access to record your commitment.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Recording Error',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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
          Text(
            'Voice Commitment',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          Center(
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isRecording ? _pulseAnimation.value : 1.0,
                      child: GestureDetector(
                        onTap: _isRecording ? _stopRecording : _startRecording,
                        child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: _isRecording
                                ? AppTheme.lightTheme.colorScheme.error
                                : _hasRecording
                                    ? AppTheme.lightTheme.colorScheme.tertiary
                                    : AppTheme.lightTheme.colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (_isRecording
                                        ? AppTheme.lightTheme.colorScheme.error
                                        : AppTheme
                                            .lightTheme.colorScheme.primary)
                                    .withValues(alpha: 0.3),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: _isRecording
                                  ? 'stop'
                                  : _hasRecording
                                      ? 'play_arrow'
                                      : 'mic',
                              color: Colors.white,
                              size: 8.w,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 2.h),
                _isRecording ? _buildWaveform() : const SizedBox.shrink(),
                SizedBox(height: 1.h),
                Text(
                  _isRecording
                      ? _formatDuration(_recordingDuration)
                      : _hasRecording
                          ? 'Tap to play recording'
                          : 'Tap to record your commitment',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                _hasRecording && !_isRecording
                    ? SizedBox(height: 2.h)
                    : const SizedBox.shrink(),
                _hasRecording && !_isRecording
                    ? _buildRecordingActions()
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final delay = index * 0.2;
            final animationValue = (_waveController.value + delay) % 1.0;
            final height =
                2.h + (3.h * (0.5 + 0.5 * (animationValue * 2 - 1).abs()));

            return Container(
              width: 1.w,
              height: height,
              margin: EdgeInsets.symmetric(horizontal: 0.5.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildRecordingActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          onPressed: _deleteRecording,
          icon: CustomIconWidget(
            iconName: 'delete',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 5.w,
          ),
          label: Text(
            'Delete',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        TextButton.icon(
          onPressed: _startRecording,
          icon: CustomIconWidget(
            iconName: 'mic',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 5.w,
          ),
          label: Text(
            'Re-record',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}