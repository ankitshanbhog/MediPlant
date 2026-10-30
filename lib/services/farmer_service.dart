import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/database_helper.dart';
import 'backend_recognition_service.dart';

class FarmerService {
  static const String _tokenKey = 'mediplant_auth_token';
  String _baseUrl = BackendRecognitionService.defaultBaseUrl;

  FarmerService({String? customBaseUrl}) {
    if (customBaseUrl != null) {
      _baseUrl = customBaseUrl.endsWith('/') ? customBaseUrl.substring(0, customBaseUrl.length - 1) : customBaseUrl;
    }
  }

  Future<String?> _getToken() async {
    return await DatabaseHelper.instance.getSetting(_tokenKey);
  }

  Future<void> _checkBaseUrl() async {
    try {
      final savedUrl = await DatabaseHelper.instance.getSetting('custom_backend_url');
      if (savedUrl != null && savedUrl.trim().isNotEmpty) {
        _baseUrl = savedUrl.trim().endsWith('/') ? savedUrl.trim().substring(0, savedUrl.trim().length - 1) : savedUrl.trim();
      }
    } catch (_) {}
  }

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  /// 1. Overview & Stats
  Future<Map<String, dynamic>> getOverview() async {
    await _checkBaseUrl();
    final token = await _getToken();
    if (token == null) throw Exception('Farmer authentication required.');

    final res = await http.get(Uri.parse('$_baseUrl/farmer/overview'), headers: _headers(token)).timeout(const Duration(seconds: 8));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception(_parseError(res));
  }

  /// 2. Grower Profile
  Future<Map<String, dynamic>> getProfile() async {
    await _checkBaseUrl();
    final token = await _getToken();
    if (token == null) throw Exception('Farmer authentication required.');

    final res = await http.get(Uri.parse('$_baseUrl/farmer/profile'), headers: _headers(token)).timeout(const Duration(seconds: 8));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception(_parseError(res));
  }

