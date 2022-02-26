import 'package:dartz/dartz.dart';

import '../../../utils/failure.dart';
import '../../entities/tvseries_show.dart';
import '../../repositories/tvseries_repository.dart';

class GetOnTheAirTvSeries {
  final TvSeriesRepository repository;

  GetOnTheAirTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getOnTheAirTvSeries();
  }
}
