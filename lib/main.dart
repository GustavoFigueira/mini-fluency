import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/core/services/audio_service.dart';
import 'package:mini_fluency/data/data.dart';
import 'package:mini_fluency/screens/screens.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiniFluencyApp());
}

class MiniFluencyApp extends StatelessWidget {
  const MiniFluencyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => PathProvider()),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            final colors = AppThemeColors(themeProvider.themeMode);
            _updateSystemUI(colors);

            return MaterialApp(
              title: 'Mini Fluency',
              debugShowCheckedModeBanner: false,
              theme: _buildLightTheme(colors),
              darkTheme: _buildDarkTheme(colors),
              themeMode:
                  themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: const PathScreenWithAudio(),
            );
          },
        ),
      );

  static void _updateSystemUI(AppThemeColors colors) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            colors.isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: colors.background,
        systemNavigationBarIconBrightness:
            colors.isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  ThemeData _buildLightTheme(AppThemeColors colors) => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: colors.background,
        colorScheme: ColorScheme.light(
          primary: colors.primary,
          secondary: colors.secondary,
          surface: colors.surface,
          error: colors.error,
          onSecondary: Colors.white,
          onSurface: colors.textPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          iconTheme: IconThemeData(color: colors.textPrimary),
          titleTextStyle: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: GoogleFonts.dmSansTextTheme(
          ThemeData.light().textTheme,
        ),
      );

  ThemeData _buildDarkTheme(AppThemeColors colors) => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: colors.background,
        colorScheme: ColorScheme.dark(
          primary: colors.primary,
          secondary: colors.secondary,
          surface: colors.surface,
          error: colors.error,
          onPrimary: colors.textPrimary,
          onSecondary: colors.textPrimary,
          onError: colors.textPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          iconTheme: IconThemeData(color: colors.textPrimary),
          titleTextStyle: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: GoogleFonts.dmSansTextTheme(
          ThemeData.dark().textTheme,
        ),
      );
}

class PathScreenWithAudio extends StatefulWidget {
  const PathScreenWithAudio({super.key});

  @override
  State<PathScreenWithAudio> createState() => _PathScreenWithAudioState();
}

class _PathScreenWithAudioState extends State<PathScreenWithAudio> {
  final _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _audioService.initialize();
  }

  @override
  void dispose() {
    _audioService.dispose().ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const PathScreen();
}
