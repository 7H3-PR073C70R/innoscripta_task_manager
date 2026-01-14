import 'package:dio/dio.dart';
import 'package:innoscripta_task_manager/src/core/error/exceptions.dart';

extension ErrorHandler on Exception {
  String? get errorMessage {
    try {
      if (this is DioException) {
        final error = this as DioException;
        final data = error.response?.data;

        // 1. Extract backend message if available
        final backendMessage = data is Map
            ? (data['message'] as String?)
            : data?.toString();

        // 2. Resolve final message priority: Backend > Dio Message > Fallback
        // Note: Check backendMessage for null/empty specifically
        final message = (backendMessage != null && backendMessage.isNotEmpty)
            ? backendMessage
            : (error.message ?? 'something went wrong');

        // 3. Special handling for connection issues
        final messageLowerCase = message.toLowerCase();
        return messageLowerCase.contains('failed host lookup')
            ? 'Please check your internet connection and try again'
            : messageLowerCase.contains('forbidden')
            ? 'Unauthorized'
            : message;
      } else if (this is ServerException) {
        return (this as ServerException).message;
      } else if (this is CacheException) {
        return (this as CacheException).message;
      } else {
        return null;
      }
    } on Exception catch (_) {
      return 'something went wrong';
    }
  }
}
