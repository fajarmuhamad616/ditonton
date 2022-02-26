import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/presentation/bloc/on_the_air_tvseries/on_the_air_tvseries_bloc.dart';

import '../dummy_data/dummy_objects.dart';
import 'now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvSeries])
void main() {
  late MockGetOnTheAirTvSeries mockGetOnTheAirTvseries;
  late OnTheAirTvseriesBloc onTheAirTvseriesBloc;

  setUp(() {
    mockGetOnTheAirTvseries = MockGetOnTheAirTvSeries();
    onTheAirTvseriesBloc = OnTheAirTvseriesBloc(mockGetOnTheAirTvseries);
  });

  test('the OnTheAirTvseriesBloc initial state should be empty ', () {
    expect(onTheAirTvseriesBloc.state, OnTheAirTvseriesEmpty());
  });

  blocTest<OnTheAirTvseriesBloc, OnTheAirTvseriesState>(
      'should emits OnTheAirTvseriesLoading state and then OnTheAirTvseriesHasData state when data is successfully fetched..',
      build: () {
        when(mockGetOnTheAirTvseries.execute())
            .thenAnswer((_) async => Right(testTvList));
        return onTheAirTvseriesBloc;
      },
      act: (bloc) => bloc.add(OnTheAirTvseries()),
      expect: () => <OnTheAirTvseriesState>[
            OnTheAirTvseriesLoading(),
            OnTheAirTvseriesHasData(testTvList),
          ],
      verify: (bloc) {
        verify(mockGetOnTheAirTvseries.execute());
        return OnTheAirTvseries().props;
      });

  blocTest<OnTheAirTvseriesBloc, OnTheAirTvseriesState>(
    'should emits OnTheAirTvseriesLoading state and then OnTheAirTvseriesError state when data is failed fetched..',
    build: () {
      when(mockGetOnTheAirTvseries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return onTheAirTvseriesBloc;
    },
    act: (bloc) => bloc.add(OnTheAirTvseries()),
    expect: () => <OnTheAirTvseriesState>[
      OnTheAirTvseriesLoading(),
      OnTheAirTvseriesError('Server Failure'),
    ],
    verify: (bloc) => OnTheAirTvseriesLoading(),
  );

  blocTest<OnTheAirTvseriesBloc, OnTheAirTvseriesState>(
    'should emits OnTheAirTvseriesLoading state and then OnTheAirTvseriesEmpty state when data is retrieved empty..',
    build: () {
      when(mockGetOnTheAirTvseries.execute())
          .thenAnswer((_) async => const Right([]));
      return onTheAirTvseriesBloc;
    },
    act: (bloc) => bloc.add(OnTheAirTvseries()),
    expect: () => <OnTheAirTvseriesState>[
      OnTheAirTvseriesLoading(),
      OnTheAirTvseriesEmpty(),
    ],
  );
}
