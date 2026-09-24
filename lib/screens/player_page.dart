import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../services/player_state.dart';
import '../theme.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  YoutubePlayerController? _yt;
  String? _boundId;

  void _bind(String id) {
    if (_boundId == id && _yt != null) return;
    _yt?.dispose();
    _yt = YoutubePlayerController(
      initialVideoId: id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        forceHD: false,
      ),
    );
    _boundId = id;
  }

  @override
  void dispose() {
    _yt?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ps = context.watch<PlayerState>();
    final track = ps.current;
    if (track == null) {
      return const Scaffold(body: Center(child: Text('Nada en reproducción')));
    }
    _bind(track.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reproduciendo'),
        actions: [
          IconButton(
            icon: Icon(ps.isFav(track) ? Icons.favorite : Icons.favorite_border, color: OndaColors.accent),
            onPressed: () => ps.toggleFav(track),
          ),
        ],
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _yt!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: OndaColors.accent,
            onEnded: (_) => context.read<PlayerState>().playNext(),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(track.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(track.channel, style: const TextStyle(color: OndaColors.muted, fontSize: 15)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(iconSize: 36, onPressed: ps.playPrev, icon: const Icon(Icons.skip_previous)),
                    IconButton(
                      iconSize: 56,
                      onPressed: () {
                        if (_yt == null) return;
                        if (_yt!.value.isPlaying) {
                          _yt!.pause();
                        } else {
                          _yt!.play();
                        }
                        setState(() {});
                      },
                      icon: Icon(_yt?.value.isPlaying == true ? Icons.pause_circle : Icons.play_circle),
                    ),
                    IconButton(iconSize: 36, onPressed: ps.playNext, icon: const Icon(Icons.skip_next)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
