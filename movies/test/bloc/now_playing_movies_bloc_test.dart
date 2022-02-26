import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';

import '../dummy_data/dummy_objects.dart';
import 'now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovie;
  late NowPlayingMovieBloc nowPlayingMovieBloc;

  setUp(() {
    mockGetNowPlayingMovie = MockGetNowPlayingMovies();
    nowPlayingMovieBloc = NowPlayingMovieBloc(mockGetNowPlayingMovie);
  });

  test('the NowPlayingMovieBloc initial state should be empty ', () {
    expect(nowPlayingMovieBloc.state, NowPlayingMovieEmpty());
  });

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
      'should emits NowPlayingMovieLoading state and then NowPlayingMovieHasData state when data is successfully fetched..',
      build: () {
        when(mockGetNowPlayingMovie.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return nowPlayingMovieBloc;
      },
      act: (bloc) => bloc.add(NowPlayingMovie()),
      expect: () => <NowPlayingMovieState>[
            NowPlayingMovieLoading(),
            NowPlayingMovieHasData(testMovieList),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovie.execute());
        return NowPlayingMovie().props;
      });

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
    'should emits NowPlayingMovieLoading state and then NowPlayingMovieError state when data is failed fetched..',
    build: () {
      when(mockGetNowPlayingMovie.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(NowPlayingMovie()),
    expect: () => <NowPlayingMovieState>[
      NowPlayingMovieLoading(),
      NowPlayingMovieError('Server Failure'),
    ],
    verify: (bloc) => NowPlayingMovieLoading(),
  );

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
    'should emits NowPlayingMovieLoading state and then NowPlayingMovieEmpty state when data is retrieved empty..',
    build: () {
      when(mockGetNowPlayingMovie.execute())
          .thenAnswer((_) async => const Right([]));
      return nowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(NowPlayingMovie()),
    expect: () => <NowPlayingMovieState>[
      NowPlayingMovieLoading(),
      NowPlayingMovieEmpty(),
    ],
  );
}
