import 'dart:io' as io;
import 'dart:math' as math;

import 'package:midi_util/midi_util.dart';

Future<void> foo({
  required Iterable<MidiMessage> messages,
  int numTracks = 1,
}) async {
  final MIDIFile midi = MIDIFile(numTracks: numTracks);
  messages.forEach((MidiMessage message) => message.emit(midi));

  final io.Directory build = io.Directory('build');
  build.createSync(recursive: true);
  // TODO make windows compat
  final io.File outputFile = io.File('build/c_scale.midi');
  midi.writeFile(outputFile);
}

T sample<T>(Iterable<T> samples, math.Random rand) {
  final List<T> list = samples.toList();
  final int idx = rand.nextInt(list.length);
  return list[idx];
}

abstract class MidiMessage {
  const MidiMessage({
    required this.time,
    required this.track,
  });

  /// In beats (quarter notes).
  final double time;

  final int track;

  void emit(MIDIFile midi);
}

class Tempo extends MidiMessage {
  const Tempo({
    super.time = 0,
    required super.track,
    this.tempo = 120,
  });

  final int tempo;

  void emit(MIDIFile midi) => midi.addTempo(
        track: track,
        tempo: tempo,
        time: time,
      );
}

class KeySignature extends MidiMessage {
  const KeySignature({
    super.time = 0,
    required super.track,
    this.accidentalCount = 0,
  });

  final int accidentalCount;

  void emit(MIDIFile midi) => midi.addKeySignature(
        track: track,
        time: time,
        no_of_accidentals: accidentalCount,
        accidental_mode: AccidentalMode.MAJOR,
        accidental_type: AccidentalType.SHARPS,
      );
}

enum Tone {
  /// C.
  zero(0),

  /// C sharp, D flat.
  one(1),

  /// D.
  two(2),

  /// D sharp, E flat.
  three(3),

  /// E
  four(4),

  /// F
  five(5),

  /// F sharp, G flat.
  six(6),

  /// G.
  seven(7),

  /// G sharp, A flat.
  eight(8),

  /// A.
  nine(9),

  /// A sharp, B flat.
  ten(10),

  /// B.
  eleven(11);

  const Tone(this.value);

  factory Tone.from(int value) => _map[value]!;

  static const Map<int, Tone> _map = <int, Tone>{
    0: zero,
    1: one,
    2: two,
    3: three,
    4: four,
    5: five,
    6: six,
    7: seven,
    8: eight,
    9: nine,
    10: ten,
    11: eleven,
  };

  final int value; // between 0 and 11, inclusive

  Tone operator +(int offset) {
    final int index = (this.value + offset) % 12;
    return Tone.from(index);
  }
}

enum Octave {
  minusOne._(-1),
  zero._(0),
  one._(1),
  two._(2),
  three._(3),
  four._(4),
  five._(5),
  six._(6),
  seven._(7),
  eight._(8),
  nine._(9);

  const Octave._(this.value);

  factory Octave.from(int value) => _map[value]!;

  static const Map<int, Octave> _map = <int, Octave>{
    -1: minusOne,
    0: zero,
    1: one,
    2: two,
    3: three,
    4: four,
    5: five,
    6: six,
    7: seven,
    8: eight,
    9: nine,
  };
  final int value;

  Octave operator +(int offset) {
    final int nextValue = this.value + offset;
    if (nextValue > 9 || nextValue < -1) {
      throw StateError('Invalid inputs: $value + $offset = $nextValue');
    }
    return Octave.from(nextValue);
  }
}

class Pitch {
  factory Pitch(int value) {
    if (_map.containsKey(value)) {
      return _map[value]!;
    }
    final Pitch pitch = Pitch._(value);
    _map[value] = pitch;
    return pitch;
  }

  factory Pitch.fromTone({
    required Tone tone,
    required Octave octave,
  }) {
    final int value = (octave.value + 1) * 12 + tone.value;
    if (value < 0 || value > 127) {
      throw StateError('Invalid inputs: $tone + $octave = $value');
    }
    return Pitch(value);
  }

  const Pitch._(this.value);

  static final Map<int, Pitch> _map = <int, Pitch>{};

  final int value;
}

class Note extends MidiMessage {
  const Note({
    required super.time,
    required super.track,
    required this.pitch,
    required this.channel,
    required this.duration,
    this.volume = 127,
  }) : assert(volume >= 0 && volume <= 127);

  final int channel;
  final Pitch pitch;
  final int volume;
  final double duration;

  void emit(MIDIFile midi) => midi.addNote(
        time: time,
        track: track,
        channel: channel,
        pitch: pitch.value,
        duration: duration,
      );
}
