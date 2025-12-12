import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';
import 'package:flutter/foundation.dart';

class AudioService extends ChangeNotifier {
  static final AudioService instance = AudioService._internal();
  factory AudioService() => instance;
  AudioService._internal();

  final _player = AudioPlayer();

  AudioPlayer get player => _player;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;

  Song? _currentSong;
  Song? get currentSong => _currentSong;

  bool get isPlaying => _player.playing;

  Future<void> init() async {
    await _player.setLoopMode(LoopMode.off);

    _player.playerStateStream.listen((state) {
      notifyListeners();
    });

    _player.positionStream.listen((_) {
      notifyListeners();
    });

    _player.durationStream.listen((_) {
      notifyListeners();
    });
  }

  Future<void> play(String url, {Song? song}) async {
    if (song != null) {
      _currentSong = song;
      notifyListeners();
    }

    await _player.setUrl(url);
    _player.play();
    notifyListeners();
  }

  Future<void> pause() async {
    await _player.pause();
    notifyListeners();
  }

  Future<void> resume() async {
    await _player.play();
    notifyListeners();
  }

  Future<void> stop() async {
    await _player.stop();
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
