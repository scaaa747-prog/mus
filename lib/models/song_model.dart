class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String coverUrl;
  final String audioUrl;
  final Duration duration;
  final String genre;
  bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.coverUrl,
    required this.audioUrl,
    required this.duration,
    required this.genre,
    this.isFavorite = false,
  });

  static List<Song> get mockSongs => [
    Song(
      id: '1',
      title: 'Starboy',
      artist: 'The Weeknd ft. Daft Punk',
      album: 'Starboy',
      coverUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&auto=format&fit=crop&q=80',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      duration: const Duration(minutes: 3, seconds: 50),
      genre: 'Pop',
      isFavorite: true,
    ),
    Song(
      id: '2',
      title: 'Midnight City',
      artist: 'M83',
      album: 'Hurry Up, We\'re Dreaming',
      coverUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800&auto=format&fit=crop&q=80',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      duration: const Duration(minutes: 4, seconds: 4),
      genre: 'Electronic',
      isFavorite: false,
    ),
    Song(
      id: '3',
      title: 'Levitating',
      artist: 'Dua Lipa',
      album: 'Future Nostalgia',
      coverUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800&auto=format&fit=crop&q=80',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      duration: const Duration(minutes: 3, seconds: 23),
      genre: 'Pop',
      isFavorite: true,
    ),
    Song(
      id: '4',
      title: 'After Hours',
      artist: 'The Weeknd',
      album: 'After Hours',
      coverUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&auto=format&fit=crop&q=80',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      duration: const Duration(minutes: 6, seconds: 1),
      genre: 'R&B',
      isFavorite: false,
    ),
    Song(
      id: '5',
      title: 'Save Your Tears',
      artist: 'The Weeknd',
      album: 'After Hours',
      coverUrl: 'https://images.unsplash.com/photo-1487180144351-b8472da7d491?w=800&auto=format&fit=crop&q=80',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      duration: const Duration(minutes: 3, seconds: 35),
      genre: 'Synthwave',
      isFavorite: true,
    ),
    Song(
      id: '6',
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      album: 'After Hours',
      coverUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=800&auto=format&fit=crop&q=80',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      duration: const Duration(minutes: 3, seconds: 20),
      genre: 'Pop',
      isFavorite: false,
    ),
  ];
}

class Playlist {
  final String id;
  final String title;
  final String description;
  final String coverUrl;
  final List<Song> songs;

  Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.songs,
  });

  static List<Playlist> get mockPlaylists => [
    Playlist(
      id: 'p1',
      title: 'Today\'s Top Hits',
      description: 'Dua Lipa is on top of the Hottest 50!',
      coverUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800&auto=format&fit=crop&q=80',
      songs: Song.mockSongs,
    ),
    Playlist(
      id: 'p2',
      title: 'Chill Vibes & Lo-Fi',
      description: 'Kick back with the best soothing beats.',
      coverUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800&auto=format&fit=crop&q=80',
      songs: Song.mockSongs.reversed.toList(),
    ),
    Playlist(
      id: 'p3',
      title: 'Synthwave & Retro',
      description: 'Neon lights and 80s synth nostalgia.',
      coverUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=800&auto=format&fit=crop&q=80',
      songs: Song.mockSongs,
    ),
  ];
}
