import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/on_the_air_tvseries/on_the_air_tvseries_bloc.dart';
import '../bloc/popular_tvseries/popular_tvseries_bloc.dart';
import '../bloc/top_rated_tvseries/top_rated_tvseries_bloc.dart';

class HomeTvSeriesPage extends StatefulWidget {
  const HomeTvSeriesPage({Key? key}) : super(key: key);

  @override
  _HomeTvSeriesPageState createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OnTheAirTvseriesBloc>().add(OnTheAirTvseries());
      context.read<PopularTvseriesBloc>().add(OnPopularTvseriesCalled());
      context.read<TopRatedTvseriesBloc>().add(OnTopRatedTvseriesCalled());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'On The Air',
              style: kHeading6,
            ),
            BlocBuilder<OnTheAirTvseriesBloc, OnTheAirTvseriesState>(
                builder: (context, state) {
              if (state is OnTheAirTvseriesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is OnTheAirTvseriesHasData) {
                final data = state.result;
                return TvSeriesList(data);
              } else if (state is OnTheAirTvseriesError) {
                return const Text(
                  'Failed to fetch data',
                  key: const Key('error_message'),
                );
              } else {
                return Container();
              }
            }),
            _buildSubHeading(
              title: 'Popular',
              onTap: () => Navigator.pushNamed(context, popularMoviesRoute),
            ),
            BlocBuilder<PopularTvseriesBloc, PopularTvseriesState>(
                builder: (context, state) {
              if (state is PopularTvseriesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PopularTvseriesHasData) {
                final data = state.result;
                return TvSeriesList(data);
              } else if (state is PopularTvseriesError) {
                return const Text(
                  'Failed to fetch data',
                  key: const Key('error_message'),
                );
              } else {
                return Container();
              }
            }),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(context, topRatedTvSeriesRoute),
            ),
            BlocBuilder<TopRatedTvseriesBloc, TopRatedTvseriesState>(
                builder: (context, state) {
              if (state is TopRatedTvseriesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TopRatedTvseriesHasData) {
                final data = state.result;
                return TvSeriesList(data);
              } else if (state is TopRatedTvseriesError) {
                return const Text(
                  'Failed to fetch data',
                  key: const Key('error_message'),
                );
              } else {
                return Container();
              }
            }),
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  TvSeriesList(this.tvSeries);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvSerie = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  tvSeriesDetailRoute,
                  arguments: tvSerie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvSerie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
