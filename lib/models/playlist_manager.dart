import 'package:flutter/foundation.dart';
import 'song_model.dart';

class PlaylistManager extends ChangeNotifier {
  final List<Song> _playlist = [];

  List<Song> get playlist => List.unmodifiable(_playlist);

  void addSong(Song song) {
    final exists = _playlist.any((s) => s.trackName == song.trackName && s.artistName == song.artistName);
    if (!exists) {
      _playlist.add(song);
      notifyListeners();
    }
  }

  void removeSong(Song song) {
    _playlist.removeWhere((s) => s.trackName == song.trackName);
    notifyListeners();
  }
}
