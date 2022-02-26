import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tvseries_detail/tvseries_detail_bloc.dart';
import '../bloc/tvseries_recommendations/tvseries_recommendations_bloc.dart';
import '../bloc/watchlist_tvseries/watchlist_tvseries_bloc.dart';

class TvSeriesDetailPage extends StatefulWidget {
  final int id;
  const TvSeriesDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvseriesDetailBloc>().add(OnTvseriesDetailCalled(widget.id));
      context
          .read<TvseriesRecommendationsBloc>()
          .add(OnTvseriesRecommendationsCalled(widget.id));
      context
          .read<WatchlistTvseriesBloc>()
          .add(FetchWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTvseriesAddedToWatchlist =
        context.select<WatchlistTvseriesBloc, bool>((bloc) {
      if (bloc.state is WatchlistTvseriesIsAdded) {
        return (bloc.state as WatchlistTvseriesIsAdded).isAdded;
      }
      return false;
    });

    return Scaffold(
      key: const Key('tvseries_detail_content'),
      body: BlocBuilder<TvseriesDetailBloc, TvseriesDetailState>(
        builder: (context, state) {
          if (state is TvseriesDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvseriesDetailHasData) {
            final tvSerie = state.result;
            return SafeArea(
              child: DetailContentTvSeries(
                tvSerie,
                isTvseriesAddedToWatchlist,
              ),
            );
          } else {
            return Text('Failed to fetch data');
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class DetailContentTvSeries extends StatefulWidget {
  final TvSeriesDetail tvSeries;
  late bool isAddedWatchlist;

  DetailContentTvSeries(this.tvSeries, this.isAddedWatchlist, {Key? key})
      : super(key: key);

  @override
  State<DetailContentTvSeries> createState() => _DetailContentTvSeriesState();
}

class _DetailContentTvSeriesState extends State<DetailContentTvSeries> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl:
              'https://image.tmdb.org/t/p/w500${widget.tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tvSeries.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!widget.isAddedWatchlist) {
                                  context.read<WatchlistTvseriesBloc>().add(
                                      AddTvseriesToWatchlist(widget.tvSeries));
                                } else {
                                  context.read<WatchlistTvseriesBloc>().add(
                                      RemoveTvseriesFromWatchlist(
                                          widget.tvSeries));
                                }

                                String message = "";
                                const watchlistAddSuccessMessage =
                                    'Added to Watchlist';
                                const watchlistRemoveSuccessMessage =
                                    'Removed from Watchlist';

                                final state =
                                    BlocProvider.of<WatchlistTvseriesBloc>(
                                            context)
                                        .state;

                                if (state is WatchlistTvseriesIsAdded) {
                                  final isAdded = state.isAdded;
                                  message = isAdded == false
                                      ? watchlistAddSuccessMessage
                                      : watchlistRemoveSuccessMessage;
                                } else {
                                  message = !widget.isAddedWatchlist
                                      ? watchlistAddSuccessMessage
                                      : watchlistRemoveSuccessMessage;
                                }
                                if (message == watchlistAddSuccessMessage ||
                                    message == watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(message),
                                          duration: const Duration(
                                            milliseconds: 1000,
                                          )));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                                setState(() {
                                  widget.isAddedWatchlist =
                                      !widget.isAddedWatchlist;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              showFormatGenres(widget.tvSeries.genres),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildInfoTv(
                                  'Runtime: ${widget.tvSeries.episodeRunTime.isEmpty ? 'N/A' : showFormatDurationFromList(widget.tvSeries.episodeRunTime)}',
                                ),
                                const SizedBox(height: 10),
                                _buildInfoTv(
                                  'Episode: ${widget.tvSeries.numberOfEpisodes}',
                                ),
                                const SizedBox(height: 10),
                                _buildInfoTv(
                                  'Season: ${widget.tvSeries.numberOfSeasons}',
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.tvSeries.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.tvSeries.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            widget.tvSeries.seasons.isNotEmpty
                                ? SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final season =
                                            widget.tvSeries.seasons[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: Stack(
                                              children: [
                                                season.posterPath == null
                                                    ? Container(
                                                        width: 96.0,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: kDavysGrey,
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'Image not available',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            'https://image.tmdb.org/t/p/w500${season.posterPath}',
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                Positioned.fill(
                                                  child: Container(
                                                    color: kRichBlack
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: widget.tvSeries.seasons.length,
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      'Image not available',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvseriesRecommendationsBloc,
                                TvseriesRecommendationsState>(
                              builder: (context, state) {
                                if (state is TvseriesRecommendationsLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state
                                    is TvseriesRecommendationsError) {
                                  return Text(state.message);
                                } else if (state
                                    is TvseriesRecommendationsHasData) {
                                  final recommendations = state.result;
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tvSeries = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                tvSeriesDetailRoute,
                                                arguments: tvSeries.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else if (state
                                    is TvseriesRecommendationsEmpty) {
                                  return const Center(
                                    child: Text(
                                      'Recommendation is not available',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Container _buildInfoTv(data) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kOxfordBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        data,
      ),
    );
  }
}
