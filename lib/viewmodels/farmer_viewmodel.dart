import 'package:flutter/foundation.dart';
import '../services/farmer_service.dart';

class FarmerViewModel extends ChangeNotifier {
  final FarmerService _farmerService;

  int _selectedTabIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? _overview;
  Map<String, dynamic>? _profile;
  List<Map<String, dynamic>> _crops = [];
  List<Map<String, dynamic>> _stockBatches = [];
  List<Map<String, dynamic>> _inquiries = [];
  List<Map<String, dynamic>> _cultivationGuides = [];
  Map<String, dynamic>? _marketInfo;
  List<Map<String, dynamic>> _agriculturalResources = [];

  FarmerViewModel({required FarmerService farmerService}) : _farmerService = farmerService;

  int get selectedTabIndex => _selectedTabIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? get overview => _overview;
  Map<String, dynamic>? get profile => _profile;
  List<Map<String, dynamic>> get crops => _crops;
  List<Map<String, dynamic>> get stockBatches => _stockBatches;
  List<Map<String, dynamic>> get inquiries => _inquiries;
  List<Map<String, dynamic>> get cultivationGuides => _cultivationGuides;
  Map<String, dynamic>? get marketInfo => _marketInfo;
  List<Map<String, dynamic>> get agriculturalResources => _agriculturalResources;

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  /// Initial Load of all Farmer modules
  Future<void> loadFarmerData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _farmerService.getOverview().catchError((e) => <String, dynamic>{}),
        _farmerService.getProfile().catchError((e) => <String, dynamic>{}),
        _farmerService.getCrops().catchError((e) => <Map<String, dynamic>>[]),
        _farmerService.getStockBatches().catchError((e) => <Map<String, dynamic>>[]),
        _farmerService.getInquiries().catchError((e) => <Map<String, dynamic>>[]),
        _farmerService.getCultivationGuides().catchError((e) => <Map<String, dynamic>>[]),
        _farmerService.getMarketInfo().catchError((e) => <String, dynamic>{}),
        _farmerService.getAgriculturalResources().catchError((e) => <Map<String, dynamic>>[]),
      ]);

      _overview = results[0] as Map<String, dynamic>;
      _profile = results[1] as Map<String, dynamic>;
      _crops = results[2] as List<Map<String, dynamic>>;
      _stockBatches = results[3] as List<Map<String, dynamic>>;
      _inquiries = results[4] as List<Map<String, dynamic>>;
      _cultivationGuides = results[5] as List<Map<String, dynamic>>;
      _marketInfo = results[6] as Map<String, dynamic>;
      _agriculturalResources = results[7] as List<Map<String, dynamic>>;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Profile update
  Future<bool> updateProfile({
    required String farmName,
    required String region,
    required String farmingMethod,
    required int experienceYears,
    String? bio,
    String? contactPhone,
  }) async {
    try {
      await _farmerService.updateProfile(
        farmName: farmName,
        region: region,
        farmingMethod: farmingMethod,
        experienceYears: experienceYears,
        bio: bio,
        contactPhone: contactPhone,
      );
      await loadFarmerData();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Crops
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
      _crops = await _farmerService.getCrops();
      _overview = await _farmerService.getOverview();
      notifyListeners();
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
      _crops = await _farmerService.getCrops();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> deleteCrop(int cropId) async {
    try {
      await _farmerService.deleteCrop(cropId);
      _crops = await _farmerService.getCrops();
      _overview = await _farmerService.getOverview();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  /// Stock Batches
  Future<bool> addStockBatch({
    required String plantName,
    required String state,
    required double quantity,
    required String unit,
    String? qualityNotes,
    String? harvestDate,
    String status = 'In Stock',
    String? pricePerUnit,
  }) async {
    try {
      await _farmerService.addStockBatch(
        plantName: plantName,
        state: state,
        quantity: quantity,
        unit: unit,
        qualityNotes: qualityNotes,
        harvestDate: harvestDate,
        status: status,
        pricePerUnit: pricePerUnit,
      );
      _stockBatches = await _farmerService.getStockBatches();
      _overview = await _farmerService.getOverview();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> updateStockStatus(int batchId, String newStatus) async {
    try {
      await _farmerService.updateStockStatus(batchId, newStatus);
      _stockBatches = await _farmerService.getStockBatches();
      _overview = await _farmerService.getOverview();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> deleteStockBatch(int batchId) async {
    try {
      await _farmerService.deleteStockBatch(batchId);
      _stockBatches = await _farmerService.getStockBatches();
      _overview = await _farmerService.getOverview();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  /// Inquiries
  Future<void> respondToInquiry(int inquiryId, String newStatus) async {
    try {
      await _farmerService.respondToInquiry(inquiryId, newStatus);
      _inquiries = await _farmerService.getInquiries();
      _overview = await _farmerService.getOverview();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
