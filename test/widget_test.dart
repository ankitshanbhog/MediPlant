import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediplant/data/models/history_item_model.dart';
import 'package:mediplant/data/models/recognition_result_model.dart';
import 'package:mediplant/data/repositories/disease_repository.dart';
import 'package:mediplant/data/repositories/history_repository.dart';
import 'package:mediplant/data/repositories/plant_repository.dart';
import 'package:mediplant/data/repositories/remedy_repository.dart';
import 'package:mediplant/services/recognition_service.dart';
import 'package:mediplant/services/voice_service.dart';
import 'package:mediplant/ui/screens/about_screen.dart';
import 'package:mediplant/viewmodels/voice_viewmodel.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });

  group('MediPlant Data Repositories Tests', () {
    test('PlantRepository returns mock medicinal plants', () async {
      final repo = MockPlantRepository();
      final plants = await repo.getAllPlants();
      expect(plants.isNotEmpty, true);
      expect(plants.any((p) => p.id == 'tulsi_plant'), true);
      expect(plants.any((p) => p.id == 'aloe_vera_plant'), true);
    });

    test('DiseaseRepository searches conditions accurately', () async {
      final repo = MockDiseaseRepository();
      final results = await repo.searchDiseases('cough');
      expect(results.isNotEmpty, true);
      expect(results.first.id, 'cough');
    });

    test('RemedyRepository filters remedies by category', () async {
      final repo = MockRemedyRepository();
      final remedies = await repo.getRemediesByCategory('Cough');
      expect(remedies.isNotEmpty, true);
      expect(remedies.every((r) => r.category.toLowerCase().contains('cough')), true);
    });

    test('HistoryRepository manages scan history entries', () async {
      final repo = MockHistoryRepository();
      final initialHistory = await repo.getHistory();
      final initialCount = initialHistory.length;

      final newItem = HistoryItem(
        id: 'test_hist_item',
        timestamp: DateTime.now(),
        plantName: 'Test Herb',
        scientificName: 'Herba testus',
        confidence: 0.95,
        status: RecognitionStatus.ownModelSuccess,
        source: RecognitionSource.internalModel,
      );

      await repo.addHistoryItem(newItem);
      final updatedHistory = await repo.getHistory();
      expect(updatedHistory.length, initialCount + 1);

      await repo.deleteHistoryItem('test_hist_item');
      final afterDelete = await repo.getHistory();
      expect(afterDelete.length, initialCount);
    });
  });

  group('MediPlant Recognition Pipeline Simulation Tests', () {
    test('RecognitionService contract and configuration', () async {
      final service = BackendRecognitionService();
      expect(service.baseUrl.isNotEmpty, true);
    });

    test('VoiceViewModel handles speech controls', () async {
      final voiceService = MockVoiceTtsService();
      final voiceVM = VoiceViewModel(voiceService: voiceService);

      await voiceVM.readAloud(
        title: 'Tulsi',
        text: 'Tulsi is a sacred medicinal herb.',
      );

      expect(voiceVM.currentNarrationTitle, 'Tulsi');
      await voiceVM.stop();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(voiceVM.isStopped, true);
      voiceVM.dispose();
      voiceService.dispose();
    });
  });

  group('MediPlant UI Screen Tests', () {
    testWidgets('Renders AboutScreen with 3-Stage ML Architecture', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutScreen(),
        ),
      );

      expect(find.text('3-Stage ML Recognition Architecture'), findsOneWidget);
      expect(find.text('Model 1: Plant / Not-Plant Classifier'), findsOneWidget);
      expect(find.text('Model 2: Medicinal Species Model'), findsOneWidget);
      expect(find.text('External Verification / Backup API'), findsOneWidget);
      expect(find.text('Important Medical Disclaimer'), findsOneWidget);
    });
  });
}
