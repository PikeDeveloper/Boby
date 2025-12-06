import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final VoidCallback? onTimerEnd;
  final Duration? maxDuration;
  final bool countDown;

  const TimerWidget({
    super.key,
    this.onTimerEnd,
    this.maxDuration,
    this.countDown = false,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.countDown && widget.maxDuration != null) {
      _elapsed = widget.maxDuration!;
    }
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (widget.countDown) {
          // Countdown mode
          if (_elapsed.inSeconds > 0) {
            _elapsed -= const Duration(seconds: 1);
          } else {
            _timer?.cancel();
            widget.onTimerEnd?.call();
          }
        } else {
          // Count up mode
          _elapsed += const Duration(seconds: 1);
          if (widget.maxDuration != null && _elapsed >= widget.maxDuration!) {
            _timer?.cancel();
            widget.onTimerEnd?.call();
          }
        }
      });
    });
  }

  String _formatTime() {
    final minutes = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade400, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, color: Colors.blue.shade600, size: 24),
          const SizedBox(width: 8),
          Text(
            _formatTime(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
