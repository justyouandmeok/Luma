import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/track.dart';
import '../theme.dart';

class TrackTile extends StatelessWidget {
  const TrackTile({super.key, required this.track, required this.onTap, this.trailing});
  final Track track;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 64,
          height: 48,
          child: track.thumb.isEmpty
              ? Container(color: OndaColors.card, child: const Icon(Icons.music_note))
              : CachedNetworkImage(imageUrl: track.thumb, fit: BoxFit.cover),
        ),
      ),
      title: Text(track.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(track.channel, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: OndaColors.muted)),
      trailing: trailing,
    );
  }
}
