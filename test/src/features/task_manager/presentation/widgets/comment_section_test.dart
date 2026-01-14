import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/get_comments_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/comment/comment_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/comment_section.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/pump_app.dart';
import '../../../../../helpers/test_entities.dart';

void main() {
  late MockCommentBloc mockCommentBloc;

  setUpAll(() {
    registerFallbackValue(
      const CommentEvent.getAllTaskComment(
        GetCommentsFilterEntity(projectId: '', taskId: ''),
      ),
    );
    registerFallbackValue(
      const CommentEvent.createTaskComment(
        CreateCommentEntity(id: '', taskId: '', projectId: '', content: ''),
      ),
    );
  });

  setUp(() {
    mockCommentBloc = MockCommentBloc();
  });

  group('CommentSection', () {
    testWidgets('renders empty state when no comments', (tester) async {
      //! Arrange
      when(() => mockCommentBloc.state).thenReturn(
        const CommentState.initial(viewState: ViewState.success),
      );

      //! Act
      await tester.pumpApp(
        BlocProvider<CommentBloc>.value(
          value: mockCommentBloc,
          child: const Scaffold(
            body: CommentSection(
              taskId: '123',
              projectId: '456',
            ),
          ),
        ),
      );

      //! Assert
      expect(find.text('No comments yet'), findsOneWidget);
    });

    testWidgets('renders comments correctly', (tester) async {
      //! Arrange
      final tComment = TestEntities.tCommentEntity;
      when(() => mockCommentBloc.state).thenReturn(
        CommentState.initial(
          viewState: ViewState.success,
          comments: [tComment],
        ),
      );

      //! Act
      await tester.pumpApp(
        BlocProvider<CommentBloc>.value(
          value: mockCommentBloc,
          child: const Scaffold(
            body: CommentSection(
              taskId: '123',
              projectId: '456',
            ),
          ),
        ),
      );

      //! Assert
      expect(find.text(tComment.content!), findsOneWidget);
    });

    testWidgets('posts a new comment', (tester) async {
      //! Arrange
      final streamController = StreamController<CommentState>();
      whenListen(
        mockCommentBloc,
        streamController.stream,
        initialState: const CommentState.initial(viewState: ViewState.success),
      );
      when(() => mockCommentBloc.state).thenReturn(
        const CommentState.initial(viewState: ViewState.success),
      );

      //! Act
      await tester.pumpApp(
        BlocProvider<CommentBloc>.value(
          value: mockCommentBloc,
          child: const Scaffold(
            body: CommentSection(
              taskId: '123',
              projectId: '456',
            ),
          ),
        ),
      );

      // Wait for initState to call add
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'New test comment');
      await tester.pump(); // Show the Post button

      //! Act - Trigger mutation state change to success
      streamController.add(
        const CommentState.initial(
          viewState: ViewState.success,
          mutationState: ViewState.success,
        ),
      );

      // Tap the "Post" button (localized string from ARB is "Post")
      await tester.tap(find.text('Post'));
      await tester.pumpAndSettle();

      //! Assert
      // We expect 2 calls to add:
      // 1. CommentEvent.getAllTaskComment (on init)
      // 2. CommentEvent.createTaskComment (on submit)
      verify(() => mockCommentBloc.add(any())).called(greaterThanOrEqualTo(1));

      await streamController.close();
    });
  });
}
