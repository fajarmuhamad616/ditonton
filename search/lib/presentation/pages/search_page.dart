import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_search/movie_search_bloc.dart';
import '../bloc/tvseries_search/tvseries_search_bloc.dart';

class SearchPage extends StatelessWidget {
  final DrawerStateEnum activeDrawerState;

  const SearchPage({Key? key, required this.activeDrawerState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search ${activeDrawerState == DrawerStateEnum.Movies ? 'Movies' : 'Tv Series'}',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                if (activeDrawerState == DrawerStateEnum.Movies) {
                  context
                      .read<MovieSearchBloc>()
                      .add(MovieOnQueryChanged(query));
                } else if (activeDrawerState == DrawerStateEnum.TvSeries) {
                  context
                      .read<TvseriesSearchBloc>()
                      .add(TvSeriesOnQueryChanged(query));
                }
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            if (activeDrawerState == DrawerStateEnum.Movies)
              _buildSearchMovie(),
            if (activeDrawerState == DrawerStateEnum.TvSeries)
              _buildSearchTvSeries(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchMovie() {
    return BlocBuilder<MovieSearchBloc, MovieSearchState>(
      builder: (context, state) {
        if (state is MovieSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MovieSearchHasData) {
          final result = state.result;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final movie = result[index];
                return MovieCard(movie);
              },
              itemCount: result.length,
            ),
          );
        } else if (state is MovieSearchError) {
          return Expanded(
            child: Center(
              child: Text(state.message),
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }

  Widget _buildSearchTvSeries() {
    return BlocBuilder<TvseriesSearchBloc, TvseriesSearchState>(
      builder: (context, state) {
        if (state is TvseriesSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvseriesHasData) {
          final result = state.result;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final tvSerie = state.result[index];
                return TvSeriesCard(tvSerie);
              },
              itemCount: result.length,
            ),
          );
        } else if (state is TvseriesSearchError) {
          return Expanded(
            child: Center(
              child: Text(state.message),
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }
}
