import 'package:band_management/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: di<AppState>(),
      builder: (context, _) {
        return Material(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 64.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Image.asset('assets/bandage_icon.png'),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final band in di<AppState>().bands)
                          ListTile(
                            title: Text(band.name),
                            onTap: () {
                              context.go('/home/band/${band.id}');
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/home/add-band');
                  },
                  child: Text('Add Band'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
