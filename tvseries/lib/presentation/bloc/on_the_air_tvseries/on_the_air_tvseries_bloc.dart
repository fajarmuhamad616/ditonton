import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'on_the_air_tvseries_event.dart';
part 'on_the_air_tvseries_state.dart';

class OnTheAirTvseriesBloc
    extends Bloc<OnTheAirTvseriesEvent, OnTheAirTvseriesState> {
  final GetOnTheAirTvSeries _getOnTheAirTvseriess;
  OnTheAirTvseriesBloc(this._getOnTheAirTvseriess)
      : super(OnTheAirTvseriesEmpty()) {
    on<OnTheAirTvseries>((event, emit) async {
      emit(OnTheAirTvseriesLoading());

      final result = await _getOnTheAirTvseriess.execute();

      result.fold((failure) {
        emit(OnTheAirTvseriesError(failure.message));
      }, (data) {
        data.isNotEmpty
            ? emit(OnTheAirTvseriesHasData(data))
            : emit(OnTheAirTvseriesEmpty());
      });
    });
  }
}
