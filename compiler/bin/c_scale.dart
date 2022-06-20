import 'package:mdl/mdl.dart';

Future<void> main() async {
  const List<int> notes = [60, 62, 64, 65, 67, 69, 71, 72];
  const int track = 0;
  const int channel = 0; // ?!
  const double start = 0; // in beats
  const double duration = 0.5; // in beats
  const int volume = 127; // 0-127

  final List<MidiMessage> stream = <MidiMessage>[
    const Tempo(track: 0),
    const KeySignature(
      track: track,
      time: start,
    ),
  ];
  for (int i = 0; i < notes.length; i += 1) {
    stream.add(
      Note(
        track: track,
        channel: channel,
        pitch: notes[i],
        time: i / 2,
        duration: duration,
        volume: volume,
      ),
    );
  }

  foo(messages: stream);
}
