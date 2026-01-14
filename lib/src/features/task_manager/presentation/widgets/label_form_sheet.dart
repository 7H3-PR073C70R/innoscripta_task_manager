import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:innoscripta_task_manager/src/core/constants/app_spacing.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/core/extensions/snackbar_extension.dart';
import 'package:innoscripta_task_manager/src/core/extensions/theme_extension.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/create_task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/enums/label_color.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/label/label_bloc.dart';
import 'package:innoscripta_task_manager/src/l10n/l10n.dart';
import 'package:innoscripta_task_manager/src/shared/widgets/app_button.dart';
import 'package:innoscripta_task_manager/src/shared/widgets/task_field.dart';

class LabelFormSheet extends StatefulWidget {
  const LabelFormSheet({
    super.key,
    this.label,
  });

  final TaskLabelEntity? label;

  @override
  State<LabelFormSheet> createState() => _LabelFormSheetState();
}

class _LabelFormSheetState extends State<LabelFormSheet> {
  final _labelNameController = TextEditingController();
  late LabelColor? _selectedColor;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.label != null;
    if (_isEditing) {
      _labelNameController.text = widget.label!.name ?? '';
      _selectedColor = LabelColor.fromName(widget.label!.color ?? '');
    } else {
      _selectedColor = null;
    }
  }

  @override
  void dispose() {
    _labelNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_labelNameController.text.trim().isEmpty) return;

    final request = CreateTaskLabelEntity(
      id: widget.label?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _labelNameController.text.trim(),
      color: _selectedColor?.name,
    );

    if (_isEditing) {
      context.read<LabelBloc>().add(LabelEvent.updateTaskLabel(request));
    } else {
      context.read<LabelBloc>().add(LabelEvent.createTaskLabel(request));
    }
  }

  void _delete() {
    if (widget.label?.id != null) {
      context.read<LabelBloc>().add(
        LabelEvent.deleteTaskLabel(widget.label!.id!),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final appString = context.l10n;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isEditing ? appString.editLabel : appString.createNewLabel,
                style: textTheme.heading.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.gray[900],
                ),
              ),
              if (_isEditing)
                IconButton(
                  onPressed: _delete,
                  icon: Icon(Icons.delete_outline, color: colors.error[500]),
                  tooltip: appString.deleteLabel,
                ),
            ],
          ),
          AppSpacing.verticalSpaceLarge,
          TaskField(
            controller: _labelNameController,
            label: appString.labelName,
            hint: appString.labelName,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return appString.labelNameRequired;
              }
              return null;
            },
          ),
          AppSpacing.verticalSpaceMedium,
          Text(
            appString.color,
            style: textTheme.caption.copyWith(
              color: colors.gray[600],
            ),
          ),
          AppSpacing.verticalSpaceSmall,
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: LabelColor.values.length,
              separatorBuilder: (_, _) => AppSpacing.horizontalSpaceSmall,
              itemBuilder: (context, index) {
                final labelColor = LabelColor.values[index];
                final isSelected = _selectedColor == labelColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = labelColor),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: labelColor.color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: colors.gray[900]!,
                              width: 3,
                            )
                          : null,
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: labelColor.color.withValues(alpha: 0.4),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 20,
                            color: Colors.white,
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          AppSpacing.verticalSpaceLarge,
          BlocConsumer<LabelBloc, LabelState>(
            listener: (context, state) {
              if (state.mutationState.isSuccess) {
                context.pop();
              } else if (state.mutationState.isError) {
                context.showSnackBar(
                  message: state.errorMessage ?? '',
                  type: SnackBarType.error,
                );
              }
            },
            builder: (context, state) {
              return AppButton(
                onPressed: _submit,
                isBusy: state.mutationState.isProcessing,
                text: _isEditing ? appString.save : appString.create,
                backgroundColor: colors.primary[500],
                textColor: Colors.white,
                width: double.infinity,
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<void> showLabelFormSheet(
  BuildContext context, {
  TaskLabelEntity? label,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => LabelFormSheet(label: label),
  );
}
