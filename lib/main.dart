import 'package:path/path.dart' as path;
import 'package:bass/bass_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AppEntry());
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final bassPlayer = BassPlayer();
  double length = double.maxFinite;
  var filename = "None";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                bassPlayer.setSource(result.files.single.path!);
                length = bassPlayer.length;
                filename = path.basename(result.files.single.path!);
                setState(() {});
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("cancel")));
                }
              }
            },
            child: const Text("Select Audio"),
          ),
          const SizedBox(height: 16.0),
          Text(filename),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 4.0,
              top: 16.0,
            ),
            child: StreamBuilder(
              stream: bassPlayer.positionStream,
              builder: (context, snapshot) {
                var position = snapshot.data ?? 0.0;
                return LinearProgressIndicator(
                  value: position / length,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
              top: 4.0,
            ),
            child: StreamBuilder(
              stream: bassPlayer.positionStream,
              builder: (context, snapshot) {
                var position = snapshot.data ?? 0.0;
                var positionMinutes = position ~/ 60;
                var positionSeconds = position.truncate() % 60;

                var lengthMinutes = length ~/ 60;
                var lengthSeconds = length.truncate() % 60;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$positionMinutes:$positionSeconds"),
                    Text(length == double.maxFinite
                        ? "NULL"
                        : "$lengthMinutes:$lengthSeconds"),
                  ],
                );
              },
            ),
          ),
          StreamBuilder(
            stream: bassPlayer.playerStateStream,
            builder: (context, snapshot) {
              var playerState = snapshot.data ?? PlayerState.unknown;
              return IconButton.filled(
                onPressed: playerState == PlayerState.paused ||
                        playerState == PlayerState.stopped ||
                        playerState == PlayerState.completed
                    ? () {
                        bassPlayer.start();
                      }
                    : () {
                        bassPlayer.pause();
                      },
                icon: Icon(
                  playerState == PlayerState.paused ||
                          playerState == PlayerState.stopped ||
                          playerState == PlayerState.completed
                      ? Icons.play_arrow
                      : Icons.pause,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
