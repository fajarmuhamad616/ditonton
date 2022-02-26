import 'package:dartz/dartz.dart';

import '../../../utils/failure.dart';
import '../../entities/tvseries_detail.dart';
import '../../repositories/tvseries_repository.dart';

class GetTvSeriesDetail {
  final TvSeriesRepository repository;

  GetTvSeriesDetail(this.repository);

  Future<Either<Failure, TvSeriesDetail>> execute(int id) {
    return repository.getTvSeriesDetail(id);
  }
}
