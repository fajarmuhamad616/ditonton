import 'package:dartz/dartz.dart';

import '../../../utils/failure.dart';
import '../../entities/tvseries_detail.dart';
import '../../repositories/tvseries_repository.dart';

class RemoveWatchlistTvSeries {
  final TvSeriesRepository repository;

  RemoveWatchlistTvSeries(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail tvSeries) {
    return repository.removeWatchlist(tvSeries);
  }
}
