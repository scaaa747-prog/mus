import 'dart:async';
import 'package:flutter/material.dart';
import '../models/song_model.dart';

class AudioPlayerService extends ChangeNotifier {
  List<Song> _playlist = Song.mockSongs;
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = const Duration(minutes: 3, seconds: 30);
  bool _isShuffle = false;
  bool _isLoop = false;
  Timer? _playbackTimer;

  // Getters
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  Song? get currentSong => _playlist.isNotEmpty && _currentIndex < _playlist.length 
      ? _playlist[_currentIndex] 
      : null;
  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => currentSong?.duration ?? _totalDuration;
  bool get isShuffle => _isShuffle;
  bool get isLoop => _isLoop;

  AudioPlayerService() {
    if (_playlist.isNotEmpty) {
      _totalDuration = _playlist[0].duration;
    }
  }

  void playSong(Song song, {List<Song>? queue}) {
    if (queue != null) {
      _playlist = queue;
    }
    final index = _playlist.indexWhere((s) => s.id == song.id);
    if (index != -1) {
      _currentIndex = index;
    } else {
      _playlist.add(song);
      _currentIndex = _playlist.length - 1;
    }
    _currentPosition = Duration.zero;
    _totalDuration = song.duration;
    _isPlaying = true;
    _startTimer();
    notifyListeners();
  }

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      _startTimer();
    } else {
      _stopTimer();
    }
    notifyListeners();
  }

  void nextSong() {
    if (_playlist.isEmpty) return;
    if (_isShuffle) {
      _currentIndex = (_currentIndex + 1) % _playlist.length;
    } else {
      if (_currentIndex < _playlist.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0; // loop to start
      }
    }
    _currentPosition = Duration.zero;
    _totalDuration = currentSong?.duration ?? const Duration(minutes: 3);
    _isPlaying = true;
    _startTimer();
    notifyListeners();
  }

  void previousSong() {
    if (_playlist.isEmpty) return;
    if (_currentPosition.inSeconds > 3) {
      _currentPosition = Duration.zero;
    } else {
      if (_currentIndex > 0) {
        _currentIndex--;
      } else {
        _currentIndex = _playlist.length - 1;
      }
      _currentPosition = Duration.zero;
    }
    _totalDuration = currentSong?.duration ?? const Duration(minutes: 3);
    _isPlaying = true;
    _startTimer();
    notifyListeners();
  }

  void seek(Duration position) {
    _currentPosition = position;
    if (_currentPosition > totalDuration) {
      _currentPosition = totalDuration;
    }
    notifyListeners();
  }

  void toggleFavorite(Song song) {
    song.isFavorite = !song.isFavorite;
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleLoop() {
    _isLoop = !_isLoop;
    notifyListeners();
  }

  void _startTimer() {
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPlaying) {
        if (_currentPosition < totalDuration) {
          _currentPosition += const Duration(seconds: 1);
          notifyListeners();
        } else {
          if (_isLoop) {
            _currentPosition = Duration.zero;
            notifyListeners();
          } else {
            nextSong();
          }
        }
      }
    });
  }

  void _stopTimer() {
    _playbackTimer?.cancel();
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }
}
