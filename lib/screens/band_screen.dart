import 'package:band_management/constants/genres.dart';
import 'package:band_management/constants/instruments.dart';
import 'package:band_management/state/app_state.dart';
import 'package:band_management/structs/band.dart';
import 'package:band_management/structs/member.dart';
import 'package:band_management/structs/song.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scroll_animator/scroll_animator.dart';
import 'package:watch_it/watch_it.dart';

class BandScreen extends StatefulWidget {
  const BandScreen({required this.id, super.key});

  final int id;

  @override
  State<BandScreen> createState() => _BandScreenState();
}

class _BandScreenState extends State<BandScreen> {
  late final ScrollController scrollController;
  late Band activeBand;

  List<Member> get members => di<AppState>().readMembers(widget.id);
  List<Song> get songs => di<AppState>().readSongs(widget.id);

  @override
  void initState() {
    super.initState();

    scrollController = AnimatedScrollController(animationFactory: ChromiumImpulse());
    activeBand = di<AppState>().readBand(widget.id);
  }

  @override
  void didUpdateWidget(BandScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.id != widget.id) {
      activeBand = di<AppState>().readBand(widget.id);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Band Name
            Text(
              activeBand.name,
              style: TextStyle(fontSize: 24.0),
            ),

            const SizedBox(height: 16.0),

            // Image
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: AspectRatio(
                aspectRatio: 2.0,
                child: Image.asset(genres[activeBand.genreId]!.path),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Container(
                height: 1.0,
                color: Colors.grey.shade200,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Text("Members:", style: TextStyle(fontSize: 20.0)),
                    Column(
                      children: [
                        for (final member in members)
                          ListTile(
                            title: Text(member.name),
                            subtitle: Text(instruments[member.instrumentId]!.name),
                            leading: Icon(instruments[member.instrumentId]!.icon),
                          ),
                        ListTile(
                          title: ElevatedButton(
                            onPressed: () {
                              context.go('/home/band/${widget.id}/add-member');
                            },
                            child: Text("Add Member"),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        height: 1.0,
                        color: Colors.grey.shade200,
                      ),
                    ),
                    Text("Songs:", style: TextStyle(fontSize: 20.0)),
                    Column(
                      children: [
                        for (var song in songs)
                          ListTile(
                            title: Text(song.name),
                            subtitle: Text(song.year.toString()),
                          ),
                        ListTile(
                          title: ElevatedButton(
                            onPressed: () {
                              context.go('/home/band/${widget.id}/add-song');
                            },
                            child: Text("Add Song"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