  Future<void> updateProfile({
    required String farmName,
    required String region,
    required String farmingMethod,
    required int experienceYears,
    String? bio,
    String? contactPhone,
  }) async {
    await _checkBaseUrl();
    final token = await _getToken();
    if (token == null) throw Exception('Farmer authentication required.');

    final res = await http.put(
      Uri.parse('$_baseUrl/farmer/profile'),
      headers: _headers(token),
      body: jsonEncode({
        'farm_name': farmName.trim(),
        'region': region.trim(),
        'farming_method': farmingMethod.trim(),
        'experience_years': experienceYears,
        'bio': bio?.trim(),
        'contact_phone': contactPhone?.trim(),
      }),
    ).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) throw Exception(_parseError(res));
  }

  /// 3. Crops & Harvest Calendar
  Future<List<Map<String, dynamic>>> getCrops() async {
    await _checkBaseUrl();
    final token = await _getToken();
    if (token == null) throw Exception('Farmer authentication required.');

    final res = await http.get(Uri.parse('$_baseUrl/farmer/crops'), headers: _headers(token)).timeout(const Duration(seconds: 8));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['crops'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception(_parseError(res));
  }

  Future<void> addCrop({
    required String plantName,
    required String stage,
    String? sowingDate,
    String? expectedHarvest,
    String? quantity,
    String? notes,
  }) async {
    await _checkBaseUrl();
    final token = await _getToken();
    if (token == null) throw Exception('Farmer authentication required.');

    final res = await http.post(
      Uri.parse('$_baseUrl/farmer/crops'),
      headers: _headers(token),
      body: jsonEncode({
        'plant_name': plantName.trim(),
        'stage': stage.trim(),
        'sowing_date': sowingDate?.trim(),
        'expected_harvest': expectedHarvest?.trim(),
        'quantity': quantity?.trim(),
        'notes': notes?.trim(),
      }),
    ).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) throw Exception(_parseError(res));
  }

  Future<void> updateCropStage(int cropId, String newStage, {String? notes}) async {
    await _checkBaseUrl();
    final token = await _getToken();
    if (token == null) throw Exception('Farmer authentication required.');

    final res = await http.put(
      Uri.parse('$_baseUrl/farmer/crops/$cropId/stage'),
      headers: _headers(token),
      body: jsonEncode({'stage': newStage, 'notes': notes}),
    ).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) throw Exception(_parseError(res));
  }

  Future<void> deleteCrop(int cropId) async {
    await _checkBaseUrl();
    final token = await _getToken();
    if (token == null) throw Exception('Farmer authentication required.');

    final res = await http.delete(Uri.parse('$_baseUrl/farmer/crops/$cropId'), headers: _headers(token)).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) throw Exception(_parseError(res));
  }

  /// 4. Stock & Batch Management
  Future<List<Map<String, dynamic>>> getStockBatches() async {
    await _checkBaseUrl();
    final token = await _getToken();
    if (token == null) throw Exception('Farmer authentication required.');

    final res = await http.get(Uri.parse('$_baseUrl/farmer/stock'), headers: _headers(token)).timeout(const Duration(seconds: 8));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['batches'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception(_parseError(res));
  }

  Future<void> addStockBatch({
    required String plantName,
    required String state,
    required double quantity,
    required String unit,
    String? qualityNotes,
    String? harvestDate,
    String status = 'In Stock',
    String? pricePerUnit,
  }) async {
    await _checkBaseUrl();
    final token = await _getToken();
    if (token == null) throw Exception('Farmer authentication required.');

    final res = await http.post(
      Uri.parse('$_baseUrl/farmer/stock'),
      headers: _headers(token),
      body: jsonEncode({
        'plant_name': plantName.trim(),
        'state': state.trim(),
        'quantity': quantity,
        'unit': unit.trim(),
        'quality_notes': qualityNotes?.trim(),
        'harvest_date': harvestDate?.trim(),
        'status': status,
        'price_per_unit': pricePerUnit?.trim(),
      }),
    ).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) throw Exception(_parseError(res));
  }

  Future<void> updateStockStatus(int batchId, String newStatus) async {
    await _checkBaseUrl();
    final token = await _getToken();
    if (token == null) throw Exception('Farmer authentication required.');

    final res = await http.put(
      Uri.parse('$_baseUrl/farmer/stock/$batchId/status'),
      headers: _headers(token),
      body: jsonEncode({'status': newStatus}),
    ).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) throw Exception(_parseError(res));
  }

  Future<void> deleteStockBatch(int batchId) async {
    await _checkBaseUrl();
    final token = await _getToken();
    if (token == null) throw Exception('Farmer authentication required.');

    final res = await http.delete(Uri.parse('$_baseUrl/farmer/stock/$batchId'), headers: _headers(token)).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) throw Exception(_parseError(res));
  }

  /// 5. Buyer Inquiries
  Future<List<Map<String, dynamic>>> getInquiries() async {
    await _checkBaseUrl();
    final token = await _getToken();
    if (token == null) throw Exception('Farmer authentication required.');

    final res = await http.get(Uri.parse('$_baseUrl/farmer/inquiries'), headers: _headers(token)).timeout(const Duration(seconds: 8));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['inquiries'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception(_parseError(res));
  }

  Future<void> respondToInquiry(int inquiryId, String status) async {
    await _checkBaseUrl();
    final token = await _getToken();
    if (token == null) throw Exception('Farmer authentication required.');

    final res = await http.put(
      Uri.parse('$_baseUrl/farmer/inquiries/$inquiryId/status'),
      headers: _headers(token),
      body: jsonEncode({'status': status}),
    ).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) throw Exception(_parseError(res));
  }

  /// 6. Cultivation Guides (Public / Agronomy)
  Future<List<Map<String, dynamic>>> getCultivationGuides() async {
    await _checkBaseUrl();
    final res = await http.get(Uri.parse('$_baseUrl/farmer/cultivation-guides')).timeout(const Duration(seconds: 8));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['guides'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception(_parseError(res));
  }

  /// 7. Market Information
  Future<Map<String, dynamic>> getMarketInfo() async {
    await _checkBaseUrl();
    final res = await http.get(Uri.parse('$_baseUrl/farmer/market-info')).timeout(const Duration(seconds: 8));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception(_parseError(res));
  }

  /// 8. Agricultural Resources & Government Schemes
  Future<List<Map<String, dynamic>>> getAgriculturalResources() async {
    await _checkBaseUrl();
    final res = await http.get(Uri.parse('$_baseUrl/farmer/agricultural-resources')).timeout(const Duration(seconds: 8));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['resources'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception(_parseError(res));
  }

  String _parseError(http.Response res) {
    try {
      final body = jsonDecode(res.body);
      if (body is Map && body.containsKey('detail')) return body['detail'].toString();
    } catch (_) {}
    return 'Server request failed with code ${res.statusCode}';
  }
}
