import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/watchlist_tvseries/watchlist_tvseries_bloc.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  const WatchlistTvSeriesPage({Key? key}) : super(key: key);

  @override
  _WatchlistTvSeriesPageState createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WatchlistTvseriesBloc>().add(OnWatchlistTvseriesCalled()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTvseriesBloc>().add(OnWatchlistTvseriesCalled());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('watchlist_tvseries_content'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvseriesBloc, WatchlistTvseriesState>(
          builder: (context, state) {
            if (state is WatchlistTvseriesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistTvseriesHasData) {
              final watchlistTvseries = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvserie = watchlistTvseries[index];
                  return TvSeriesCard(tvserie);
                },
                itemCount: watchlistTvseries.length,
              );
            } else if (state is WatchlistTvseriesEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "You don't have whistlist of tv series yet, you can add from list tv series",
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        homeRoute,
                        (route) => false,
                      ),
                      child: const Text('Add Whistlist'),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text('Failed to fetch data'),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
