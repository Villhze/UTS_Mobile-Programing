import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_pages.dart';
import 'pages/music_pages.dart';
import 'pages/like_pages.dart';
import 'pages/playlist_page.dart';
import 'models/like_manager.dart';
import 'models/playlist_manager.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AudioService.instance.init();
  runApp(const MyApp());
}

class ThemeManager extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeData get currentTheme =>
      _isDark ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LikeManager()),
        ChangeNotifierProvider(create: (_) => PlaylistManager()),
        ChangeNotifierProvider(create: (_) => ThemeManager()),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeManager.currentTheme.copyWith(
              scaffoldBackgroundColor:
              themeManager.isDark ? Colors.black : Colors.white,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor:
                themeManager.isDark ? Colors.black : Colors.white,
                selectedItemColor: Colors.teal,
                unselectedItemColor:
                themeManager.isDark ? Colors.white70 : Colors.black54,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor:
                themeManager.isDark ? Colors.black : Colors.white,
                iconTheme: IconThemeData(
                    color: themeManager.isDark ? Colors.white : Colors.black),
                titleTextStyle: TextStyle(
                    color: themeManager.isDark ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            home: const MainShell(),
          );
        },
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [
    HomePage(),
    MusicPage(),
    LikePage(),
    PlaylistPage(),
  ];

  @override
  void dispose() {
    AudioService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      body: Stack(
        children: [
          _pages[_index],
          if (_index == 0)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 12,
              child: IconButton(
                iconSize: 28,
                icon: Icon(
                  themeManager.isDark
                      ? Icons.nightlight_round
                      : Icons.wb_sunny_rounded,
                  color: themeManager.isDark ? Colors.white70 : Colors.amber,
                ),
                onPressed: () => themeManager.toggleTheme(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        backgroundColor: themeManager.isDark ? Colors.black : Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor:
        themeManager.isDark ? Colors.white70 : Colors.black54,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_music), label: 'Music'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Like'),
          BottomNavigationBarItem(
              icon: Icon(Icons.queue_music), label: 'Playlist'),
        ],
      ),
    );
  }
}
