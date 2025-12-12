import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../services/itunes_api.dart';
import '../models/like_manager.dart';
import '../models/playlist_manager.dart';
import '../services/audio_service.dart';
import '../main.dart';
import 'music_player_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Song> madeForYou = [];
  List<Song> popularSingers = [];
  List<Song> taylorSwiftSongs = [];
  List<Song> trendingIndonesia = [];
  List<Song> nikiTopSong = [];
  bool isLoading = true;
  String greeting = "";

  @override
  void initState() {
    super.initState();
    loadSongs();
    setGreeting();
  }

  void setGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) {
      greeting = "Selamat pagi, Dimas!";
    } else if (hour >= 11 && hour < 15) {
      greeting = "Selamat siang, Dimas!";
    } else if (hour >= 15 && hour < 18) {
      greeting = "Selamat sore, Dimas!";
    } else {
      greeting = "Selamat malam, Dimas!";
    }
  }

  Future<void> loadSongs() async {
    setState(() {
      isLoading = true;
    });

    try {
      final popSongs = await ItunesApi.fetchSongs("indonesian pop");
      final hiphopSongs = await ItunesApi.fetchSongs("indonesian top");
      final swiftSongs = await ItunesApi.fetchSongs("Taylor Swift");
      final indoTrending = await ItunesApi.fetchSongs("Lyodra");
      final nikiSongs = await ItunesApi.fetchSongs("NIKI");

      setState(() {
        madeForYou = popSongs.take(10).toList();
        popularSingers = hiphopSongs.take(10).toList();
        taylorSwiftSongs = swiftSongs.take(10).toList();
        trendingIndonesia = indoTrending.take(10).toList();
        nikiTopSong = nikiSongs.take(10).toList();
        isLoading = false;
      });
    } on Exception {
      setState(() {
        isLoading = false;
        greeting = "Tidak ada koneksi internet 😢";
      });
    } catch (_) {
      setState(() {
        isLoading = false;
        greeting = "Error memuat data.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final likeManager = Provider.of<LikeManager>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Dimusic",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: isDark ? Colors.tealAccent : Colors.teal,
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              greeting,
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            buildSection(
              title: "Made for you",
              songs: madeForYou,
              likeManager: likeManager,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            const SizedBox(height: 20),
            buildSection(
              title: "Popular Indonesia singer",
              songs: popularSingers,
              likeManager: likeManager,
              isCircular: true,
              height: 150,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            const SizedBox(height: 20),
            buildSection(
              title: "Taylor Swift Collection",
              songs: taylorSwiftSongs,
              likeManager: likeManager,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            const SizedBox(height: 20),
            buildSection(
              title: "Top Lyodra Song",
              songs: trendingIndonesia,
              likeManager: likeManager,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            const SizedBox(height: 30),
            buildSection(
              title: "Top NIKI Song",
              songs: nikiTopSong,
              likeManager: likeManager,
              textColor: textColor,
              subTextColor: subTextColor,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required List<Song> songs,
    required LikeManager likeManager,
    required Color textColor,
    required Color subTextColor,
    bool isCircular = false,
    double height = 180,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "See all",
                style: TextStyle(color: Colors.teal.shade400),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              final isLiked = likeManager.isLiked(song);
              return GestureDetector(
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
                child: Container(
                  width: isCircular ? 100 : 140,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: isCircular
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(isCircular ? 50 : 12),
                        child: Image.network(
                          song.artworkUrl100,
                          width: isCircular ? 100 : 140,
                          height: isCircular ? 100 : 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (isCircular)
                        Text(
                          song.artistName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: subTextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (!isCircular)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.trackName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              song.artistName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: subTextColor),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
