part of 'locator.dart';

Future<void> _initRepositoryLocator() async {
  locator.registerLazySingleton<TaskManagerRepository>(
    () => TaskManagerRepositoryImpl(
      localDataSource: locator(),
      remoteDataSource: locator(),
    ),
  );
}
