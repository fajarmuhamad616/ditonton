import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tvseries/tvseries.dart';

import '../dummy_data/dummy_objects.dart';
import '../helpers/pages_test_helpers.dart';

void main() {
  late FakeTopRatedTvseriesBloc fakeTopRatedTvseriesBloc;

  setUpAll(() {
    fakeTopRatedTvseriesBloc = FakeTopRatedTvseriesBloc();
    registerFallbackValue(FakeTopRatedTvseriesEvent());
    registerFallbackValue(FakeTopRatedTvseriesState());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvseriesBloc>(
      create: (_) => fakeTopRatedTvseriesBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  tearDown(() => fakeTopRatedTvseriesBloc.close());

  testWidgets('page should display circular progress indicator when loading',
      (WidgetTester tester) async {
    when(() => fakeTopRatedTvseriesBloc.state)
        .thenReturn(TopRatedTvseriesLoading());

    final circularProgressIndicatorFinder =
        find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvSeriesPage()));
    await tester.pump();

    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets(
      'should display AppBar, ListView, TvSeriesCard, and TopRatedTvseriesPage when data is loaded',
      (WidgetTester tester) async {
    when(() => fakeTopRatedTvseriesBloc.state)
        .thenReturn(TopRatedTvseriesHasData(testTvList));
    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvSeriesPage()));
    await tester.pump();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvSeriesCard), findsOneWidget);
    expect(find.byKey(const Key('top_rated_tvseries_content')), findsOneWidget);
  });

  testWidgets('should display text with message when error',
      (WidgetTester tester) async {
    const errorMessage = 'error message';

    when(() => fakeTopRatedTvseriesBloc.state)
        .thenReturn(TopRatedTvseriesError(errorMessage));

    final textMessageKeyFinder = find.byKey(const Key('error_message'));
    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvSeriesPage()));
    await tester.pump();

    expect(textMessageKeyFinder, findsOneWidget);
  });
}
