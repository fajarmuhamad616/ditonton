import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/movie_table.dart';
import 'package:core/data/models/season_model.dart';
import 'package:core/data/models/tvseries_detail_model.dart';
import 'package:core/data/models/tvseries_model.dart';
import 'package:core/data/models/tvseries_response.dart';
import 'package:core/data/models/tvseries_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/tvseries_show.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: const [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testTvSeriesModel = TvSeriesModel(
  backdropPath: "/oKt4J3TFjWirVwBqoHyIvv5IImd.jpg",
  firstAirDate: "2019-06-16",
  genreIds: [18],
  id: 85552,
  name: "Euphoria",
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "Euphoria",
  overview:
      "A group of high school students navigate love and friendships in a world of drugs, sex, trauma, and social media.",
  popularity: 4532.872,
  posterPath: "/jtnfNzqZwN4E32FGGxx1YZaBWWf.jpg",
  voteAverage: 8.4,
  voteCount: 5986,
);

final testTvSeriesModelList = <TvSeriesModel>[testTvSeriesModel];

final testTvSeries = testTvSeriesModel.toEntity();

final testTvList = <TvSeries>[testTvSeries];

final testTvSeriesResponse =
    TvSeriesResponse(tvSeriesList: testTvSeriesModelList);

const testTvSeriesDetailResponse = TvSeriesDetailResponse(
  backdropPath: '',
  episodeRunTime: [],
  firstAirDate: '',
  genres: [GenreModel(id: 1, name: 'Comedy')],
  homepage: '',
  id: 1,
  name: 'name',
  numberOfEpisodes: 0,
  numberOfSeasons: 0,
  originalLanguage: 'en',
  originalName: 'W*A*L*T*E*R',
  overview: "overview",
  popularity: 2.165,
  posterPath: "posterPath",
  seasons: [
    SeasonModel(
        airDate: "1984-07-17",
        episodeCount: 1,
        id: 2328167,
        name: "Specials",
        overview: "",
        posterPath: null,
        seasonNumber: 0)
  ],
  status: "Ended",
  tagline: "",
  type: "Scripted",
  voteAverage: 6.1,
  voteCount: 5,
);

final testTvSeriesDetail = testTvSeriesDetailResponse.toEntity();

final testTvSeriesTable = TvSeriesTable.fromEntity(testTvSeriesDetail);

final testTvSeriesTableList = <TvSeriesTable>[testTvSeriesTable];

final testWatchlistTvSeries = [testTvSeriesTable.toEntity()];

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTvSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'name',
};
