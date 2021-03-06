part of 'movie_search_bloc.dart';

@immutable
abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object> get props => [];
}

class MovieOnQueryChanged extends MovieSearchEvent {
  final String query;

  MovieOnQueryChanged(this.query);

  List<Object> get props => [query];
}
