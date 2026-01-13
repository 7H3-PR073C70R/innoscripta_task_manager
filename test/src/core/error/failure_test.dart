// ignore_for_file: lines_longer_than_80_chars, document_ignores

import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';

void main() {
  const tMessage = 'error message';
  const tStatusCode = 500;

  group('server failure ...', () {
    test('should store message and status code correctly', () {
      //! act
      const failure = ServerFailure(message: tMessage, statusCode: tStatusCode);

      //! assert
      expect(
        failure.message,
        tMessage,
        reason: 'The message should match the input',
      );
      expect(
        failure.statusCode,
        tStatusCode,
        reason: 'The status code should match the input',
      );
    });

    test('should be a subclass of [Failure]', () {
      //! act
      const failure = ServerFailure();

      //! assert
      expect(failure, isA<Failure>());
    });
  });

  group('cache failure ...', () {
    test('should store message and status code correctly', () {
      //! act
      const failure = CacheFailure(message: tMessage, statusCode: tStatusCode);

      //! assert
      expect(
        failure.message,
        tMessage,
        reason: 'The message should match the input',
      );
      expect(
        failure.statusCode,
        tStatusCode,
        reason: 'The status code should match the input',
      );
    });

    test('should be a subclass of [Failure]', () {
      //! act
      const failure = CacheFailure();

      //! assert
      expect(failure, isA<Failure>());
    });
  });

  group('failure equality ...', () {
    test(
      'should be equal when props are empty as per current implementation',
      () {
        //! arrange
        const failure1 = ServerFailure(message: 'A', statusCode: 400);
        const failure2 = ServerFailure(message: 'B', statusCode: 500);

        //! assert
        // Note: Since props returns [], these will be equal despite different data.
        expect(
          failure1,
          failure2,
          reason: 'Failures are equal because [props] is empty',
        );
      },
    );
  });
}
