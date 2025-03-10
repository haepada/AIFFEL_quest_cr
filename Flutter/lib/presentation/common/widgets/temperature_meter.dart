import 'package:flutter/material.dart';

class TemperatureMeter extends StatelessWidget {
  final double temperature;
  final double maxTemperature;
  final bool animate;
  final ValueChanged<double>? onChanged;

  const TemperatureMeter({
    Key? key,
    required this.temperature,
    this.maxTemperature = 40.0,
    this.animate = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = temperature / maxTemperature;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${temperature.toStringAsFixed(1)}°C',
              style: theme.textTheme.titleLarge?.copyWith( // headline6를 titleLarge로 변경
                color: _getTemperatureColor(temperature),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _getTemperatureLabel(temperature),
              style: theme.textTheme.bodyMedium?.copyWith( // bodyText2를 bodyMedium으로 변경
                color: _getTemperatureColor(temperature),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onHorizontalDragUpdate: onChanged == null ? null : (details) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final position = renderBox.globalToLocal(details.globalPosition);
            final percentage = (position.dx / renderBox.size.width).clamp(0.0, 1.0);
            onChanged!(percentage * maxTemperature);
          },
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[200],
            ),
            child: Stack(
              children: [
                // 그라데이션 배경
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4A8CFF), // 차가움 - 파랑
                        Color(0xFF39D98A), // 중립 - 초록
                        Color(0xFFFF3B5C), // 따뜻함 - 빨강
                        Color(0xFFFF67B3), // 열정/플러팅 - 핑크
                      ],
                    ),
                  ),
                ),

                // 온도 표시 슬라이더
                AnimatedPositioned(
                  duration: animate ? const Duration(milliseconds: 1500) : Duration.zero,
                  curve: Curves.easeOutQuart,
                  left: percentage * (MediaQuery.of(context).size.width - 60) - 12,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: _getTemperatureColor(temperature),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getTemperatureColor(temperature).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '차가움',
              style: theme.textTheme.bodySmall, // caption을 bodySmall로 변경
            ),
            Text(
              '따뜻함',
              style: theme.textTheme.bodySmall, // caption을 bodySmall로 변경
            ),
          ],
        ),
      ],
    );
  }

  Color _getTemperatureColor(double temp) {
    if (temp >= 30) return const Color(0xFFFF67B3); // 플러팅
    if (temp >= 20) return const Color(0xFFFF3B5C); // 따뜻함
    if (temp >= 10) return const Color(0xFF39D98A); // 중립
    return const Color(0xFF4A8CFF); // 차가움
  }

  String _getTemperatureLabel(double temp) {
    if (temp >= 30) return '정열적 표현';
    if (temp >= 20) return '따뜻한 표현';
    if (temp >= 10) return '중립적 표현';
    return '직설적 표현';
  }
}