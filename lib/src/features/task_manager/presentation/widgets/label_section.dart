import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/core/extensions/theme_extension.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/enums/label_color.dart';

import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/label/label_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/label_form_sheet.dart';
import 'package:innoscripta_task_manager/src/l10n/l10n.dart';
import 'package:innoscripta_task_manager/src/shared/widgets/animated_loader.dart';

class LabelSection extends StatelessWidget {
  const LabelSection({
    required this.selectedLabelIds,
    required this.onSelectionChanged,
    super.key,
  });

  final List<String> selectedLabelIds;
  final ValueChanged<List<String>> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final appString = context.l10n;

    return BlocBuilder<LabelBloc, LabelState>(
      builder: (context, state) {
        if (state.viewState.isProcessing && state.labels.isEmpty) {
          return const Center(child: AnimatedLoader());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...state.labels.map((label) {
                  final isSelected = selectedLabelIds.contains(
                    label.id ?? label.name,
                  );

                  final labelColor = LabelColor.fromName(
                    label.color ?? '',
                  ).color;

                  return InkWell(
                    onLongPress: () =>
                        showLabelFormSheet(context, label: label),
                    borderRadius: BorderRadius.circular(20),
                    child: FilterChip(
                      label: Text(label.name ?? appString.unnamed),
                      selected: isSelected,
                      onSelected: (selected) {
                        final newSelection = List<String>.from(
                          selectedLabelIds,
                        );
                        final id = label.id ?? label.name!;
                        if (selected) {
                          newSelection.add(id);
                        } else {
                          newSelection.remove(id);
                        }
                        onSelectionChanged(newSelection);
                      },
                      backgroundColor: colors.surface[100],
                      selectedColor: labelColor.withValues(alpha: 0.2),
                      labelStyle: textTheme.body.copyWith(
                        color: isSelected
                            ? colors.primary[900]
                            : colors.gray[700],
                      ),
                      side: BorderSide(
                        color: isSelected ? labelColor : colors.gray[300]!,
                      ),
                    ),
                  );
                }),
                ActionChip(
                  avatar: Icon(Icons.add, size: 16, color: colors.primary[500]),
                  label: Text(appString.createNewLabel),
                  onPressed: () => showLabelFormSheet(context),
                  backgroundColor: colors.surface[50],
                  side: BorderSide(color: colors.primary[500]!),
                  labelStyle: textTheme.body.copyWith(
                    color: colors.primary[500],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
