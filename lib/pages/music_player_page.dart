import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../models/like_manager.dart';
import '../models/playlist_manager.dart';
import '../services/audio_service.dart';

class MusicPlayerPage extends StatefulWidget {
  final Song song;
  final List<Song>? playlist;
  final int? index;

  const MusicPlayerPage({
    super.key,
    required this.song,
    this.playlist,
    this.index,
  });

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  bool isPlaying = false;
  late int currentIndex;
  late Song currentSong;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index ?? 0;
    currentSong = widget.song;
    _playCurrentSong();
  }

  Future<void> _playCurrentSong() async {
    await AudioService.instance.stop();
    await AudioService.instance.play(currentSong.previewUrl);
    setState(() => isPlaying = true);
  }

  void _togglePlay() async {
    if (isPlaying) {
      await AudioService.instance.pause();
    } else {
      await AudioService.instance.play(currentSong.previewUrl);
    }
    setState(() => isPlaying = !isPlaying);
  }

  void _playNext() {
    if (widget.playlist != null && currentIndex < widget.playlist!.length - 1) {
      setState(() {
        currentIndex++;
        currentSong = widget.playlist![currentIndex];
      });
      _playCurrentSong();
    }
  }

  void _playPrevious() {
    if (widget.playlist != null && currentIndex > 0) {
      setState(() {
        currentIndex--;
        currentSong = widget.playlist![currentIndex];
      });
      _playCurrentSong();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final likeManager = Provider.of<LikeManager>(context);
    final playlistManager = Provider.of<PlaylistManager>(context);
    final isLiked = likeManager.isLiked(currentSong);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          currentSong.trackName,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              currentSong.artworkUrl100.replaceAll('100x100bb', '600x600bb'),
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  color: Colors.black.withOpacity(0.5),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentSong.trackName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          currentSong.artistName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? Colors.redAccent : Colors.white,
                                size: 30,
                              ),
                              onPressed: () => likeManager.toggleLike(currentSong),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.skip_previous, color: Colors.white, size: 35),
                              onPressed: _playPrevious,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  color: Colors.black,
                                  size: 40,
                                ),
                                onPressed: _togglePlay,
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.skip_next, color: Colors.white, size: 35),
                              onPressed: _playNext,
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.playlist_add, color: Colors.white, size: 30),
                              onPressed: () {
                                playlistManager.addSong(currentSong);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${currentSong.trackName} ditambahkan ke playlist!')),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
