import 'package:band_management/state/app_state.dart';
import 'package:band_management/structs/band.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scroll_animator/scroll_animator.dart';
import 'package:watch_it/watch_it.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({required this.bandId, super.key});

  final int bandId;

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  late final ScrollController scrollController;
  late final TextEditingController songNameController;
  late final TextEditingController yearController;
  late final GlobalKey<FormState> formKey;

  Band get band => di<AppState>().readBand(widget.bandId);

  @override
  void initState() {
    super.initState();

    scrollController = AnimatedScrollController(animationFactory: ChromiumImpulse());
    songNameController = TextEditingController();
    yearController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    scrollController.dispose();
    songNameController.dispose();
    yearController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Form(
        key: formKey,
        child: Material(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                title: Center(child: Text("New Song for ${band.name}")),
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// Member Name
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Song Name:"),
                            TextFormField(
                              controller: songNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a song name";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "e.g. Enter Sandman",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.only(bottom: 2.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Release Year:"),
                            TextFormField(
                              controller: yearController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please select a year";
                                }
                                if (int.tryParse(value) == null) {
                                  return "Please enter a valid year";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "e.g. 2019",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.only(bottom: 2.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: Text("Back"),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          await di<AppState>().createSong(
                            name: songNameController.text,
                            bandId: widget.bandId,
                            year: int.parse(yearController.text),
                          );

                          if (context.mounted) {
                            context.pop();
                          }
                        },
                        child: Text("Save"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
