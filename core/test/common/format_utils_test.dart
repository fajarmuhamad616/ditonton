import 'package:core/domain/entities/genre.dart';
import 'package:core/utils/format_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final singleGenres = [
    Genre(id: 1, name: 'genre1'),
  ];

  final multiGenres = [
    Genre(id: 1, name: 'genre1'),
    Genre(id: 2, name: 'genre2'),
  ];

  group('showFormatGenres testing', () {
    test('should suitable with expected type string with single genres', () {
      final expected = 'genre1';
      final result = showFormatGenres(singleGenres);
      expect(result, expected);
    });
    test('should suitable with expected type string with multi genres', () {
      final expected = 'genre1, genre2';
      final result = showFormatGenres(multiGenres);
      expect(result, expected);
    });
  });

  group('showFormatDuration testing', () {
    test(
        'should suitable with expected with only format duration minute type string',
        () {
      final expected = '27m';
      final result = showFormatDuration(27);
      expect(result, expected);
    });
    test(
        'should suitable with expected with only format duration hour and minute type string',
        () {
      final expected = '2h 27m';
      final result = showFormatDuration(147);
      expect(result, expected);
    });
  });

  group('showFormatDurationFromList', () {
    test(
        'should suitable with expected with only format list minute and hour minute type string ',
        () {
      final expected = '27m, 2h 27m';
      final result = showFormatDurationFromList([27, 147]);
      expect(result, expected);
    });
    test(
        'should suitable with expected with only format list minute type string ',
        () {
      final expected = '27m';
      final result = showFormatDurationFromList([27]);
      expect(result, expected);
    });
  });
}
