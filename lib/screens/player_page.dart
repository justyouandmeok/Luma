import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' hide PlayerState;

import '../services/player_state.dart';
import '../theme.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late YoutubePlayerController _yt;

  @override
  void initState() {
    super.initState();
    final id = context.read<PlayerState>().current?.id ?? 'kJQP7kiw5Fk';
    _yt = YoutubePlayerController.fromVideoId(
      videoId: id,
      autoPlay: true,
      params: const YoutubePlayerParams(
        mute: false,
        showFullscreenButton: true,
        playsInline: true,
        strictRelatedVideos: true,
        origin: 'https://www.youtube-nocookie.com',
      ),
    );
  }

  @override
  void dispose() {
    _yt.close();
    super.dispose();
  }

  Future<void> _openYt(String id) async {
    final app = Uri.parse('vnd.youtube:$id');
    final web = Uri.parse('https://www.youtube.com/watch?v=$id');
    if (await canLaunchUrl(app)) {
      await launchUrl(app, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(web, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ps = context.watch<PlayerState>();
    final track = ps.current;
    if (track == null) {
      return const Scaffold(body: Center(child: Text('Nada en reproducción')));
    }
    return YoutubePlayerScaffold(
      controller: _yt,
      aspectRatio: 16 / 9,
      builder: (context, player) {
        return Scaffold(
          backgroundColor: OndaColors.bg,
          appBar: AppBar(
            title: const Text('Reproduciendo'),
            actions: [
              IconButton(
                icon: Icon(ps.isFav(track) ? Icons.favorite : Icons.favorite_border, color: OndaColors.accent),
                onPressed: () => ps.toggleFav(track),
              ),
            ],
          ),
          body: ListView(
            children: [
              player,
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(track.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(track.channel, style: const TextStyle(color: OndaColors.muted, fontSize: 15)),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _yt.playVideo(),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Reproducir acá'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => _openYt(track.id),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Abrir app de YouTube'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(iconSize: 36, onPressed: ps.playPrev, icon: const Icon(Icons.skip_previous)),
                        IconButton(iconSize: 56, onPressed: () => _yt.playVideo(), icon: const Icon(Icons.play_circle)),
                        IconButton(iconSize: 36, onPressed: ps.playNext, icon: const Icon(Icons.skip_next)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
