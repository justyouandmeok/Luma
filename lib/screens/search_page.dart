import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/player_state.dart';
import '../theme.dart';
import '../widgets/track_tile.dart';
import 'player_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final q = TextEditingController();

  @override
  void dispose() {
    q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ps = context.watch<PlayerState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: q,
              textInputAction: TextInputAction.search,
              onSubmitted: ps.search,
              decoration: InputDecoration(
                hintText: 'Canción, artista o video',
                filled: true,
                fillColor: OndaColors.card,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                suffixIcon: IconButton(icon: const Icon(Icons.arrow_forward), onPressed: () => ps.search(q.text)),
              ),
            ),
          ),
          if (ps.loading) const LinearProgressIndicator(color: OndaColors.accent),
          if (ps.error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(ps.error!, style: const TextStyle(color: Colors.redAccent)),
            ),
          Expanded(
            child: ListView(
              children: [
                ...ps.results.map(
                  (t) => TrackTile(
                    track: t,
                    onTap: () {
                      ps.play(t, from: ps.results);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerPage()));
                    },
                    trailing: IconButton(
                      icon: Icon(ps.isFav(t) ? Icons.favorite : Icons.favorite_border, color: OndaColors.accent),
                      onPressed: () => ps.toggleFav(t),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
