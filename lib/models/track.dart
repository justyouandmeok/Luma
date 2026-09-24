class Track {
  final String id;
  final String title;
  final String channel;
  final String thumb;
  final String? published;

  const Track({
    required this.id,
    required this.title,
    required this.channel,
    required this.thumb,
    this.published,
  });

  String get url => 'https://www.youtube.com/watch?v=$id';

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'channel': channel,
        'thumb': thumb,
        'published': published,
      };

  factory Track.fromJson(Map<String, dynamic> j) => Track(
        id: j['id'] as String,
        title: j['title'] as String,
        channel: j['channel'] as String,
        thumb: j['thumb'] as String,
        published: j['published'] as String?,
      );

  factory Track.fromSearchItem(Map<String, dynamic> item) {
    final snippet = item['snippet'] as Map<String, dynamic>? ?? {};
    final thumbs = snippet['thumbnails'] as Map<String, dynamic>? ?? {};
    final high = (thumbs['high'] ?? thumbs['medium'] ?? thumbs['default']) as Map<String, dynamic>?;
    final idMap = item['id'];
    final vid = idMap is Map ? (idMap['videoId'] ?? '') : '$idMap';
    return Track(
      id: '$vid',
      title: '${snippet['title'] ?? ''}',
      channel: '${snippet['channelTitle'] ?? ''}',
      thumb: '${high?['url'] ?? ''}',
      published: snippet['publishedAt'] as String?,
    );
  }
}
