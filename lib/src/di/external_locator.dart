part of 'locator.dart';

Future<void> _initExternal() async {
  locator
    ..registerLazySingleton<Dio>(
      () =>
          Dio(
              BaseOptions(
                baseUrl: AppEnv.apiBaseURL,
                contentType: 'application/json',
                connectTimeout: const Duration(seconds: 20),
              ),
            )
            ..interceptors.addAll(
              [
                LoggingInterceptor(logger: locator()),
                DataParserInterceptor(),
              ],
            ),
    )
    ..registerLazySingleton<Logger>(
      Logger.new,
    );
}
