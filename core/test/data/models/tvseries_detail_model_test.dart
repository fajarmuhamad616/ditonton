import 'package:core/data/models/tvseries_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testTvSeriesDetailResponse = TvSeriesDetailResponse(
    backdropPath: 'backdropPath',
    episodeRunTime: [],
    firstAirDate: 'firstAirDate',
    genres: [],
    homepage: 'homepage',
    id: 1,
    name: 'name',
    numberOfEpisodes: 2,
    numberOfSeasons: 2,
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    seasons: [],
    status: 'status',
    tagline: 'tagline',
    type: 'type',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final testTvSeriesDetail = testTvSeriesDetailResponse.toEntity();
  final testTvSeriesDetailJson = testTvSeriesDetailResponse.toJson();

  group('Tv Series Detail Testing', () {
    test('Should return a subclass of Tv Series Detail entity', () {
      final result = testTvSeriesDetailResponse.toEntity();
      expect(result, testTvSeriesDetail);
    });

    test('Should become a json of Tv Series', () {
      final result = testTvSeriesDetailResponse.toJson();
      expect(result, testTvSeriesDetailJson);
    });

    test('Should become a instance Tv Series Detail Response', () {
      final result = TvSeriesDetailResponse.fromJson(testTvSeriesDetailJson);
      expect(result, testTvSeriesDetailResponse);
    });
  });
}
