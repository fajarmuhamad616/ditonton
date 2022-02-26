part of 'now_playing_movies_bloc.dart';

@immutable
abstract class NowPlayingMovieEvent extends Equatable {}

class NowPlayingMovie extends NowPlayingMovieEvent {
  @override
  List<Object> get props => [];
}
