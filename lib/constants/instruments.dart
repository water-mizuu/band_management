import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef Instrument = ({
  String name,
  IconData icon,
});

const instruments = <String, Instrument>{
  'vocal': (
    name: 'Vocal',
    icon: Icons.mic,
  ),
  'guitar': (
    name: 'Guitar',
    icon: FontAwesomeIcons.guitar,
  ),
  'bass': (
    name: 'Bass',
    icon: CupertinoIcons.guitars,
  ),
  'keyboard': (
    name: 'Keyboard',
    icon: Icons.piano,
  ),
  'drums': (
    name: 'Drums',
    icon: FontAwesomeIcons.drum,
  ),
};
