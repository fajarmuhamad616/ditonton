import 'package:core/data/models/season_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testSeasonModel = SeasonModel(
    airDate: 'airDate',
    episodeCount: 1,
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
  );

  final testSeasonEntity = testSeasonModel.toEntity();
  final testSeasonJson = testSeasonModel.toJson();

  group('Season Model testing', () {
    test('Should return a subclass of Season entity', () {
      final result = testSeasonModel.toEntity();
      expect(result, testSeasonEntity);
    });

    test('Should become a json of Season', () {
      final result = testSeasonModel.toJson();
      expect(result, testSeasonJson);
    });

    test('Should become a instance season model entity', () {
      final result = SeasonModel.fromJson(testSeasonJson);
      expect(result, testSeasonModel);
    });
  });
}
