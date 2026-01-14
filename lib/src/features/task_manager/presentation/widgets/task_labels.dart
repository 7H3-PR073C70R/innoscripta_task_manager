import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/enums/label_color.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/label/label_bloc.dart';

class TaskLabels extends StatelessWidget {
  const TaskLabels({this.labelIds, super.key});

  final List<String>? labelIds;

  @override
  Widget build(BuildContext context) {
    if (labelIds == null || labelIds!.isEmpty) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<LabelBloc, LabelState>(
      builder: (context, state) {
        final labels = state.labels
            .where((l) => labelIds!.contains(l.id ?? l.name))
            .toList();

        if (labels.isEmpty) return const SizedBox.shrink();

        return Wrap(
          spacing: 4,
          runSpacing: 4,
          children: labels.map((label) {
            final color = LabelColor.fromName(label.color ?? '').color;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(
                label.name ?? '',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
