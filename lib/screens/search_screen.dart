import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../services/audio_player_service.dart';
import '../widgets/song_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  final List<Song> _allSongs = Song.mockSongs;

  List<Song> get _filteredSongs {
    if (_searchQuery.isEmpty) return _allSongs;
    return _allSongs.where((song) {
      return song.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          song.artist.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          song.genre.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioPlayerService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search songs, artists, genres...',
            hintStyle: const TextStyle(color: Colors.white38),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: Color(0xFF6C5CE7)),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white54),
                    onPressed: () => setState(() => _searchQuery = ''),
                  )
                : null,
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
      ),
      body: _filteredSongs.isEmpty
          ? const Center(
              child: Text(
                'No songs found.',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filteredSongs.length,
              itemBuilder: (context, index) {
                final song = _filteredSongs[index];
                final isCurrent = audioService.currentSong?.id == song.id;
                return SongTile(
                  song: song,
                  index: index,
                  isCurrent: isCurrent,
                  isPlaying: isCurrent && audioService.isPlaying,
                  onTap: () => audioService.playSong(song, queue: _filteredSongs),
                  onFavoriteTap: () => audioService.toggleFavorite(song),
                );
              },
            ),
    );
  }
}
