import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tvseries_event.dart';
part 'top_rated_tvseries_state.dart';

class TopRatedTvseriesBloc
    extends Bloc<TopRatedTvseriesEvent, TopRatedTvseriesState> {
  final GetTopRatedTvSeries _getTopRatedTvseries;
  TopRatedTvseriesBloc(this._getTopRatedTvseries)
      : super(TopRatedTvseriesEmpty()) {
    on<OnTopRatedTvseriesCalled>((event, emit) async {
      emit(TopRatedTvseriesLoading());
      final result = await _getTopRatedTvseries.execute();

      result.fold(
        (failure) => emit(TopRatedTvseriesError(failure.message)),
        (data) => data.isNotEmpty
            ? emit(TopRatedTvseriesHasData(data))
            : emit(TopRatedTvseriesEmpty()),
      );
    });
  }
}
