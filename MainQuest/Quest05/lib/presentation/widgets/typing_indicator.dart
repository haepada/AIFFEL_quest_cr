import 'package:flutter/material.dart';
import 'dart:math';

/// 타이핑 효과를 보여주는 위젯
/// 출처: https://github.com/flutter/samples/blob/main/experimental/web_dashboard/lib/src/widgets/third_party/adaptive_scaffold.dart
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    Key? key,
    this.showIndicator = true,
    this.bubbleColor,
    this.flashingCircleDarkColor,
    this.flashingCircleBrightColor,
  }) : super(key: key);

  final bool showIndicator;
  final Color? bubbleColor;
  final Color? flashingCircleDarkColor;
  final Color? flashingCircleBrightColor;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _appearanceController;
  late Animation<double> _indicatorSpaceAnimation;

  late AnimationController _repeatingController;
  final List<Interval> _dotIntervals = const [
    Interval(0.0, 0.35),
    Interval(0.35, 0.7),
    Interval(0.7, 1.0),
  ];

  @override
  void initState() {
    super.initState();

    _appearanceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _indicatorSpaceAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    ).drive(Tween<double>(begin: 0.0, end: 60.0));

    _repeatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    if (widget.showIndicator) {
      _showIndicator();
    }
  }

  @override
  void didUpdateWidget(TypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showIndicator != oldWidget.showIndicator) {
      if (widget.showIndicator) {
        _showIndicator();
      } else {
        _hideIndicator();
      }
    }
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    _repeatingController.dispose();
    super.dispose();
  }

  void _showIndicator() {
    _appearanceController
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          _repeatingController.repeat();
        }
      });
  }

  void _hideIndicator() {
    _appearanceController
      ..reverse()
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _repeatingController.stop();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appearanceController,
      builder: (context, child) {
        return Container(
          width: _indicatorSpaceAnimation.value,
          child: _buildAnimatedDots(),
        );
      },
    );
  }

  Widget _buildAnimatedDots() {
    final theme = Theme.of(context);
    final bubbleColor = widget.bubbleColor ?? theme.colorScheme.secondary;
    final flashingCircleDarkColor =
        widget.flashingCircleDarkColor ?? theme.colorScheme.secondary;
    final flashingCircleBrightColor =
        widget.flashingCircleBrightColor ?? theme.colorScheme.primary;

    return Container(
      width: 60.0,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: bubbleColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFlashingCircle(
            flashingCircleDarkColor,
            flashingCircleBrightColor,
            0,
          ),
          const SizedBox(width: 4),
          _buildFlashingCircle(
            flashingCircleDarkColor,
            flashingCircleBrightColor,
            1,
          ),
          const SizedBox(width: 4),
          _buildFlashingCircle(
            flashingCircleDarkColor,
            flashingCircleBrightColor,
            2,
          ),
        ],
      ),
    );
  }

  Widget _buildFlashingCircle(
    Color darkColor,
    Color brightColor,
    int dotIndex,
  ) {
    return AnimatedBuilder(
      animation: _repeatingController,
      builder: (context, child) {
        final flashingCircleColor = _calculateFlashingCircleColor(
          dotIndex,
          darkColor,
          brightColor,
        );

        return Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: flashingCircleColor,
          ),
        );
      },
    );
  }

  Color _calculateFlashingCircleColor(
    int dotIndex,
    Color darkColor,
    Color brightColor,
  ) {
    final interval = _dotIntervals[dotIndex];
    final percentActive = _calculatePercentActive(interval);
    return Color.lerp(darkColor, brightColor, percentActive)!;
  }

  double _calculatePercentActive(Interval interval) {
    final now = _repeatingController.value;
    final start = interval.begin;
    final end = interval.end;

    if (now < start || now > end) {
      return 0.0;
    } else {
      return sin((now - start) / (end - start) * pi) * 0.5 + 0.5;
    }
  }
} 