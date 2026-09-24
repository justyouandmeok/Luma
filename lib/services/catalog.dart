import '../models/track.dart';

/// Canciones de prueba (IDs públicos de YouTube) por si la API key está bloqueada.
const demoCatalog = <Track>[
  Track(id: 'kJQP7kiw5Fk', title: 'Luis Fonsi — Despacito', channel: 'LuisFonsiVEVO', thumb: 'https://i.ytimg.com/vi/kJQP7kiw5Fk/hqdefault.jpg'),
  Track(id: 'fJ9rUzIMcZQ', title: 'Queen — Bohemian Rhapsody', channel: 'Queen Official', thumb: 'https://i.ytimg.com/vi/fJ9rUzIMcZQ/hqdefault.jpg'),
  Track(id: 'YQHsXMglC9A', title: 'Adele — Hello', channel: 'AdeleVEVO', thumb: 'https://i.ytimg.com/vi/YQHsXMglC9A/hqdefault.jpg'),
  Track(id: '09R8_2nJtjg', title: 'Maroon 5 — Sugar', channel: 'Maroon5VEVO', thumb: 'https://i.ytimg.com/vi/09R8_2nJtjg/hqdefault.jpg'),
  Track(id: 'CevxZvSJLk8', title: 'Katy Perry — Roar', channel: 'KatyPerryVEVO', thumb: 'https://i.ytimg.com/vi/CevxZvSJLk8/hqdefault.jpg'),
  Track(id: 'OPf0YbXqDm0', title: 'Mark Ronson — Uptown Funk', channel: 'MarkRonsonVEVO', thumb: 'https://i.ytimg.com/vi/OPf0YbXqDm0/hqdefault.jpg'),
  Track(id: 'hT_nvWreIhg', title: 'OneRepublic — Counting Stars', channel: 'OneRepublicVEVO', thumb: 'https://i.ytimg.com/vi/hT_nvWreIhg/hqdefault.jpg'),
  Track(id: 'RgKAFK5djSk', title: 'Wiz Khalifa — See You Again', channel: 'Atlantic Records', thumb: 'https://i.ytimg.com/vi/RgKAFK5djSk/hqdefault.jpg'),
];

String? videoIdFromInput(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return null;
  final uri = Uri.tryParse(t);
  if (uri != null && uri.host.contains('youtu')) {
    if (uri.host.contains('youtu.be')) {
      final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
      return id.isEmpty ? null : id;
    }
    return uri.queryParameters['v'];
  }
  if (RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(t)) return t;
  return null;
}
