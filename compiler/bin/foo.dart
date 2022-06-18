import 'dart:io' as io;

import 'package:midi_util/midi_util.dart';

Future<void> main() async {
  const List<int> notes = [60, 62, 64, 65, 67, 69, 71, 72];
  const int track = 0;
  const int channel = 0; // ?!
  const int bpm = 120;
  const int start = 0; // in beats
  const double duration = 0.5; // in beats
  const int volume = 127; // 0-127

  final MIDIFile file = MIDIFile(numTracks: 1);
  file.addTempo(
    track: track,
    tempo: bpm,
    time: start,
  );
  file.addKeySignature(
    track: track,
    time: start,
    no_of_accidentals: 0,
    accidental_mode: AccidentalMode.MAJOR,
    accidental_type: AccidentalType.FLATS,
  );

  for (int i = 0; i < notes.length; i += 1) {
    file.addNote(
      track: track,
      channel: channel,
      pitch: notes[i],
      time: start + i,
      duration: duration,
      volume: volume,
    );
  }

  final io.Directory build = io.Directory('build');
  build.createSync(recursive: true);
  // TODO make windows compat
  final io.File outputFile = io.File('build/c_scale.midi');
  file.writeFile(outputFile);
}
