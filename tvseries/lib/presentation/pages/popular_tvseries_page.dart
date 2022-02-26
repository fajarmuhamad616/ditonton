import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/popular_tvseries/popular_tvseries_bloc.dart';

class PopularTvSeriesPage extends StatefulWidget {
  @override
  _PopularTvSeriesPageState createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<PopularTvseriesBloc>().add(OnPopularTvseriesCalled()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('popular_tvseries_content'),
      appBar: AppBar(
        title: Text('Popular Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvseriesBloc, PopularTvseriesState>(
          builder: (context, state) {
            if (state is PopularTvseriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTvseriesHasData) {
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
                child: Text((state as PopularTvseriesError).message),
              );
            }
          },
        ),
      ),
    );
  }
}
