import 'package:flutter/foundation.dart';
import '../data/database_helper.dart';
import '../data/mock/mock_farmer_data.dart';
import '../services/farmer_service.dart';

class FarmerViewModel extends ChangeNotifier {
  final FarmerService _farmerService;

  int _selectedTabIndex = 0;
  bool _isLoading = false;
  bool _isCloudConnected = false;
  String? _errorMessage;

  List<Map<String, dynamic>> _crops = [];
  final List<AgronomyDossier> _dossiers = mockAgronomyDossiers;
  final List<GovernmentScheme> _schemes = mockGovernmentSchemes;
  final List<MarketBenchmark> _benchmarks = mockMarketBenchmarks;

  FarmerViewModel({required FarmerService farmerService}) : _farmerService = farmerService;

  int get selectedTabIndex => _selectedTabIndex;
  bool get isLoading => _isLoading;
  bool get isCloudConnected => _isCloudConnected;
  String? get errorMessage => _errorMessage;

  List<Map<String, dynamic>> get crops => _crops;
  List<AgronomyDossier> get dossiers => _dossiers;
  List<GovernmentScheme> get schemes => _schemes;
  List<MarketBenchmark> get benchmarks => _benchmarks;

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  Future<void> loadFarmerData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Load instantly from Local SQLite
      final local = await DatabaseHelper.instance.getLocalFarmerCrops();
      _crops = List<Map<String, dynamic>>.from(local);
    } catch (_) {}

    // 2. Try syncing with Cloud API if available
    try {
      final cloudCrops = await _farmerService.getCrops().timeout(const Duration(seconds: 4));
      if (cloudCrops.isNotEmpty) {
        _crops = cloudCrops;
        for (final c in cloudCrops) {
          try {
            final id = c['id'] is int ? c['id'] as int : int.tryParse(c['id'].toString()) ?? 0;
            final plantName = c['plant_name'] ?? c['plantName'] ?? '';
            final stage = c['stage'] ?? '';
            final sowingDate = c['sowing_date'] ?? c['sowingDate'] ?? '';
            final expectedHarvest = c['expected_harvest'] ?? c['expectedHarvest'] ?? '';
            final qty = c['quantity'] ?? '';
            final notes = c['notes'] ?? '';

            await DatabaseHelper.instance.insertOrUpdateCloudCrop(
              id: id,
              plantName: plantName,
              stage: stage,
              sowingDate: sowingDate,
              expectedHarvest: expectedHarvest,
              quantity: qty,
              notes: notes,
            );
          } catch (_) {}
        }
      }
      _isCloudConnected = true;

      // 3. Also ping guides + market endpoints to confirm cloud reachability
      //    (data displayed stays from local ICAR/NMPB reference — just validates connection)
      _farmerService.getCultivationGuides().timeout(const Duration(seconds: 3)).ignore();
      _farmerService.getMarketInfo().timeout(const Duration(seconds: 3)).ignore();
    } catch (_) {
      // Offline mode: SQLite active, mock reference data still shown
      _isCloudConnected = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Calculates estimated harvest date based on botanical maturity days
  String calculateEstimatedHarvest(String plantName, DateTime sowingDate) {
    final cleanName = plantName.toLowerCase();
    AgronomyDossier? matched;
    for (final d in _dossiers) {
      if (cleanName.contains(d.speciesName.toLowerCase()) ||
          cleanName.contains(d.plantId.toLowerCase())) {
        matched = d;
        break;
      }
    }
    final days = matched?.daysToMaturity ?? 90;
    final harvestDate = sowingDate.add(Duration(days: days));
    return harvestDate.toString().substring(0, 10);
  }

  Future<bool> addCrop({
    required String plantName,
    required String stage,
    String? sowingDate,
    String? expectedHarvest,
    String? plotArea,
    String? quantity,
    String? notes,
  }) async {
    final sow = sowingDate ?? DateTime.now().toString().substring(0, 10);
    final harv = expectedHarvest ?? calculateEstimatedHarvest(plantName, DateTime.parse(sow));

    // Save to Local SQLite first (instant & reliable)
    int localId = 0;
    try {
      localId = await DatabaseHelper.instance.insertLocalFarmerCrop({
        'plantName': plantName.trim(),
        'stage': stage.trim(),
        'sowingDate': sow,
        'expectedHarvest': harv,
        'plotArea': plotArea?.trim() ?? '1 Acre',
        'quantity': quantity?.trim() ?? 'Unspecified',
        'notes': notes?.trim() ?? '',
        'isSynced': 0,
      });
    } catch (_) {}

    // Attempt cloud sync in background
    try {
      await _farmerService.addCrop(
        plantName: plantName,
        stage: stage,
        sowingDate: sow,
        expectedHarvest: harv,
        quantity: quantity,
        notes: notes,
      );
      _isCloudConnected = true;
      if (localId > 0) {
        // Mark as synced
        final db = await DatabaseHelper.instance.database;
        await db.update('farmer_crops', {'isSynced': 1}, where: 'id = ?', whereArgs: [localId]);
      }
    } catch (_) {
      _isCloudConnected = false;
    }

    await loadFarmerData();
    return true;
  }

  Future<void> updateCropStage(int cropId, String newStage, {String? notes}) async {
    // 1. Update in Local SQLite
    try {
      await DatabaseHelper.instance.updateLocalFarmerCropStage(cropId, newStage, notes: notes);
    } catch (_) {}

    // 2. Attempt cloud sync
    try {
      await _farmerService.updateCropStage(cropId, newStage, notes: notes);
      _isCloudConnected = true;
    } catch (_) {
      _isCloudConnected = false;
    }

    await loadFarmerData();
  }

  Future<void> deleteCrop(int cropId) async {
    // 1. Delete from Local SQLite
    try {
      await DatabaseHelper.instance.deleteLocalFarmerCrop(cropId);
    } catch (_) {}

    // 2. Attempt cloud sync
    try {
      await _farmerService.deleteCrop(cropId);
      _isCloudConnected = true;
    } catch (_) {
      _isCloudConnected = false;
    }

    await loadFarmerData();
  }
}
