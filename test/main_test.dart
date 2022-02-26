import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

// this code for codemagic not error for testing
void main() {
  const testTvSeriesModel = TvSeriesModel(
    backdropPath: "/oKt4J3TFjWirVwBqoHyIvv5IImd.jpg",
    firstAirDate: "2019-06-16",
    genreIds: [18],
    id: 85552,
    name: "Euphoria",
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Euphoria",
    overview:
        "A group of high school students navigate love and friendships in a world of drugs, sex, trauma, and social media.",
    popularity: 4532.872,
    posterPath: "/jtnfNzqZwN4E32FGGxx1YZaBWWf.jpg",
    voteAverage: 8.4,
    voteCount: 5986,
  );

  const tTvSeries = TvSeries(
    backdropPath: "/oKt4J3TFjWirVwBqoHyIvv5IImd.jpg",
    firstAirDate: "2019-06-16",
    genreIds: [18],
    id: 85552,
    name: "Euphoria",
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Euphoria",
    overview:
        "A group of high school students navigate love and friendships in a world of drugs, sex, trauma, and social media.",
    popularity: 4532.872,
    posterPath: "/jtnfNzqZwN4E32FGGxx1YZaBWWf.jpg",
    voteAverage: 8.4,
    voteCount: 5986,
  );

  test('should be subclass of TvSeries entity', () async {
    final result = testTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });
}
