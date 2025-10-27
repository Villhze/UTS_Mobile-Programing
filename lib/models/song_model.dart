class Song {
  final String trackName;
  final String artistName;
  final String artworkUrl100;
  final String previewUrl;
  final String collectionName;

  Song({
    required this.trackName,
    required this.artistName,
    required this.artworkUrl100,
    required this.previewUrl,
    required this.collectionName,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      trackName: json['trackName'] ?? 'Unknown Title',
      artistName: json['artistName'] ?? 'Unknown Artist',
      artworkUrl100: json['artworkUrl100'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
      collectionName: json['collectionName']??'unknown collection',
    );
  }

  Map<String, dynamic> toJson() => {
    'trackName': trackName,
    'artistName': artistName,
    'artworkUrl100': artworkUrl100,
    'previewUrl': previewUrl,
    'collectionName': collectionName,
  };
}
