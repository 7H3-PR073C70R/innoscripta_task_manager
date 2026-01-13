import 'package:innoscripta_task_manager/src/core/constants/app_env.dart';

/// All the endpoint used in this project are to be declared
/// in this class.
///
/// Example
///
/// static Uri authUrl =
///  Uri(scheme: 'https', host: 'example.com', path: '/api/v1/auth')
class AppApiEndpoint {
  const AppApiEndpoint._();

  static const scheme = 'https';
  static String host = AppEnv.apiBaseURL;
  static const int receiveTimeout = 50000;
  static const int sendTimeout = 50000;

  static String baseUri = '$scheme://$host//';
  static const basePath = '/rest/v2/';
  static const task = '${basePath}tasks';
  static const comments = '${basePath}comments';
  static const labels = '${basePath}labels';
}
