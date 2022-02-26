import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchListStatusMovies _getWatchListStatusMovies;
  final RemoveWatchlistMovies _removeWatchlistMovies;
  final SaveWatchlistMovies _saveWatchlistMovies;
  WatchlistMoviesBloc(
    this._getWatchlistMovies,
    this._getWatchListStatusMovies,
    this._removeWatchlistMovies,
    this._saveWatchlistMovies,
  ) : super(WatchlistMoviesEmpty()) {
    on<OnWatchlistMoviesCalled>((event, emit) async {
      emit(WatchlistMoviesLoading());
      final result = await _getWatchlistMovies.execute();

      result.fold(
          (failure) => emit(WatchlistMoviesError(failure.message)),
          (data) => data.isNotEmpty
              ? emit(WatchlistMoviesHasData(data))
              : emit(
                  WatchlistMoviesEmpty(),
                ));
    });

    on<FetchWatchlistStatus>(((event, emit) async {
      final id = event.id;

      final result = await _getWatchListStatusMovies.execute(id);

      emit(WatchlistMoviesIsAdded(result));
    }));

    on<AddMovieToWatchlist>(
      ((event, emit) async {
        final movie = event.movieDetail;

        final result = await _saveWatchlistMovies.execute(movie);

        result.fold(
          (failure) => emit(WatchlistMoviesError(failure.message)),
          (message) => emit(
            WatchlistMoviesMessage(message),
          ),
        );
      }),
    );

    on<RemoveMovieFromWatchlist>(
      ((event, emit) async {
        final movie = event.movieDetail;

        final result = await _removeWatchlistMovies.execute(movie);

        result.fold(
          (failure) => emit(WatchlistMoviesError(failure.message)),
          (message) => emit(
            WatchlistMoviesMessage(message),
          ),
        );
      }),
    );
  }
}
