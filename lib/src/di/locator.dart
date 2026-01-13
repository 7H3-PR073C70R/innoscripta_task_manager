import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:innoscripta_task_manager/src/core/constants/app_env.dart';
import 'package:innoscripta_task_manager/src/core/networking/interceptors/dio_interceptors.dart';
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
