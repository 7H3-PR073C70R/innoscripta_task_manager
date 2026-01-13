part of 'locator.dart';

Future<void> _initDataSource() async {
  locator
    ..registerLazySingleton<TaskManagerRemoteDataSource>(
      () => TaskManagerRemoteDataSourceImpl(
        locator(),
      ),
    )
    ..registerLazySingleton<TaskManagerLocalDataSource>(
      () => TaskManagerLocalDataSourceImpl(
        locator(),
      ),
    );
}
