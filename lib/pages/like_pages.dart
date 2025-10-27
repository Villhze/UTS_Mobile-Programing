import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/like_manager.dart';
import '../widget/song_card.dart';

class LikePage extends StatelessWidget {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    final likeManager = Provider.of<LikeManager>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Liked Songs",
          style: TextStyle(color: theme.colorScheme.onBackground),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
      ),
      body: likeManager.likedSongs.isEmpty
          ? Center(
        child: Text(
          "Tidak ada lagu yang disukai",
          style: TextStyle(
            color: theme.colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
      )
          : ListView.builder(
        itemCount: likeManager.likedSongs.length,
        itemBuilder: (context, index) {
          return SongCard(song: likeManager.likedSongs[index]);
        },
      ),
    );
  }
}
