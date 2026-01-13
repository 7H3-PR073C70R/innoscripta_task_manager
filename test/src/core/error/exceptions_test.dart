import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/exceptions.dart';

void main() {
  group('server exception ...', () {
    test('should store message and stack trace correctly', () {
      //! arrange
      final tStackTrace = StackTrace.current;
      const tMessage = 'server error occurred';

      //! act
      final exception = ServerException(message: tMessage, trace: tStackTrace);

      //! assert
      expect(
        exception.message,
        tMessage,
        reason: 'The message should match the input',
      );
      expect(
        exception.trace,
        tStackTrace,
        reason: 'The stack trace should match the input',
      );
    });

    test('should allow null values for message and trace', () {
      //! act
      const exception = ServerException();

      //! assert
      expect(exception.message, isNull);
      expect(exception.trace, isNull);
    });
  });

  group('cache exception ...', () {
    test('should store message and stack trace correctly', () {
      //! arrange
      final tStackTrace = StackTrace.current;
      const tMessage = 'cache error occurred';

      //! act
      final exception = CacheException(message: tMessage, trace: tStackTrace);

      //! assert
      expect(
        exception.message,
        tMessage,
        reason: 'The message should match the input',
      );
      expect(
        exception.trace,
        tStackTrace,
        reason: 'The stack trace should match the input',
      );
    });

    test('should allow null values for message and trace', () {
      //! act
      const exception = CacheException();

      //! assert
      expect(exception.message, isNull);
      expect(exception.trace, isNull);
    });
  });
}
