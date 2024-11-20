import 'package:band_management/constants/instruments.dart';
import 'package:band_management/state/app_state.dart';
import 'package:band_management/structs/band.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scroll_animator/scroll_animator.dart';
import 'package:watch_it/watch_it.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({required this.bandId, super.key});

  final int bandId;

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  late final ScrollController scrollController;
  late final TextEditingController memberNameController;
  late final ValueNotifier<String?> genre;
  late final GlobalKey<FormState> formKey;

  Band get band => di<AppState>().readBand(widget.bandId);

  @override
  void initState() {
    super.initState();

    scrollController = AnimatedScrollController(animationFactory: ChromiumImpulse());
    memberNameController = TextEditingController();
    genre = ValueNotifier<String?>(null);
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    scrollController.dispose();
    memberNameController.dispose();

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
                title: Center(child: Text("New Member for ${band.name}")),
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
                            Text("Member Name:"),
                            TextFormField(
                              controller: memberNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a name";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "e.g. John Doe",
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
                            Text("Instrument:"),
                            DropdownButtonFormField<String>(
                              value: genre.value,
                              validator: (value) {
                                if (value == null) {
                                  return "Please select a instrument";
                                }
                                return null;
                              },
                              items: [
                                for (var MapEntry(:key, :value) in instruments.entries)
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

                          await di<AppState>().createMember(
                            name: memberNameController.text,
                            bandId: widget.bandId,
                            instrumentId: genre.value!,
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
