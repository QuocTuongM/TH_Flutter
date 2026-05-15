  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:permission_handler/permission_handler.dart';
  import '../providers/audio_provider.dart';
  import '../services/playlist_service.dart';
  import '../services/permission_service.dart';
  import '../models/song_model.dart';
  import '../utils/constants.dart';
  import '../widgets/song_tile.dart';
  import '../widgets/mini_player.dart';
  import 'playlist_screen.dart';
  import 'settings_screen.dart';

  class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
  }

  class _HomeScreenState extends State<HomeScreen> {
    final PlaylistService _playlistService = PlaylistService();
    final PermissionService _permissionService = PermissionService();
    final TextEditingController _searchController =
        TextEditingController();

    List<SongModel> _songs = [];
    List<SongModel> _filteredSongs = [];
    bool _isLoading = true;
    bool _hasPermission = false;
    bool _isSearching = false;
    int _currentTab = 0;

    @override
    void initState() {
      super.initState();
      _initializeApp();
    }

    @override
    void dispose() {
      _searchController.dispose();
      super.dispose();
    }

    Future<void> _initializeApp() async {
  try {
    await _permissionService.requestStoragePermission();
    await _permissionService.requestAudioPermission();
  } catch (_) {}

  _hasPermission = true;

  // Load cache trước nếu có
  final cached = _playlistService.getCachedSongs();
  if (cached.isNotEmpty) {
    setState(() {
      _songs = List<SongModel>.from(cached);
      _filteredSongs = List<SongModel>.from(cached);
      _isLoading = false;
    });
  } else {
    if (mounted) setState(() => _isLoading = false);
  }
}

    Future<void> _loadSongs() async {
  try {
    final songs = await _playlistService.getAllSongs();
    if (mounted) {
      setState(() {
        _songs = List<SongModel>.from(songs);
        _filteredSongs = List<SongModel>.from(songs);
      });
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'),
            backgroundColor: AppColors.surface),
      );
    }
  }
}

    void _onSearch(String query) {
      setState(() {
        if (query.isEmpty) {
          _filteredSongs = _songs;
          _isSearching = false;
        } else {
          _isSearching = true;
          _filteredSongs = _songs.where((song) {
            return song.title
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                song.artist
                    .toLowerCase()
                    .contains(query.toLowerCase());
          }).toList();
        }
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Tab bar
              _buildTabBar(),

              // Content
              Expanded(child: _buildContent()),

              // Mini player
              Consumer<AudioProvider>(
                builder: (_, provider, __) {
                  if (provider.currentSong == null) {
                    return const SizedBox.shrink();
                  }
                  return const MiniPlayer();
                },
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Row(
      children: [
        Expanded(
          child: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm bài hát...',
                    hintStyle: const TextStyle(color: AppColors.grey),
                    prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, color: AppColors.grey),
                      onPressed: () {
                        _searchController.clear();
                        _onSearch('');
                      },
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _onSearch,
                )
              : const Text(
                  'Music Player',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        if (!_isSearching) ...[
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.white),
            onPressed: () => setState(() => _isSearching = true),
          ),
          // Nút thêm nhạc
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.white),
            tooltip: 'Thêm nhạc',
            onPressed: _loadSongs,
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ],
    ),
  );
}

    Widget _buildTabBar() {
      final tabs = ['Tất cả', 'Playlist'];
      return Row(
        children: List.generate(tabs.length, (i) {
          final isActive = _currentTab == i;
          return GestureDetector(
            onTap: () => setState(() => _currentTab = i),
            child: Container(
              margin: const EdgeInsets.only(left: 16, bottom: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  color: isActive
                      ? AppColors.white
                      : AppColors.grey,
                  fontWeight: isActive
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      );
    }

    Widget _buildContent() {
      if (_isLoading) {
        return const Center(
          child: CircularProgressIndicator(
              color: AppColors.primary),
        );
      }

      if (!_hasPermission) {
        return _buildPermissionDenied();
      }

      if (_currentTab == 1) {
        return const PlaylistScreen();
      }

      if (_songs.isEmpty) {
        return _buildNoSongs();
      }

      if (_filteredSongs.isEmpty) {
        return const Center(
          child: Text('Không tìm thấy bài hát',
              style: TextStyle(color: AppColors.grey)),
        );
      }

      return Consumer<AudioProvider>(
        builder: (_, audioProvider, _x) {
          return RefreshIndicator(
            onRefresh: _loadSongs,
            color: AppColors.primary,
            child: ListView.builder(
              itemCount: _filteredSongs.length,
              itemBuilder: (_, i) {
                final song = _filteredSongs[i];
                final isPlaying =
                    audioProvider.currentSong?.id == song.id;
                return SongTile(
                  song: song,
                  isPlaying: isPlaying,
                  onTap: () => audioProvider.setPlaylist(
                      _filteredSongs, i),
                );
              },
            ),
          );
        },
      );
    }

    Widget _buildPermissionDenied() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_off,
                size: 80, color: AppColors.darkGrey),
            const SizedBox(height: 20),
            const Text(
              'Cần quyền truy cập Storage',
              style: TextStyle(
                  color: AppColors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vui lòng cấp quyền để truy cập nhạc',
              style: TextStyle(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await openAppSettings();
                await _initializeApp();
              },
              icon: const Icon(Icons.settings),
              label: const Text('Mở cài đặt'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildNoSongs() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note,
                size: 80, color: AppColors.darkGrey),
            const SizedBox(height: 20),
            const Text(
              'Không tìm thấy nhạc',
              style: TextStyle(
                  color: AppColors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Thêm file nhạc vào thiết bị của bạn',
              style: TextStyle(color: AppColors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadSongs,
              icon: const Icon(Icons.refresh),
              label: const Text('Tải lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      );
    }
  }