import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
  });

  final testMovieTableId = testMovieTable.id;
  final futureMovieId = (_) async => testMovieTableId;

  final testTvSeriesTableId = testTvSeriesTable.id;
  final futureTvSeriesId = (_) async => testMovieTableId;

  group('Movie testing database', () {
    test('Should return movie id when inserting new whistlist a movie',
        () async {
      // arrange
      when(mockDatabaseHelper.insertMovieWatchlist(testMovieTable))
          .thenAnswer(futureMovieId);
      // act
      final result =
          await mockDatabaseHelper.insertMovieWatchlist(testMovieTable);
      // assert
      expect(result, testMovieTableId);
    });

    test('Should return movie id when removing whistlist a movie', () async {
      // arrange
      when(mockDatabaseHelper.removeMovieWatchlist(testMovieTable))
          .thenAnswer(futureMovieId);
      // act
      final result =
          await mockDatabaseHelper.removeMovieWatchlist(testMovieTable);
      // assert
      expect(result, testMovieTableId);
    });

    test('Should return movie detail table when get movie id is found',
        () async {
      // arrange
      when(mockDatabaseHelper.getMovieById(testMovieTableId))
          .thenAnswer((_) async => testMovieTable.toJson());
      // act
      final result = await mockDatabaseHelper.getMovieById(testMovieTableId);
      // assert
      expect(result, testMovieTable.toJson());
    });

    test('Should return null when get movie id is not found', () async {
      // arrange
      when(mockDatabaseHelper.getMovieById(testMovieTableId))
          .thenAnswer((_) async => null);
      // act
      final result = await mockDatabaseHelper.getMovieById(testMovieTableId);
      // assert
      expect(result, null);
    });

    test('Should return list of movie map when get watchlist movies', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistMovies())
          .thenAnswer((_) async => [testMovieMap]);
      // act
      final result = await mockDatabaseHelper.getWatchlistMovies();
      // assert
      expect(result, [testMovieMap]);
    });
  });

  group('Tv Series testing database', () {
    test('Should return tv series id when inserting new whistlist a tv series',
        () async {
      // arrange
      when(mockDatabaseHelper.insertTvSeriesWatchlist(testTvSeriesTable))
          .thenAnswer(futureTvSeriesId);
      // act
      final result =
          await mockDatabaseHelper.insertTvSeriesWatchlist(testTvSeriesTable);
      // assert
      expect(result, testTvSeriesTableId);
    });

    test('Should return tv series id when removing whistlist a tv series',
        () async {
      // arrange
      when(mockDatabaseHelper.removeTvSeriesWatchlist(testTvSeriesTable))
          .thenAnswer(futureTvSeriesId);
      // act
      final result =
          await mockDatabaseHelper.removeTvSeriesWatchlist(testTvSeriesTable);
      // assert
      expect(result, testTvSeriesTableId);
    });

    test('Should return tv series detail table when get tv series id is found',
        () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(testTvSeriesTableId))
          .thenAnswer((_) async => testTvSeriesTable.toJson());
      // act
      final result =
          await mockDatabaseHelper.getTvSeriesById(testTvSeriesTableId);
      // assert
      expect(result, testTvSeriesTable.toJson());
    });

    test('Should return null when get tv series id is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(testTvSeriesTableId))
          .thenAnswer((_) async => null);
      // act
      final result =
          await mockDatabaseHelper.getTvSeriesById(testTvSeriesTableId);
      // assert
      expect(result, null);
    });

    test('Should return list of tv series map when get watchlist Tv Series',
        () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvSeriesMap]);
      // act
      final result = await mockDatabaseHelper.getWatchlistTvSeries();
      // assert
      expect(result, [testTvSeriesMap]);
    });
  });
}
