part of 'locator.dart';

Future<void> _initServices() async {
  locator.registerLazySingleton<LocalStorageService>(
    LocalStorageServiceImpl.new,
  );
}
