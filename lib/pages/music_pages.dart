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
  List<Song> filteredSongs = [];
  bool isLoading = true;
  bool isSearching = false;
  bool isError = false;
  String query = '';

  @override
  void initState() {
    super.initState();
    loadDefaultSongs();
  }

  Future<void> loadDefaultSongs() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      songs = await ItunesApi.fetchSongs("pop");
      filteredSongs = songs;
      setState(() => isLoading = false);
    } catch (e) {
      isError = true;
      isLoading = false;

      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Tidak ada koneksi internet"),
              duration: Duration(seconds: 3),
            ),
          );
        }
      });

      setState(() {});
    }
  }

  Future<void> searchMusic(String input) async {
    query = input;

    if (query.isEmpty) {
      filteredSongs = songs;
      setState(() {});
      return;
    }

    setState(() => isSearching = true);

    try {
      filteredSongs = await ItunesApi.fetchSongs(query);
    } catch (e) {
      filteredSongs = [];

      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Gagal memuat hasil pencarian"),
            ),
          );
        }
      });
    }

    setState(() => isSearching = false);
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: searchMusic,
              style: TextStyle(color: theme.colorScheme.onBackground),
              decoration: InputDecoration(
                hintText: "Search music...",
                hintStyle: TextStyle(
                    color: theme.colorScheme.onBackground.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search,
                    color: theme.colorScheme.onBackground.withOpacity(0.7)),
                filled: true,
                fillColor: theme.colorScheme.onBackground.withOpacity(0.05),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),

      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.secondary,
        ),
      )

          : isError
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off,
                size: 60,
                color: theme.colorScheme.onBackground
                    .withOpacity(0.6)),
            const SizedBox(height: 10),
            Text(
              "Tidak ada koneksi internet",
              style: TextStyle(
                  color: theme.colorScheme.onBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: loadDefaultSongs,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Coba lagi",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      )

          : isSearching
          ? Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.secondary,
        ),
      )

          : filteredSongs.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_off,
                size: 60,
                color: theme.colorScheme.onBackground
                    .withOpacity(0.6)),
            const SizedBox(height: 10),
            Text(
              "No results found",
              style: TextStyle(
                  color:
                  theme.colorScheme.onBackground
                      .withOpacity(0.7),
                  fontSize: 16),
            ),
          ],
        ),
      )

          : ListView.builder(
        itemCount: filteredSongs.length,
        itemBuilder: (context, index) {
          final song = filteredSongs[index];
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
              style: TextStyle(
                  color: theme.colorScheme.onBackground),
            ),
            subtitle: Text(
              song.artistName,
              style: TextStyle(
                color: theme.colorScheme.onBackground
                    .withOpacity(0.7),
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                isLiked
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: isLiked
                    ? Colors.redAccent
                    : theme.iconTheme.color
                    ?.withOpacity(0.7),
              ),
              onPressed: () =>
                  likeManager.toggleLike(song),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MusicPlayerPage(
                    song: song,
                    playlist: filteredSongs,
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
