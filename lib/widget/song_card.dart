import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../pages/music_player_page.dart';

class SongCard extends StatelessWidget {
  final Song song;

  const SongCard({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MusicPlayerPage(song: song),
          ),
        );
      },
      child: Card(
        color: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              song.artworkUrl100.replaceAll('100x100bb', '200x200bb'),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            song.trackName,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            song.artistName,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
