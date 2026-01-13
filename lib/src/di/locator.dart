import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:innoscripta_task_manager/src/core/constants/app_env.dart';
import 'package:innoscripta_task_manager/src/core/networking/interceptors/dio_interceptors.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/data_sources/task_manager_local_data_source.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/data_sources/task_manager_remote_data_source.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/repositories/task_manager_repository_impl.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/create_task_comment_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/create_task_label_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/create_task_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/delete_task_comment_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/delete_task_label_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/delete_task_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_active_task_from_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_active_task_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_comment_from_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_comment_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_label_from_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_label_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/save_all_task_comment_to_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/save_all_task_label_to_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/save_all_task_to_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/update_task_comment_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/update_task_label_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/update_task_use_case.dart';
import 'package:innoscripta_task_manager/src/services/local_storage_service.dart';

import 'package:logger/logger.dart';

part 'client_locator.dart';
part 'data_source_locator.dart';
part 'external_locator.dart';
part 'repository_locator.dart';
part 'service_locator.dart';
part 'use_case_locator.dart';

final GetIt locator = GetIt.instance;

Future<void> initLocator() async {
  await Future.wait([
    _initExternal(),
    _initClients(),
    _initDataSource(),
    _initServices(),
    _initRepositoryLocator(),
    _initUseCaseLocator(),
  ]);
}
