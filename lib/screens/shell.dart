import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/player_state.dart';
import '../theme.dart';
import 'home_page.dart';
import 'library_page.dart';
import 'player_page.dart';
import 'search_page.dart';
import 'settings_page.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final current = context.watch<PlayerState>().current;
    final pages = const [HomePage(), SearchPage(), LibraryPage(), SettingsPage()];
    return Scaffold(
      body: IndexedStack(index: tab, children: pages),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (current != null)
            Material(
              color: OndaColors.card,
              child: ListTile(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerPage())),
                leading: const Icon(Icons.play_circle, color: OndaColors.accent),
                title: Text(current.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(current.channel, maxLines: 1),
                trailing: const Icon(Icons.keyboard_arrow_up),
              ),
            ),
          NavigationBar(
            selectedIndex: tab,
            onDestinationSelected: (i) => setState(() => tab = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
              NavigationDestination(icon: Icon(Icons.search), selectedIcon: Icon(Icons.search), label: 'Buscar'),
              NavigationDestination(icon: Icon(Icons.library_music_outlined), selectedIcon: Icon(Icons.library_music), label: 'Biblioteca'),
              NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Ajustes'),
            ],
          ),
        ],
      ),
    );
  }
}
