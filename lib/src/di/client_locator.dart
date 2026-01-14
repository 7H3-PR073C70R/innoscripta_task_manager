part of 'locator.dart';

Future<void> _initClients() async {
  locator.registerLazySingleton<TaskManagerClient>(
    () => TaskManagerClient(
      locator(),
    ),
  );
}
