import 'dart:convert';

import 'package:core/data/models/tvseries_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  group('fromJson testing', () {
    test('should return a valid model from JSON', () {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/on_the_air.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, testTvSeriesResponse);
    });
  });

  group('toJson testing', () {
    test(
        'should return a JSON map containing proper data of tv series response',
        () async {
      // arrange

      // act
      final result = testTvSeriesResponse.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/oKt4J3TFjWirVwBqoHyIvv5IImd.jpg",
            "first_air_date": "2019-06-16",
            "genre_ids": [18],
            "id": 85552,
            "name": "Euphoria",
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "Euphoria",
            "overview":
                "A group of high school students navigate love and friendships in a world of drugs, sex, trauma, and social media.",
            "popularity": 4532.872,
            "poster_path": "/jtnfNzqZwN4E32FGGxx1YZaBWWf.jpg",
            "vote_average": 8.4,
            "vote_count": 5986
          }
        ]
      };
      expect(result, expectedJsonMap);
    });
  });
}
