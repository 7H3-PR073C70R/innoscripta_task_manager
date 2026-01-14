import 'package:dio/dio.dart';
import 'package:innoscripta_task_manager/src/core/networking/api/app_api_endpoint.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/create_comment_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/get_comments_filter_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/task_comment_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/label/create_task_label_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/label/task_label_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/create_task_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/get_active_task_filter_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/task_model.dart';

import 'package:retrofit/retrofit.dart';

part 'task_manager_client.g.dart';

@RestApi()
abstract class TaskManagerClient {
  factory TaskManagerClient(Dio dio, {String baseUrl}) = _TaskManagerClient;

  //! Task
  @GET(AppApiEndpoint.task)
  Future<List<TaskModel>> getAllActiveTask(
    @Queries() GetActiveTasksFilterModel request,
  );

  @POST(AppApiEndpoint.task)
  Future<TaskModel> createTask(
    @Body() CreateTaskModel request,
  );

  @POST('${AppApiEndpoint.task}/{id}')
  Future<TaskModel> updateTask(
    @Path('id') String id,
    @Body() CreateTaskModel request,
  );

  @DELETE('${AppApiEndpoint.task}/{id}')
  Future<void> deleteTask(@Path('id') String id);

  @POST('${AppApiEndpoint.task}/{id}/close')
  Future<void> closeTask(@Path('id') String id);

  @POST('${AppApiEndpoint.task}/{id}/reopen')
  Future<void> reopenTask(@Path('id') String id);

  //! Task-Label
  @GET(AppApiEndpoint.labels)
  Future<List<TaskLabelModel>> getAllTaskLabel();

  @POST(AppApiEndpoint.labels)
  Future<TaskLabelModel> createTaskLabel(
    @Body() CreateTaskLabelModel request,
  );

  @POST('${AppApiEndpoint.labels}/{id}')
  Future<TaskLabelModel> updateTaskLabel(
    @Path('id') String id,
    @Body() CreateTaskLabelModel request,
  );

  @DELETE('${AppApiEndpoint.labels}/{id}')
  Future<void> deleteTaskLabel(@Path('id') String id);

  //! Task-Comment
  @GET(AppApiEndpoint.comments)
  Future<List<TaskCommentModel>> getAllTaskComment(
    @Queries() GetCommentsFilterModel request,
  );

  @POST(AppApiEndpoint.comments)
  Future<TaskCommentModel> createTaskComment(
    @Body() CreateCommentModel request,
  );

  @POST('${AppApiEndpoint.comments}/{id}')
  Future<TaskCommentModel> updateTaskComment(
    @Path('id') String id,
    @Body() CreateCommentModel request,
  );

  @DELETE('${AppApiEndpoint.comments}/{id}')
  Future<void> deleteTaskComment(@Path('id') String id);
}
