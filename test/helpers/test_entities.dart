import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_status.dart';

class TestEntities {
  const TestEntities._();
  // --- RAW JSON SAMPLES ---

  static const Map<String, dynamic> taskJson = {
    'id': '2995104339',
    'content': 'Buy Milk',
    'comment_count': 10,
    'is_completed': false,
    'created_at': '2019-12-11T22:36:50.000000Z',
    'priority': 1,
    'order': 1,
    'project_id': '2203306141',
    'labels': ['Food', 'Shopping'],
    'url': 'https://app.todoist.com/showTask?id=2995104339',
  };

  static const Map<String, dynamic> labelJson = {
    'id': '2156154810',
    'name': 'Food',
    'color': 'charcoal',
    'order': 1,
    'is_favorite': false,
  };

  static const Map<String, dynamic> commentJson = {
    'id': '2992679862',
    'project_id': '2992679862',
    'content': 'Need one bottle of milk',
    'posted_at': '2016-09-22T07:00:00.000000Z',
    'task_id': '2995104339',
  };

  // --- ENTITY INSTANCES ---

  static final tTaskEntity = TaskEntity(
    id: '2995104339',
    content: 'Buy Milk',
    status: TaskStatus.todo,
    commentCount: 10,
    isCompleted: false,
    createdAt: DateTime.parse('2019-12-11T22:36:50.000000Z'),
    priority: 1,
    order: 1,
    projectId: '2203306141',
    labels: const ['Food', 'Shopping'],
    url: 'https://app.todoist.com/showTask?id=2995104339',
    timer: const TaskTimer(),
  );

  static const tLabelEntity = TaskLabelEntity(
    id: '2156154810',
    name: 'Food',
    color: 'charcoal',
    order: 1,
    isFavorite: false,
  );

  static final tCommentEntity = TaskCommentEntity(
    id: '2992679862',
    projectId: '2992679862',
    content: 'Need one bottle of milk',
    postedAt: DateTime.parse('2016-09-22T07:00:00.000000Z'),
    taskId: '2995104339',
  );
}
