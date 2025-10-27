import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song_model.dart';

class ItunesApi {
  static Future<List<Song>> fetchSongs(String term) async {
    final url = Uri.parse("https://itunes.apple.com/search?term=$term&entity=song");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((e) => Song.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch songs');
    }
  }
}
