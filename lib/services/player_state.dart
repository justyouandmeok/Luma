import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/track.dart';
import 'settings_store.dart';
import 'youtube_api.dart';

class PlayerState extends ChangeNotifier {
  final SettingsStore store = SettingsStore();

  String apiKey = '';
  Track? current;
  List<Track> queue = [];
  List<Track> trending = [];
  List<Track> results = [];
  List<Track> favorites = [];
  bool loading = false;
  String? error;
  bool playing = true;

  YoutubeApi get api => YoutubeApi(apiKey);

  Future<void> load() async {
    apiKey = await store.apiKey();
    final raw = await store.favJson();
    favorites = raw.map((s) => Track.fromJson(jsonDecode(s) as Map<String, dynamic>)).toList();
    notifyListeners();
    if (apiKey.isNotEmpty) {
      await loadTrending();
    }
  }

  Future<void> saveKey(String key) async {
    apiKey = key.trim();
    await store.setApiKey(apiKey);
    notifyListeners();
    if (apiKey.isNotEmpty) await loadTrending();
  }

  Future<void> loadTrending() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      trending = await api.trendingMusic();
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> search(String q) async {
    if (q.trim().isEmpty) {
      results = [];
      notifyListeners();
      return;
    }
    loading = true;
    error = null;
    notifyListeners();
    try {
      results = await api.search(q.trim());
    } catch (e) {
      error = e.toString();
      results = [];
    }
    loading = false;
    notifyListeners();
  }

  void play(Track track, {List<Track>? from}) {
    current = track;
    if (from != null) queue = List.of(from);
    playing = true;
    notifyListeners();
  }

  void playNext() {
    if (current == null || queue.isEmpty) return;
    final i = queue.indexWhere((t) => t.id == current!.id);
    if (i >= 0 && i < queue.length - 1) {
      current = queue[i + 1];
      playing = true;
      notifyListeners();
    }
  }

  void playPrev() {
    if (current == null || queue.isEmpty) return;
    final i = queue.indexWhere((t) => t.id == current!.id);
    if (i > 0) {
      current = queue[i - 1];
      playing = true;
      notifyListeners();
    }
  }

  bool isFav(Track t) => favorites.any((f) => f.id == t.id);

  Future<void> toggleFav(Track t) async {
    if (isFav(t)) {
      favorites.removeWhere((f) => f.id == t.id);
    } else {
      favorites.insert(0, t);
    }
    await store.setFavJson(favorites.map((f) => jsonEncode(f.toJson())).toList());
    notifyListeners();
  }
}
