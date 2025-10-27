import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/playlist_manager.dart';
import 'music_player_page.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistManager = Provider.of<PlaylistManager>(context);
    final playlist = playlistManager.playlist;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Playlists",
          style: TextStyle(color: theme.colorScheme.onBackground),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
      ),
      body: playlist.isEmpty
          ? Center(
        child: Text(
          "Belum ada lagu di playlist",
          style: TextStyle(
            color: theme.colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
      )
          : ListView.builder(
        itemCount: playlist.length,
        itemBuilder: (context, index) {
          final song = playlist[index];
          return ListTile(
            leading: Image.network(
              song.artworkUrl100.replaceAll('100x100bb', '200x200bb'),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(
              song.trackName,
              style: TextStyle(color: theme.colorScheme.onBackground),
            ),
            subtitle: Text(
              song.artistName,
              style: TextStyle(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: theme.iconTheme.color?.withOpacity(0.7),
              ),
              onPressed: () => playlistManager.removeSong(song),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MusicPlayerPage(song: song),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
