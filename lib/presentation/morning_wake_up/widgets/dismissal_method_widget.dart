import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum DismissalMethod { keyword, fullTranscription, physicalCombo }

class DismissalMethodWidget extends StatefulWidget {
  final DismissalMethod method;
  final VoidCallback onDismissalComplete;
  final String targetKeyword;

  const DismissalMethodWidget({
    Key? key,
    required this.method,
    required this.onDismissalComplete,
    this.targetKeyword = 'commitment',
  }) : super(key: key);

  @override
  State<DismissalMethodWidget> createState() => _DismissalMethodWidgetState();
}

class _DismissalMethodWidgetState extends State<DismissalMethodWidget> {
  bool _isListening = false;
  String _transcribedText = '';
  bool _keywordDetected = false;
  int _mathAnswer = 0;
  int _correctAnswer = 15;
  bool _qrScanned = false;
  bool _mathSolved = false;
  TextEditingController _speechController = TextEditingController();
  TextEditingController _mathController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateMathProblem();
  }

  void _generateMathProblem() {
    // Simple math problem: 7 + 8 = ?
    _correctAnswer = 15;
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _transcribedText = '';
    });

    // Simulate speech recognition
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isListening = false;
          _transcribedText = 'I am committed to my morning routine';
          _keywordDetected = _transcribedText
              .toLowerCase()
              .contains(widget.targetKeyword.toLowerCase());
        });

        if (_keywordDetected) {
          Future.delayed(const Duration(milliseconds: 500), () {
            widget.onDismissalComplete();
          });
        }
      }
    });
  }

  void _checkMathAnswer() {
    final userAnswer = int.tryParse(_mathController.text) ?? 0;
    if (userAnswer == _correctAnswer) {
      setState(() {
        _mathSolved = true;
      });

      if (_qrScanned && _mathSolved) {
        widget.onDismissalComplete();
      }
    }
  }

  void _simulateQRScan() {
    setState(() {
      _qrScanned = true;
    });

    if (_qrScanned && _mathSolved) {
      widget.onDismissalComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Complete to Dismiss Alarm',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          _buildDismissalContent(),
        ],
      ),
    );
  }

  Widget _buildDismissalContent() {
    switch (widget.method) {
      case DismissalMethod.keyword:
        return _buildKeywordDismissal();
      case DismissalMethod.fullTranscription:
        return _buildFullTranscriptionDismissal();
      case DismissalMethod.physicalCombo:
        return _buildPhysicalComboDismissal();
    }
  }

  Widget _buildKeywordDismissal() {
    return Column(
      children: [
        Text(
          'Say the keyword: "${widget.targetKeyword}"',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 3.h),
        Container(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton.icon(
            onPressed: _isListening ? null : _startListening,
            icon: _isListening
                ? SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'mic',
                    color: Colors.white,
                    size: 5.w,
                  ),
            label: Text(
              _isListening ? 'Listening...' : 'Start Speaking',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _keywordDetected
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
        if (_transcribedText.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transcribed:',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  _transcribedText,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                if (_keywordDetected) ...[
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Keyword detected!',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFullTranscriptionDismissal() {
    return Column(
      children: [
        Text(
          'Speak your complete oath statement',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 3.h),
        TextField(
          controller: _speechController,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: 'Your transcribed speech will appear here...',
            hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          maxLines: 3,
          readOnly: true,
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton.icon(
            onPressed: _isListening ? null : _startListening,
            icon: _isListening
                ? SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'mic',
                    color: Colors.white,
                    size: 5.w,
                  ),
            label: Text(
              _isListening ? 'Listening...' : 'Start Full Transcription',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhysicalComboDismissal() {
    return Column(
      children: [
        Text(
          'Complete both tasks to dismiss',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 3.h),

        // QR Code Task
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: _qrScanned
                ? AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _qrScanned
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: _qrScanned ? 'check_circle' : 'qr_code_scanner',
                    color: _qrScanned
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : Colors.white,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      _qrScanned ? 'QR Code Scanned ✓' : 'Scan QR Code',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: _qrScanned
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (!_qrScanned) ...[
                SizedBox(height: 2.h),
                Container(
                  width: double.infinity,
                  height: 5.h,
                  child: ElevatedButton(
                    onPressed: _simulateQRScan,
                    child: Text(
                      'Simulate QR Scan',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Math Problem Task
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: _mathSolved
                ? AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _mathSolved
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: _mathSolved ? 'check_circle' : 'calculate',
                    color: _mathSolved
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : Colors.white,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      _mathSolved
                          ? 'Math Problem Solved ✓'
                          : 'Solve: 7 + 8 = ?',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: _mathSolved
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (!_mathSolved) ...[
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _mathController,
                        keyboardType: TextInputType.number,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter answer',
                          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          filled: true,
                          fillColor: Colors.black.withValues(alpha: 0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    ElevatedButton(
                      onPressed: _checkMathAnswer,
                      child: Text(
                        'Check',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        if (_qrScanned && _mathSolved) ...[
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'celebration',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'All Tasks Complete!',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _speechController.dispose();
    _mathController.dispose();
    super.dispose();
  }
}
