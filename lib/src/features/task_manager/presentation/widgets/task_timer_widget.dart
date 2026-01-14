import 'dart:async';
import 'package:flutter/material.dart';
import 'package:innoscripta_task_manager/src/core/extensions/theme_extension.dart';
import 'package:innoscripta_task_manager/src/core/themes/color/app_theme_colors.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';

class TaskTimerWidget extends StatefulWidget {
  const TaskTimerWidget({
    required this.timer,
    required this.onStart,
    required this.onStop,
    this.compact = false,
    super.key,
  });

  final TaskTimer timer;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final bool compact;

  @override
  State<TaskTimerWidget> createState() => _TaskTimerWidgetState();
}

class _TaskTimerWidgetState extends State<TaskTimerWidget>
    with SingleTickerProviderStateMixin {
  Timer? _updateTimer;
  late AnimationController _pulseController;
  int _currentSeconds = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _updateCurrentSeconds();
    if (widget.timer.isRunning ?? false) {
      _startUpdateTimer();
      unawaited(_pulseController.repeat(reverse: true));
    }
  }

  @override
  void didUpdateWidget(TaskTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timer.isRunning != oldWidget.timer.isRunning) {
      if (widget.timer.isRunning ?? false) {
        _startUpdateTimer();
        unawaited(_pulseController.repeat(reverse: true));
      } else {
        _stopUpdateTimer();
        _pulseController
          ..stop()
          ..value = 0;
      }
    }
    _updateCurrentSeconds();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(_updateCurrentSeconds);
      }
    });
  }

  void _stopUpdateTimer() {
    _updateTimer?.cancel();
  }

  void _updateCurrentSeconds() {
    final baseSeconds = (widget.timer.totalSecondsCompleted ?? 0).toInt();
    if ((widget.timer.isRunning ?? false) && widget.timer.startTime != null) {
      final elapsed = DateTime.now().difference(widget.timer.startTime!);
      _currentSeconds = baseSeconds + elapsed.inSeconds;
    } else {
      _currentSeconds = baseSeconds;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isRunning = widget.timer.isRunning ?? false;

    if (widget.compact) {
      return _CompactTimer(
        colors: colors,
        isRunning: isRunning,
        pulseController: _pulseController,
        currentSeconds: _currentSeconds,
        onStart: widget.onStart,
        onStop: widget.onStop,
      );
    }

    return _FullTimer(
      colors: colors,
      isRunning: isRunning,
      pulseController: _pulseController,
      currentSeconds: _currentSeconds,
      onStart: widget.onStart,
      onStop: widget.onStop,
    );
  }
}

class _CompactTimer extends StatelessWidget {
  const _CompactTimer({
    required this.colors,
    required this.isRunning,
    required this.pulseController,
    required this.currentSeconds,
    required this.onStart,
    required this.onStop,
  });

  final AppThemeColors colors;
  final bool isRunning;
  final AnimationController pulseController;
  final int currentSeconds;
  final VoidCallback onStart;
  final VoidCallback onStop;

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isRunning ? colors.primary[50] : colors.surface[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRunning ? colors.primary[200]! : colors.gray[200]!,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              return Icon(
                Icons.timer,
                size: 16,
                color: isRunning
                    ? Color.lerp(
                        colors.primary[500],
                        colors.primary[700],
                        pulseController.value,
                      )
                    : colors.gray[500],
              );
            },
          ),
          const SizedBox(width: 8),
          Text(
            _formatDuration(currentSeconds),
            style: context.textTheme.caption.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isRunning ? colors.primary[700] : colors.gray[700],
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 16,
            width: 1,
            color: isRunning ? colors.primary[200] : colors.gray[300],
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: isRunning ? onStop : onStart,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                isRunning ? Icons.pause : Icons.play_arrow,
                size: 18,
                color: isRunning ? colors.primary[700] : colors.gray[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullTimer extends StatelessWidget {
  const _FullTimer({
    required this.colors,
    required this.isRunning,
    required this.pulseController,
    required this.currentSeconds,
    required this.onStart,
    required this.onStop,
  });

  final AppThemeColors colors;
  final bool isRunning;
  final AnimationController pulseController;
  final int currentSeconds;
  final VoidCallback onStart;
  final VoidCallback onStop;

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRunning ? colors.primary[200]! : colors.gray[200]!,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: pulseController,
                builder: (context, child) {
                  return Icon(
                    isRunning ? Icons.timer : Icons.timer_outlined,
                    size: 24,
                    color: isRunning
                        ? Color.lerp(
                            colors.primary[500],
                            colors.primary[700],
                            pulseController.value,
                          )
                        : colors.gray[500],
                  );
                },
              ),
              const SizedBox(width: 8),
              Text(
                'Time Tracked',
                style: context.textTheme.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.gray[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _formatDuration(currentSeconds),
            style: context.textTheme.heading.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: isRunning ? colors.primary[700] : colors.gray[900],
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: isRunning ? onStop : onStart,
                  icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(isRunning ? 'Stop Timer' : 'Start Timer'),
                  style: FilledButton.styleFrom(
                    backgroundColor: isRunning
                        ? colors.error[500]
                        : colors.primary[500],
                    textStyle: context.textTheme.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
