import 'package:band_management/screens/add_band_screen.dart';
import 'package:band_management/screens/add_member_screen.dart';
import 'package:band_management/screens/add_song_screen.dart';
import 'package:band_management/screens/band_screen.dart';
import 'package:band_management/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final keys = (root: GlobalKey<NavigatorState>(),);

final router = GoRouter(
  initialLocation: "/home",
  routes: [
    ShellRoute(
      navigatorKey: keys.root,
      builder: (context, state, child) => Material(
        color: Colors.white,
        child: child,
      ),
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) => const SizedBox(),
          routes: [
            GoRoute(
              path: "home",
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: "add-band",
                  builder: (context, state) => const AddBandScreen(),
                ),
                GoRoute(
                  path: "band/:id",
                  builder: (context, state) =>
                      BandScreen(id: int.parse(state.pathParameters['id']!)),
                  routes: [
                    GoRoute(
                      path: "add-member",
                      builder: (context, state) =>
                          AddMemberScreen(bandId: int.parse(state.pathParameters['id']!)),
                    ),
                    GoRoute(
                      path: "add-song",
                      builder: (context, state) =>
                          AddSongScreen(bandId: int.parse(state.pathParameters['id']!)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    ),
  ],
);
