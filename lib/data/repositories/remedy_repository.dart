import '../database_helper.dart';
import '../mock/mock_remedies_data.dart';
import '../models/remedy_model.dart';

/// Repository interface and implementations for Home Remedies
abstract class RemedyRepository {
  Future<List<Remedy>> getAllRemedies();
  Future<Remedy?> getRemedyById(String id);
  Future<List<Remedy>> getRemediesByCategory(String category);
  Future<List<Remedy>> getRemediesByCondition(String condition);
  Future<List<Remedy>> getRemediesByPlantId(String plantId);
  Future<List<Remedy>> searchRemedies(String query);
  Future<List<String>> getCategories();
}

/// SQLite persistent Remedy Repository
class SqliteRemedyRepository implements RemedyRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  @override
  Future<List<Remedy>> getAllRemedies() => _db.getAllRemedies();

  @override
  Future<Remedy?> getRemedyById(String id) => _db.getRemedyById(id);

  @override
  Future<List<Remedy>> getRemediesByCategory(String category) {
    if (category.toLowerCase() == 'all') return _db.getAllRemedies();
    return _db.getRemediesForCondition(category);
  }

  @override
  Future<List<Remedy>> getRemediesByCondition(String condition) => _db.getRemediesForCondition(condition);

  @override
  Future<List<Remedy>> getRemediesByPlantId(String plantId) => _db.getRemediesForPlant(plantId);

  @override
  Future<List<Remedy>> searchRemedies(String query) => _db.searchRemedies(query);

  @override
  Future<List<String>> getCategories() async {
    final remedies = await _db.getAllRemedies();
    final categories = remedies.map((r) => r.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }
}

class MockRemedyRepository implements RemedyRepository {
  final List<Remedy> _remedies = List.unmodifiable(mockRemedies);

  @override
  Future<List<Remedy>> getAllRemedies() async {
    await Future.delayed(const Duration(milliseconds: 30));
    return _remedies;
  }

  @override
  Future<Remedy?> getRemedyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 20));
    try {
      return _remedies.firstWhere((r) => r.id.toLowerCase() == id.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Remedy>> getRemediesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 20));
    if (category.toLowerCase() == 'all') return _remedies;
    return _remedies.where((r) => r.category.toLowerCase() == category.toLowerCase()).toList();
  }

  @override
  Future<List<Remedy>> getRemediesByCondition(String condition) async {
    await Future.delayed(const Duration(milliseconds: 20));
    final c = condition.toLowerCase();
    return _remedies.where((r) => r.condition.toLowerCase().contains(c)).toList();
  }

  @override
  Future<List<Remedy>> getRemediesByPlantId(String plantId) async {
    await Future.delayed(const Duration(milliseconds: 20));
    return _remedies.where((r) => r.plantId == plantId).toList();
  }

  @override
  Future<List<Remedy>> searchRemedies(String query) async {
    await Future.delayed(const Duration(milliseconds: 30));
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _remedies;

    return _remedies.where((r) {
      final matchesTitle = r.title.toLowerCase().contains(q);
      final matchesCondition = r.condition.toLowerCase().contains(q);
      final matchesPlant = r.primaryPlantName.toLowerCase().contains(q);
      final matchesIngredients = r.ingredients.any((i) => i.toLowerCase().contains(q));
      final matchesCategory = r.category.toLowerCase().contains(q);
      return matchesTitle || matchesCondition || matchesPlant || matchesIngredients || matchesCategory;
    }).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 10));
    final categories = _remedies.map((r) => r.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }
}
