import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/player_state.dart';
import '../theme.dart';
import '../widgets/track_tile.dart';
import 'player_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ps = context.watch<PlayerState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Onda', style: TextStyle(fontWeight: FontWeight.w800))),
      body: RefreshIndicator(
        onRefresh: ps.loadTrending,
        child: ListView(
          children: [
            if (ps.apiKey.isEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: OndaColors.card, borderRadius: BorderRadius.circular(12)),
                child: const Text(
                  'Para buscar y ver tendencias, pegá tu YouTube Data API key en Ajustes. El video se reproduce con el reproductor oficial de YouTube.',
                ),
              ),
            if (ps.error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(ps.error!, style: const TextStyle(color: Colors.redAccent)),
              ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text('Tendencias musicales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            if (ps.loading) const LinearProgressIndicator(color: OndaColors.accent),
            ...ps.trending.map(
              (t) => TrackTile(
                track: t,
                onTap: () {
                  ps.play(t, from: ps.trending);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerPage()));
                },
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
