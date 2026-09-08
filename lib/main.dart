import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/disease_repository.dart';
import 'data/repositories/history_repository.dart';
import 'data/repositories/plant_repository.dart';
import 'data/repositories/remedy_repository.dart';
import 'services/camera_service.dart';
import 'services/recognition_service.dart';
import 'services/flutter_tts_voice_service.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/theme/app_theme.dart';
import 'viewmodels/history_viewmodel.dart';
import 'viewmodels/recognition_viewmodel.dart';
import 'viewmodels/remedies_viewmodel.dart';
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/voice_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Instantiate SQLite persistent repositories
  final plantRepository = SqlitePlantRepository();
  final diseaseRepository = SqliteDiseaseRepository();
  final remedyRepository = SqliteRemedyRepository();
  final historyRepository = SqliteHistoryRepository();

  final recognitionService = BackendRecognitionService();
  final cameraService = MobileCameraGalleryService();
  final voiceService = FlutterTtsVoiceService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RecognitionViewModel(
            recognitionService: recognitionService,
            cameraService: cameraService,
            historyRepository: historyRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(
            diseaseRepository: diseaseRepository,
            plantRepository: plantRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RemediesViewModel(
            remedyRepository: remedyRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryViewModel(
            historyRepository: historyRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => VoiceViewModel(
            voiceService: voiceService,
          ),
        ),
      ],
      child: const MediPlantApp(),
    ),
  );
}

/// MediPlant Root Application
class MediPlantApp extends StatelessWidget {
  const MediPlantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediPlant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
