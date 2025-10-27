import 'package:flutter/foundation.dart';
import 'song_model.dart';

class LikeManager extends ChangeNotifier {
  final List<Song> _likedSongs = [];

  List<Song> get likedSongs => _likedSongs;

  bool isLiked(Song song) {
    return _likedSongs.any((s) => s.trackName == song.trackName);
  }

  void toggleLike(Song song) {
    if (isLiked(song)) {
      _likedSongs.removeWhere((s) => s.trackName == song.trackName);
    } else {
      _likedSongs.add(song);
    }
    notifyListeners();
  }
}
