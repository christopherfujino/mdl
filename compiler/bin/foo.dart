//import 'dart:math' as math;

import 'package:mdl/mdl.dart';

Future<void> main() async {
  const int track = 0;
  const int channel = 0; // ?!
  const double start = 0; // in beats
  const int volume = 127; // 0-127
  const int bpm = 60;
  const int startingNote = 50;

  //final math.Random rand = math.Random();

  final List<MidiMessage> stream = <MidiMessage>[
    const Tempo(track: 0, tempo: bpm),
    const KeySignature(
      track: track,
      time: start,
    ),
  ];

  Iterable<Note> notes() sync* {
    int lastTone = 0;
    for (int i = 0; i < 30; i += 1) {
      for (final Tone tone in Scale.diatonic.triad(lastTone).tones) {
        yield Note(
          track: track,
          channel: channel,
          pitch: Pitch(tone + startingNote),
          time: i / 1.0,
          duration: 1,
          volume: volume,
        );
      }
      lastTone += 1;
    }
  }

  notes().forEach(stream.add);

  foo(messages: stream);
}

class Scale {
  const Scale({
    required this.tones,
  });

  static const Scale diatonic = Scale(tones: <Tone>[
    Tone.zero,
    Tone.two,
    Tone.four,
    Tone.five,
    Tone.seven,
    Tone.nine,
    Tone.eleven,
  ]);

  final List<Tone> tones;

  Chord triad(int root) {
    return Chord(<Tone>[
      tones[root % tones.length],
      tones[(root + 2) % tones.length],
      tones[(root + 4) % tones.length],
    ]);
  }
}

class Chord {
  const Chord(this.tones);

  final List<Tone> tones;
}
