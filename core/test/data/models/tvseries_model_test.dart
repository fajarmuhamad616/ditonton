import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('Should be a subclass of Tv Series entity', () {
    final result = testTvSeriesModel.toEntity();
    expect(result, testTvSeries);
  });
}
