import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies/movies.dart';

import '../dummy_data/dummy_objects.dart';
import '../helpers/pages_test_helpers.dart';

void main() {
  late FakeTopRatedMoviesBloc fakeTopRatedMoviesBloc;

  setUpAll(() {
    fakeTopRatedMoviesBloc = FakeTopRatedMoviesBloc();
    registerFallbackValue(FakeTopRatedMoviesEvent());
    registerFallbackValue(FakeTopRatedMoviesState());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>(
      create: (_) => fakeTopRatedMoviesBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  tearDown(() => fakeTopRatedMoviesBloc.close());

  testWidgets('page should display circular progress indicator when loading',
      (WidgetTester tester) async {
    when(() => fakeTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoading());

    final circularProgressIndicatorFinder =
        find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));
    await tester.pump();

    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets(
      'should display AppBar, ListView, MovieCard, and TopRatedMoviesPage when data is loaded',
      (WidgetTester tester) async {
    when(() => fakeTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesHasData(testMovieList));
    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));
    await tester.pump();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
    expect(find.byKey(const Key('top_rated_movies_content')), findsOneWidget);
  });

  testWidgets('should display text with message when error',
      (WidgetTester tester) async {
    const errorMessage = 'error message';

    when(() => fakeTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesError(errorMessage));

    final textMessageKeyFinder = find.byKey(const Key('error_message'));
    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));
    await tester.pump();

    expect(textMessageKeyFinder, findsOneWidget);
  });
}
