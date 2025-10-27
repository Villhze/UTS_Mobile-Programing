import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService instance = AudioService._internal();
  factory AudioService() => instance;
  AudioService._internal();

  final _player = AudioPlayer();

  Future<void> init() async {
    await _player.setLoopMode(LoopMode.off);
  }

  Future<void> play(String url) async {
    await _player.setUrl(url);
    _player.play();
  }

  Future<void> pause() async => _player.pause();
  Future<void> resume() async => _player.play();
  Future<void> stop() async => _player.stop();
  void dispose() => _player.dispose();
}
