import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:meta/meta.dart';

part 'now_playing_movies_event.dart';
part 'now_playing_movies_state.dart';

class NowPlayingMovieBloc
    extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  NowPlayingMovieBloc(this._getNowPlayingMovies)
      : super(NowPlayingMovieEmpty()) {
    on<NowPlayingMovie>((event, emit) async {
      emit(NowPlayingMovieLoading());

      final result = await _getNowPlayingMovies.execute();

      result.fold((failure) {
        emit(NowPlayingMovieError(failure.message));
      }, (data) {
        data.isNotEmpty
            ? emit(NowPlayingMovieHasData(data))
            : emit(NowPlayingMovieEmpty());
      });
    });
  }
}
