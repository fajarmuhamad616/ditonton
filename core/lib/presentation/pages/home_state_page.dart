import 'package:flutter/material.dart';
import 'package:movies/movies.dart';
import 'package:tvseries/tvseries.dart';

import '../../styles/colors.dart';
import '../../utils/drawer_state_enum.dart';
import '../../utils/routes.dart';

class HomePageState extends StatefulWidget {
  const HomePageState({Key? key}) : super(key: key);

  @override
  State<HomePageState> createState() => _HomePageStateState();
}

class _HomePageStateState extends State<HomePageState> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  DrawerStateEnum _selectedDrawerState = DrawerStateEnum.Movies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer:
          _buildDrawerState(context, (DrawerStateEnum selectedDrawerNewState) {
        setState(() {
          _selectedDrawerState = selectedDrawerNewState;
        });
      }, _selectedDrawerState),
      appBar: _buildAppBarState(context, _selectedDrawerState),
      body: _buildBodyState(context, _selectedDrawerState),
    );
  }
}

Drawer _buildDrawerState(
    BuildContext context,
    Function(DrawerStateEnum) stateCallback,
    DrawerStateEnum activeDrawerState) {
  return Drawer(
    child: Column(
      children: [
        const UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage('assets/circle-g.png'),
          ),
          accountName: Text('Ditonton'),
          accountEmail: Text('ditonton@dicoding.com'),
        ),
        ListTile(
          tileColor:
              activeDrawerState == DrawerStateEnum.Movies ? kOxfordBlue : kGrey,
          leading: const Icon(Icons.movie),
          title: const Text('Movies'),
          onTap: () {
            Navigator.pop(context);
            stateCallback(DrawerStateEnum.Movies);
          },
        ),
        ListTile(
          tileColor: activeDrawerState == DrawerStateEnum.TvSeries
              ? kOxfordBlue
              : kGrey,
          leading: const Icon(Icons.live_tv),
          title: const Text('Tv Series'),
          onTap: () {
            Navigator.pop(context);
            stateCallback(DrawerStateEnum.TvSeries);
          },
        ),
        ListTile(
          leading: const Icon(Icons.save_alt),
          title: const Text('Watchlist'),
          onTap: () {
            Navigator.pushNamed(context, watchlistRoute);
          },
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, aboutRoute);
          },
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
        ),
      ],
    ),
  );
}

AppBar _buildAppBarState(
    BuildContext context, DrawerStateEnum activeDrawerState) {
  return AppBar(
    title: Text(
        'Ditonton ${activeDrawerState == DrawerStateEnum.Movies ? 'Movies' : 'Tv Series'}'),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, searchRoute,
              arguments: activeDrawerState);
        },
        icon: const Icon(Icons.search),
      )
    ],
  );
}

Widget _buildBodyState(
    BuildContext context, DrawerStateEnum selectedDrawerState) {
  if (selectedDrawerState == DrawerStateEnum.Movies) {
    return HomeMoviePage();
  } else if (selectedDrawerState == DrawerStateEnum.TvSeries) {
    return const HomeTvSeriesPage();
  }
  return Container();
}
