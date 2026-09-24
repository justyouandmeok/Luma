import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/track.dart';

class YoutubeApiException implements Exception {
  final String message;
  YoutubeApiException(this.message);
  @override
  String toString() => message;
}

class YoutubeApi {
  YoutubeApi(this.apiKey);
  final String apiKey;

  static const _base = 'https://www.googleapis.com/youtube/v3';

  Future<List<Track>> search(String query, {int max = 20}) async {
    if (apiKey.isEmpty) {
      throw YoutubeApiException('Falta la API key de YouTube Data API v3. Andá a Ajustes.');
    }
    final uri = Uri.parse('$_base/search').replace(queryParameters: {
      'part': 'snippet',
      'type': 'video',
      'videoCategoryId': '10',
      'maxResults': '$max',
      'q': query,
      'key': apiKey,
    });
    return _getList(uri);
  }

  Future<List<Track>> trendingMusic({String region = 'AR'}) async {
    if (apiKey.isEmpty) {
      throw YoutubeApiException('Falta la API key de YouTube Data API v3. Andá a Ajustes.');
    }
    final uri = Uri.parse('$_base/videos').replace(queryParameters: {
      'part': 'snippet',
      'chart': 'mostPopular',
      'videoCategoryId': '10',
      'regionCode': region,
      'maxResults': '20',
      'key': apiKey,
    });
    return _getList(uri, idFromItem: true);
  }

  Future<List<Track>> _getList(Uri uri, {bool idFromItem = false}) async {
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      String detail = res.body;
      try {
        final j = jsonDecode(res.body) as Map<String, dynamic>;
        detail = '${j['error']?['message'] ?? res.body}';
      } catch (_) {}
      throw YoutubeApiException('YouTube API (${res.statusCode}): $detail');
    }
    final j = jsonDecode(res.body) as Map<String, dynamic>;
    final items = (j['items'] as List?) ?? [];
    return items.map((raw) {
      final item = raw as Map<String, dynamic>;
      if (idFromItem) {
        final snippet = item['snippet'] as Map<String, dynamic>? ?? {};
        final thumbs = snippet['thumbnails'] as Map<String, dynamic>? ?? {};
        final high = (thumbs['high'] ?? thumbs['medium'] ?? thumbs['default']) as Map<String, dynamic>?;
        return Track(
          id: '${item['id']}',
          title: '${snippet['title'] ?? ''}',
          channel: '${snippet['channelTitle'] ?? ''}',
          thumb: '${high?['url'] ?? ''}',
          published: snippet['publishedAt'] as String?,
        );
      }
      return Track.fromSearchItem(item);
    }).where((t) => t.id.isNotEmpty).toList();
  }
}
