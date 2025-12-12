import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/song_model.dart';

class ItunesApi {
  static Future<List<Song>> fetchSongs(String term) async {
    final url = Uri.parse("https://itunes.apple.com/search?term=$term&entity=song");

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 7),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'];
        return results.map((e) => Song.fromJson(e)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }

    } on TimeoutException {
      throw Exception("Request timeout: koneksi lambat atau tidak stabil.");

    } on http.ClientException {
      throw Exception("Tidak ada koneksi internet.");

    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }
}
