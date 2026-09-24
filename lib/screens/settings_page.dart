import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/player_state.dart';
import '../theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController keyCtrl;

  @override
  void initState() {
    super.initState();
    keyCtrl = TextEditingController(text: context.read<PlayerState>().apiKey);
  }

  @override
  void dispose() {
    keyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('YouTube Data API v3', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          const Text(
            '1. Entrá a Google Cloud Console.\n'
            '2. Creá un proyecto (o usá el de Firebase).\n'
            '3. Habilitá “YouTube Data API v3”.\n'
            '4. Credenciales → API key.\n'
            '5. Restringila a Android (paquete com.onda.music).\n'
            'Firebase Auth/Firestore es opcional: solo si más adelante querés cuentas y playlists en la nube.',
            style: TextStyle(color: OndaColors.muted, height: 1.4),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: keyCtrl,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'API key',
              filled: true,
              fillColor: OndaColors.card,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              await context.read<PlayerState>().saveKey(keyCtrl.text);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('API key guardada')));
              }
            },
            child: const Text('Guardar key'),
          ),
        ],
      ),
    );
  }
}
