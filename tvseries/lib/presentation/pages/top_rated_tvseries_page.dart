import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/top_rated_tvseries/top_rated_tvseries_bloc.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  const TopRatedTvSeriesPage({Key? key}) : super(key: key);

  @override
  _TopRatedTvSeriesPageState createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<TopRatedTvseriesBloc>().add(OnTopRatedTvseriesCalled()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('top_rated_tvseries_content'),
      appBar: AppBar(
        title: Text('Top Rated Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvseriesBloc, TopRatedTvseriesState>(
          builder: (context, state) {
            if (state is TopRatedTvseriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvseriesHasData) {
              final tvSeries = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSerie = tvSeries[index];
                  return TvSeriesCard(tvSerie);
                },
                itemCount: tvSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text((state as TopRatedTvseriesError).message),
              );
            }
          },
        ),
      ),
    );
  }
}
