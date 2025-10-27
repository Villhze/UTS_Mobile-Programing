import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../services/itunes_api.dart';
import '../models/like_manager.dart';
import 'music_player_page.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  List<Song> songs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    songs = await ItunesApi.fetchSongs("pop");
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final likeManager = Provider.of<LikeManager>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Music",
          style: TextStyle(color: theme.colorScheme.onBackground),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.secondary,
        ),
      )
          : ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          final isLiked = likeManager.isLiked(song);
          return ListTile(
            leading: Image.network(
              song.artworkUrl100,
              width: 60,
              height: 60,
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
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked
                    ? Colors.redAccent
                    : theme.iconTheme.color?.withOpacity(0.7),
              ),
              onPressed: () => likeManager.toggleLike(song),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MusicPlayerPage(
                    song: song,
                    playlist: songs,
                    index: index,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
