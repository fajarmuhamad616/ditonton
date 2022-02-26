import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tvseries/tvseries.dart';

import '../dummy_data/dummy_objects.dart';
import '../helpers/pages_test_helpers.dart';

void main() {
  late FakeWatchlistTvseriesBloc fakeWatchlistTvseriesBloc;

  setUpAll(() {
    fakeWatchlistTvseriesBloc = FakeWatchlistTvseriesBloc();
    registerFallbackValue(FakeWatchlistTvseriesEvent());
    registerFallbackValue(FakeWatchlistTvseriesState());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvseriesBloc>(
      create: (_) => fakeWatchlistTvseriesBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  tearDown(() => fakeWatchlistTvseriesBloc.close());

  testWidgets('page should display circular progress indicator when loading',
      (WidgetTester tester) async {
    when(() => fakeWatchlistTvseriesBloc.state)
        .thenReturn(WatchlistTvseriesLoading());

    final circularProgressIndicatorFinder =
        find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvSeriesPage()));
    await tester.pump();

    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets(
      'should display AppBar, ListView, TvSeriesCard, and WatchlistTvseriesPage when data is loaded',
      (WidgetTester tester) async {
    when(() => fakeWatchlistTvseriesBloc.state)
        .thenReturn(WatchlistTvseriesHasData(testTvList));
    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvSeriesPage()));
    await tester.pump();

    expect(find.byType(Padding), findsWidgets);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvSeriesCard), findsOneWidget);
    expect(find.byKey(const Key('watchlist_tvseries_content')), findsOneWidget);
  });

  testWidgets('should display text with message when error',
      (WidgetTester tester) async {
    const errorMessage = 'error message';

    when(() => fakeWatchlistTvseriesBloc.state)
        .thenReturn(WatchlistTvseriesError(errorMessage));

    final textMessageKeyFinder = find.byKey(const Key('error_message'));
    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvSeriesPage()));
    await tester.pump();

    expect(textMessageKeyFinder, findsOneWidget);
  });
}
