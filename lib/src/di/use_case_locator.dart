part of 'locator.dart';

Future<void> _initUseCaseLocator() async {
  //! --- Task Use Cases ---
  locator
    ..registerLazySingleton(() => GetAllActiveTaskUseCase(locator()))
    ..registerLazySingleton(
      () => GetAllActiveTaskFromStorageUseCase(locator()),
    )
    ..registerLazySingleton(() => SaveAllTaskToStorageUseCase(locator()))
    ..registerLazySingleton(() => CreateTaskUseCase(locator()))
    ..registerLazySingleton(() => UpdateTaskUseCase(locator()))
    ..registerLazySingleton(() => DeleteTaskUseCase(locator()))
    //! --- Task-Label Use Cases ---
    ..registerLazySingleton(() => GetAllTaskLabelUseCase(locator()))
    ..registerLazySingleton(
      () => GetAllTaskLabelFromStorageUseCase(locator()),
    )
    ..registerLazySingleton(
      () => SaveAllTaskLabelToStorageUseCase(locator()),
    )
    ..registerLazySingleton(() => CreateTaskLabelUseCase(locator()))
    ..registerLazySingleton(() => UpdateTaskLabelUseCase(locator()))
    ..registerLazySingleton(() => DeleteTaskLabelUseCase(locator()))
    //! --- Task-Comment Use Cases ---
    ..registerLazySingleton(() => GetAllTaskCommentUseCase(locator()))
    ..registerLazySingleton(
      () => GetAllTaskCommentFromStorageUseCase(locator()),
    )
    ..registerLazySingleton(
      () => SaveAllTaskCommentToStorageUseCase(locator()),
    )
    ..registerLazySingleton(() => CreateTaskCommentUseCase(locator()))
    ..registerLazySingleton(() => UpdateTaskCommentUseCase(locator()))
    ..registerLazySingleton(() => DeleteTaskCommentUseCase(locator()));
}
