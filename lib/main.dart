import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/shell.dart';
import 'services/player_state.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OndaApp());
}

class OndaApp extends StatefulWidget {
  const OndaApp({super.key});
  @override
  State<OndaApp> createState() => _OndaAppState();
}

class _OndaAppState extends State<OndaApp> {
  final state = PlayerState();

  @override
  void initState() {
    super.initState();
    state.load();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Onda',
        theme: ondaTheme(),
        home: const Shell(),
      ),
    );
  }
}
