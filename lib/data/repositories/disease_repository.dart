import '../database_helper.dart';
import '../mock/mock_diseases_data.dart';
import '../models/disease_model.dart';

/// Repository interface and implementations for Diseases and Health Conditions
abstract class DiseaseRepository {
  Future<List<Disease>> getAllDiseases();
  Future<Disease?> getDiseaseById(String id);
  Future<List<Disease>> searchDiseases(String query);
  Future<List<String>> getCategories();
  Future<List<Disease>> getDiseasesByCategory(String category);
}

/// SQLite persistent Disease Repository
class SqliteDiseaseRepository implements DiseaseRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  @override
  Future<List<Disease>> getAllDiseases() => _db.getAllDiseases();

  @override
  Future<Disease?> getDiseaseById(String id) => _db.getDiseaseById(id);

  @override
  Future<List<Disease>> searchDiseases(String query) => _db.searchDiseases(query);

  @override
  Future<List<String>> getCategories() async {
    final diseases = await _db.getAllDiseases();
    final categories = diseases.map((d) => d.category).toSet().toList();
    categories.sort();
    return categories;
  }

  @override
  Future<List<Disease>> getDiseasesByCategory(String category) {
    if (category.toLowerCase() == 'all') return _db.getAllDiseases();
    return _db.getDiseasesByCategory(category);
  }
}

class MockDiseaseRepository implements DiseaseRepository {
  final List<Disease> _diseases = List.unmodifiable(mockDiseases);

  @override
  Future<List<Disease>> getAllDiseases() async {
    await Future.delayed(const Duration(milliseconds: 30));
    return _diseases;
  }

  @override
  Future<Disease?> getDiseaseById(String id) async {
    await Future.delayed(const Duration(milliseconds: 20));
    try {
      return _diseases.firstWhere((d) => d.id.toLowerCase() == id.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Disease>> searchDiseases(String query) async {
    await Future.delayed(const Duration(milliseconds: 30));
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _diseases;

    return _diseases.where((d) {
      final matchesName = d.name.toLowerCase().contains(q);
      final matchesCategory = d.category.toLowerCase().contains(q);
      final matchesSymptoms = d.symptoms.any((s) => s.toLowerCase().contains(q));
      final matchesDesc = d.description.toLowerCase().contains(q);
      return matchesName || matchesCategory || matchesSymptoms || matchesDesc;
    }).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 10));
    final categories = _diseases.map((d) => d.category).toSet().toList();
    categories.sort();
    return categories;
  }

  @override
  Future<List<Disease>> getDiseasesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 20));
    if (category.toLowerCase() == 'all') return _diseases;
    return _diseases.where((d) => d.category.toLowerCase() == category.toLowerCase()).toList();
  }
}
