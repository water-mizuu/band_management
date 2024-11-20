import 'package:band_management/constants/genres.dart';
import 'package:band_management/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scroll_animator/scroll_animator.dart';
import 'package:watch_it/watch_it.dart';

class AddBandScreen extends StatefulWidget {
  const AddBandScreen({super.key});

  @override
  State<AddBandScreen> createState() => _AddBandScreenState();
}

class _AddBandScreenState extends State<AddBandScreen> {
  late final ScrollController scrollController;
  late final TextEditingController bandNameController;
  late final ValueNotifier<String?> genre;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();

    scrollController = AnimatedScrollController(animationFactory: ChromiumImpulse());
    bandNameController = TextEditingController();
    genre = ValueNotifier<String?>(null);
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    scrollController.dispose();
    bandNameController.dispose();

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
                title: Center(child: Text("New Band")),
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
                            Text("Band Name:"),
                            TextFormField(
                              controller: bandNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a band name";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "e.g. Metallica",
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
                            Text("Genre:"),
                            DropdownButtonFormField<String>(
                              value: genre.value,
                              validator: (value) {
                                if (value == null) {
                                  return "Please select a genre";
                                }
                                return null;
                              },
                              items: [
                                for (var MapEntry(:key, :value) in genres.entries)
                                  DropdownMenuItem<String>(
                                    value: key,
                                    child: Text(value.name),
                                  )
                              ],
                              onChanged: (String? value) {
                                genre.value = value;
                              },
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
      
                          await di<AppState>().createBand(
                            name: bandNameController.text,
                            genreId: genre.value!,
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
