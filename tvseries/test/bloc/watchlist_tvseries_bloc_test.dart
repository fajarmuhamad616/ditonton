import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import '../dummy_data/dummy_objects.dart';
import 'watchlist_tvseries_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchListStatusTvSeries,
  GetWatchlistTvSeries,
  RemoveWatchlistTvSeries,
  SaveWatchlistTvSeries
])
void main() {
  late MockGetWatchlistTvSeries mockGetWatchlistTvseries;
  late MockGetWatchListStatusTvSeries mockGetWatchListStatusTvseries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvseries;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvseries;
  late WatchlistTvseriesBloc watchlistTvseriesBloc;

  setUp(() {
    mockGetWatchlistTvseries = MockGetWatchlistTvSeries();
    mockGetWatchListStatusTvseries = MockGetWatchListStatusTvSeries();
    mockRemoveWatchlistTvseries = MockRemoveWatchlistTvSeries();
    mockSaveWatchlistTvseries = MockSaveWatchlistTvSeries();
    watchlistTvseriesBloc = WatchlistTvseriesBloc(
      mockGetWatchlistTvseries,
      mockGetWatchListStatusTvseries,
      mockRemoveWatchlistTvseries,
      mockSaveWatchlistTvseries,
    );
  });

  test('the WatchlistTvseriesEmpty initial state should be empty ', () {
    expect(watchlistTvseriesBloc.state, WatchlistTvseriesEmpty());
  });

  group('get watchlist Tvseries test cases', () {
    blocTest<WatchlistTvseriesBloc, WatchlistTvseriesState>(
      'should emits WatchlistTvseriesLoading state and then WatchlistTvseriesHasData state when data is successfully fetched..',
      build: () {
        when(mockGetWatchlistTvseries.execute())
            .thenAnswer((_) async => Right([testTvSeries]));
        return watchlistTvseriesBloc;
      },
      act: (bloc) => bloc.add(OnWatchlistTvseriesCalled()),
      expect: () => [
        WatchlistTvseriesLoading(),
        WatchlistTvseriesHasData([testTvSeries]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvseries.execute());
        return OnWatchlistTvseriesCalled().props;
      },
    );

    blocTest<WatchlistTvseriesBloc, WatchlistTvseriesState>(
      'should emits WatchlistTvseriesLoading state and then WatchlistTvseriesError state when data is failed fetched..',
      build: () {
        when(mockGetWatchlistTvseries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchlistTvseriesBloc;
      },
      act: (bloc) => bloc.add(OnWatchlistTvseriesCalled()),
      expect: () => <WatchlistTvseriesState>[
        WatchlistTvseriesLoading(),
        WatchlistTvseriesError('Server Failure'),
      ],
      verify: (bloc) => WatchlistTvseriesLoading(),
    );

    blocTest<WatchlistTvseriesBloc, WatchlistTvseriesState>(
      'should emits WatchlistTvseriesLoading state and then WatchlistTvseriesEmpty state when data is retrieved empty..',
      build: () {
        when(mockGetWatchlistTvseries.execute())
            .thenAnswer((_) async => const Right([]));
        return watchlistTvseriesBloc;
      },
      act: (bloc) => bloc.add(OnWatchlistTvseriesCalled()),
      expect: () => <WatchlistTvseriesState>[
        WatchlistTvseriesLoading(),
        WatchlistTvseriesEmpty(),
      ],
    );
  });

  group('get watchlist status Tvseries test cases', () {
    blocTest<WatchlistTvseriesBloc, WatchlistTvseriesState>(
      'should be return true when the watchlist is also true',
      build: () {
        when(mockGetWatchListStatusTvseries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => true);
        return watchlistTvseriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistStatus(testTvSeriesDetail.id)),
      expect: () => [WatchlistTvseriesIsAdded(true)],
      verify: (bloc) {
        verify(mockGetWatchListStatusTvseries.execute(testTvSeriesDetail.id));
        return FetchWatchlistStatus(testTvSeriesDetail.id).props;
      },
    );

    blocTest<WatchlistTvseriesBloc, WatchlistTvseriesState>(
        'should be return false when the watchlist is also false',
        build: () {
          when(mockGetWatchListStatusTvseries.execute(testTvSeriesDetail.id))
              .thenAnswer((_) async => false);
          return watchlistTvseriesBloc;
        },
        act: (bloc) => bloc.add(FetchWatchlistStatus(testTvSeriesDetail.id)),
        expect: () => <WatchlistTvseriesState>[
              WatchlistTvseriesIsAdded(false),
            ],
        verify: (bloc) {
          verify(mockGetWatchListStatusTvseries.execute(testTvSeriesDetail.id));
          return FetchWatchlistStatus(testTvSeriesDetail.id).props;
        });
  });

  group('add watchlist test cases', () {
    blocTest<WatchlistTvseriesBloc, WatchlistTvseriesState>(
      'should update watchlist status when adding Tvseries to watchlist is successfully',
      build: () {
        when(mockSaveWatchlistTvseries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        return watchlistTvseriesBloc;
      },
      act: (bloc) => bloc.add(AddTvseriesToWatchlist(testTvSeriesDetail)),
      expect: () => [
        WatchlistTvseriesMessage('Added to Watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTvseries.execute(testTvSeriesDetail));
        return AddTvseriesToWatchlist(testTvSeriesDetail).props;
      },
    );

    blocTest<WatchlistTvseriesBloc, WatchlistTvseriesState>(
      'should throw failure message status when adding Tvseries to watchlist is failed',
      build: () {
        when(mockSaveWatchlistTvseries.execute(testTvSeriesDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('can\'t add data to watchlist')));
        return watchlistTvseriesBloc;
      },
      act: (bloc) => bloc.add(AddTvseriesToWatchlist(testTvSeriesDetail)),
      expect: () => [
        WatchlistTvseriesError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTvseries.execute(testTvSeriesDetail));
        return AddTvseriesToWatchlist(testTvSeriesDetail).props;
      },
    );
  });

  group('remove watchlist test cases', () {
    blocTest<WatchlistTvseriesBloc, WatchlistTvseriesState>(
      'should update watchlist status when removing Tvseries from watchlist is successfully',
      build: () {
        when(mockRemoveWatchlistTvseries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        return watchlistTvseriesBloc;
      },
      act: (bloc) => bloc.add(RemoveTvseriesFromWatchlist(testTvSeriesDetail)),
      expect: () => [
        WatchlistTvseriesMessage('Removed from Watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTvseries.execute(testTvSeriesDetail));
        return RemoveTvseriesFromWatchlist(testTvSeriesDetail).props;
      },
    );

    blocTest<WatchlistTvseriesBloc, WatchlistTvseriesState>(
      'should throw failure message status when reTvseries Tvseries from watchlist is failed',
      build: () {
        when(mockRemoveWatchlistTvseries.execute(testTvSeriesDetail))
            .thenAnswer((_) async =>
                Left(DatabaseFailure('can\'t add data to watchlist')));
        return watchlistTvseriesBloc;
      },
      act: (bloc) => bloc.add(RemoveTvseriesFromWatchlist(testTvSeriesDetail)),
      expect: () => [
        WatchlistTvseriesError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTvseries.execute(testTvSeriesDetail));
        return RemoveTvseriesFromWatchlist(testTvSeriesDetail).props;
      },
    );
  });
}
