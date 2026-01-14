import 'package:dio/dio.dart';
import 'package:innoscripta_task_manager/src/core/constants/app_env.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.logger});

  final Logger? logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger?.i(
      'REQUEST[${options.method}] => URL: ${options.uri}\n'
      'REQUEST DATA => ${options.data}\n'
      'Headers: ${options.headers}',
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    logger?.i(
      'RESPONSE[${response.statusCode}] =>'
      ' PATH:${response.requestOptions.path}\n'
      'RESPONSE DATA: ${response.data}',
    );
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    logger?.e(
      'ERROR[${err.requestOptions.uri}]\n'
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}\n'
      'ERROR[${err.response?.data}]',
    );
    super.onError(err, handler);
  }
}

class TokenInterceptor extends Interceptor {
  TokenInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer ${AppEnv.apiToken}';
    super.onRequest(options, handler);
  }
}

class DataParserInterceptor extends Interceptor {
  DataParserInterceptor();

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    late Response<dynamic> modifiedResponse;
    try {
      modifiedResponse = Response<dynamic>(
        requestOptions: response.requestOptions,
        data: response.data,
        statusCode: response.statusCode,
        extra: response.extra,
        headers: response.headers,
        isRedirect: response.isRedirect,
        redirects: response.redirects,
        statusMessage: response.statusMessage,
      );
    } on Exception catch (_) {
      modifiedResponse = response;
    }

    super.onResponse(modifiedResponse, handler);
  }
}
