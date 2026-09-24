import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/player_state.dart';
import '../widgets/track_tile.dart';
import 'player_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ps = context.watch<PlayerState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Biblioteca')),
      body: ps.favorites.isEmpty
          ? const Center(child: Text('Tus favoritos aparecen acá'))
          : ListView(
              children: [
                ...ps.favorites.map(
                  (t) => TrackTile(
                    track: t,
                    onTap: () {
                      ps.play(t, from: ps.favorites);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerPage()));
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => ps.toggleFav(t),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
    );
  }
}
