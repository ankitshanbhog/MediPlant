import 'package:flutter/foundation.dart';
import '../services/farmer_service.dart';

class FarmerViewModel extends ChangeNotifier {
  final FarmerService _farmerService;

  int _selectedTabIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? _overview;
  List<Map<String, dynamic>> _crops = [];
  List<Map<String, dynamic>> _cultivationGuides = [];
  Map<String, dynamic>? _marketInfo;

  FarmerViewModel({required FarmerService farmerService}) : _farmerService = farmerService;

  int get selectedTabIndex => _selectedTabIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? get overview => _overview;
  List<Map<String, dynamic>> get crops => _crops;
  List<Map<String, dynamic>> get cultivationGuides => _cultivationGuides;
  Map<String, dynamic>? get marketInfo => _marketInfo;

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  Future<void> loadFarmerData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _farmerService.getOverview().catchError((e) => <String, dynamic>{}),
        _farmerService.getCrops().catchError((e) => <Map<String, dynamic>>[]),
        _farmerService.getCultivationGuides().catchError((e) => <Map<String, dynamic>>[]),
        _farmerService.getMarketInfo().catchError((e) => <String, dynamic>{}),
      ]);

      _overview = results[0] as Map<String, dynamic>;
      _crops = results[1] as List<Map<String, dynamic>>;
      _cultivationGuides = results[2] as List<Map<String, dynamic>>;
      _marketInfo = results[3] as Map<String, dynamic>;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCrop({
    required String plantName,
    required String stage,
    String? sowingDate,
    String? expectedHarvest,
    String? quantity,
    String? notes,
  }) async {
    try {
      await _farmerService.addCrop(
        plantName: plantName,
        stage: stage,
        sowingDate: sowingDate,
        expectedHarvest: expectedHarvest,
        quantity: quantity,
        notes: notes,
      );
      await loadFarmerData();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> updateCropStage(int cropId, String newStage, {String? notes}) async {
    try {
      await _farmerService.updateCropStage(cropId, newStage, notes: notes);
      await loadFarmerData();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> deleteCrop(int cropId) async {
    try {
      await _farmerService.deleteCrop(cropId);
      await loadFarmerData();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }
}
