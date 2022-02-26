import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/search.dart';

import 'tvseries_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvseriesSearchBloc tvseriesSearchBloc;
  late MockSearchTvSeries mockSearchTvSeries;

  final tTvSeriesModel = TvSeries(
    backdropPath: "/maFEWU41jdUOzDfRVkojq7fluIm.jpg",
    firstAirDate: "1999-05-01",
    genreIds: const [16, 35, 10751, 10765],
    id: 387,
    name: "SpongeBob SquarePants",
    originCountry: const ["US"],
    originalLanguage: "en",
    originalName: "SpongeBob SquarePants",
    overview:
        "Deep down in the Pacific Ocean in the subterranean city of Bikini Bottom lives a square yellow sponge named SpongeBob SquarePants. SpongeBob lives in a pineapple with his pet snail, Gary, loves his job as a fry cook at the Krusty Krab, and has a knack for getting into all kinds of trouble without really trying. When he's not getting on the nerves of his cranky next door neighbor Squidward, SpongeBob can usually be found smack in the middle of all sorts of strange situations with his best buddy, the simple yet lovable starfish, Patrick, or his thrill-seeking surfer-girl squirrel pal, Sandy Cheeks.",
    popularity: 28.232,
    posterPath: "/vvBdR6XmSQFNgin9tzmMlsrWBgM.jpg",
    voteAverage: 7.5,
    voteCount: 2332,
  );
  final tTvSeriesList = <TvSeries>[tTvSeriesModel];
  const tQuery = 'Spongebob';

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    tvseriesSearchBloc = TvseriesSearchBloc(mockSearchTvSeries);
  });

  test('initial state should be empty', () {
    expect(tvseriesSearchBloc.state, TvseriesSearchEmpty());
  });

  blocTest<TvseriesSearchBloc, TvseriesSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvSeriesList));
      return tvseriesSearchBloc;
    },
    act: (bloc) => bloc.add(TvSeriesOnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvseriesSearchLoading(),
      TvseriesHasData(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );

  blocTest<TvseriesSearchBloc, TvseriesSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvseriesSearchBloc;
    },
    act: (bloc) => bloc.add(TvSeriesOnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvseriesSearchLoading(),
      TvseriesSearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
}
