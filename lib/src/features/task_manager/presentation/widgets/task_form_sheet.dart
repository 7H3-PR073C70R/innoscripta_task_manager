import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoscripta_task_manager/src/core/constants/app_spacing.dart';
import 'package:innoscripta_task_manager/src/core/extensions/theme_extension.dart';
import 'package:innoscripta_task_manager/src/core/themes/color/app_theme_colors.dart';
import 'package:innoscripta_task_manager/src/core/themes/typography/app_typography.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/create_task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_status.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/label/label_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/label_section.dart';
import 'package:innoscripta_task_manager/src/l10n/l10n.dart';
import 'package:innoscripta_task_manager/src/shared/widgets/app_button.dart';
import 'package:innoscripta_task_manager/src/shared/widgets/task_field.dart';
import 'package:innoscripta_task_manager/src/shared/wrapper/shrinkable_button.dart';

Future<CreateTaskEntity?> showTaskForm(
  BuildContext context, {
  TaskEntity? task,
  TaskStatus? status,
}) async {
  final width = MediaQuery.of(context).size.width;
  final isMobile = width < 600;

  if (isMobile) {
    return showModalBottomSheet<CreateTaskEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskFormSheet(
        task: task,
        status: status,
      ),
    );
  } else {
    return showDialog<CreateTaskEntity>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
          child: TaskFormSheet(task: task, isDialog: true, status: status),
        ),
      ),
    );
  }
}

class TaskFormSheet extends StatefulWidget {
  const TaskFormSheet({
    this.task,
    this.isDialog = false,
    this.status,
    super.key,
  });

  final TaskEntity? task;
  final bool isDialog;
  final TaskStatus? status;

  @override
  State<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<TaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  late String? _durationUnit;
  late int _priority;
  DateTime? _dueDate;
  final List<String> _selectedLabelIds = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.content);
    _descriptionController = TextEditingController(
      text: widget.task?.description,
    );
    _priority = widget.task?.priority?.toInt() ?? 4;
    _dueDate = widget.task?.due?.date;
    if (widget.task?.labels != null) {
      _selectedLabelIds.addAll(widget.task!.labels!);
    }
    _durationController = TextEditingController(
      text: widget.task?.duration?.amount?.toString(),
    );
    _durationUnit = widget.task?.duration?.unit;

    // Trigger fetch labels if not loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LabelBloc>().add(const LabelEvent.getAllTaskLabel());
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final taskEntity = CreateTaskEntity(
        id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        content: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
        labels: _selectedLabelIds,
        duration: _durationController.text.isNotEmpty
            ? num.tryParse(_durationController.text)
            : null,
        durationUnit: _durationUnit,
        status: widget.status,
      );

      Navigator.of(context).pop(taskEntity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final appString = context.l10n;
    final isEditing = widget.task != null;

    final content = Container(
      decoration: BoxDecoration(
        color: colors.surface[50],
        borderRadius: widget.isDialog
            ? BorderRadius.circular(16)
            : const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        // Add bottom padding for keyboard/safe area
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              if (!widget.isDialog)
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: colors.gray[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

              Text(
                isEditing ? appString.editTask : appString.createTask,
                style: textTheme.heading.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.gray[900],
                ),
              ),
              const SizedBox(height: 24),

              TaskField(
                controller: _titleController,
                label: appString.taskTitle,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return appString.pleaseEnterTitle;
                  }
                  return null;
                },
              ),

              AppSpacing.verticalSpaceMedium,

              TaskField(
                controller: _descriptionController,
                label: appString.taskDescription,
                maxLines: 3,
              ),

              AppSpacing.verticalSpaceMedium,

              Row(
                children: [
                  Expanded(
                    child: _PrioritySelector(
                      priority: _priority,
                      onChanged: (val) => setState(() => _priority = val),
                      colors: colors,
                      textTheme: textTheme,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _DueDateSelector(
                      dueDate: _dueDate,
                      onChanged: (val) => setState(() => _dueDate = val),
                    ),
                  ),
                ],
              ),

              AppSpacing.verticalSpaceMedium,

              Row(
                children: [
                  Expanded(
                    child: TaskField(
                      controller: _durationController,
                      label: appString.duration,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _DurationUnitSelector(
                      unit: _durationUnit,
                      onChanged: (val) => setState(() => _durationUnit = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_durationController.text.isNotEmpty && _durationUnit == null)
                Text(
                  appString.durationUnitRequired,
                  style: textTheme.caption.copyWith(color: colors.error[500]),
                ),

              const SizedBox(height: 24),

              Text(
                appString.labels,
                style: textTheme.subHeading.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.gray[800],
                ),
              ),
              const SizedBox(height: 8),

              LabelSection(
                selectedLabelIds: _selectedLabelIds,
                onSelectionChanged: (ids) {
                  setState(() {
                    _selectedLabelIds
                      ..clear()
                      ..addAll(ids);
                  });
                },
              ),

              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShrinkableButton(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      appString.cancel,
                      style: textTheme.body.copyWith(
                        color: colors.gray[700],
                      ),
                    ),
                  ),
                  AppSpacing.horizontalSpaceSmall,
                  AppButton(
                    onPressed: _submit,
                    text: isEditing ? appString.save : appString.create,
                    backgroundColor: colors.primary[500],
                    textColor: Colors.white,
                    width: 100,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return widget.isDialog
        ? content
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: content,
          );
  }
}

class _PrioritySelector extends StatelessWidget {
  const _PrioritySelector({
    required this.priority,
    required this.onChanged,
    required this.colors,
    required this.textTheme,
  });

  final int priority;
  final ValueChanged<int> onChanged;
  final AppThemeColors colors;
  final AppTypography textTheme;

  @override
  Widget build(BuildContext context) {
    final appString = context.l10n;
    return DropdownButtonFormField<int>(
      initialValue: priority,
      decoration: InputDecoration(
        labelText: appString.priority,
        labelStyle: textTheme.body.copyWith(color: colors.gray[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: [
        DropdownMenuItem(value: 1, child: Text(appString.high)),
        DropdownMenuItem(value: 2, child: Text(appString.medium)),
        DropdownMenuItem(value: 3, child: Text(appString.low)),
        DropdownMenuItem(
          value: 4,
          child: Text(appString.none),
        ),
      ],
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
    );
  }
}

class _DueDateSelector extends StatelessWidget {
  const _DueDateSelector({
    required this.dueDate,
    required this.onChanged,
  });

  final DateTime? dueDate;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final appString = context.l10n;
    final colors = context.colors;
    final textTheme = context.textTheme;
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: dueDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) onChanged(date);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: appString.dueDate,
          labelStyle: textTheme.body.copyWith(color: colors.gray[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          dueDate != null
              ? '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
              : appString.selectDate,
          style: textTheme.body.copyWith(
            color: dueDate != null ? colors.gray[900] : colors.gray[500],
          ),
        ),
      ),
    );
  }
}

class _DurationUnitSelector extends StatelessWidget {
  const _DurationUnitSelector({
    required this.unit,
    required this.onChanged,
  });

  final String? unit;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final appString = context.l10n;
    final colors = context.colors;
    final textTheme = context.textTheme;

    return DropdownButtonFormField<String>(
      initialValue: unit,
      decoration: InputDecoration(
        labelText: appString.unit,
        labelStyle: textTheme.body.copyWith(color: colors.gray[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: [
        DropdownMenuItem(value: 'minute', child: Text(appString.minute)),
        DropdownMenuItem(value: 'day', child: Text(appString.day)),
      ],
      onChanged: onChanged,
    );
  }
}
