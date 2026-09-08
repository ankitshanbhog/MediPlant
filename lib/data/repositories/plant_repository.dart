import '../database_helper.dart';
import '../mock/mock_plants_data.dart';
import '../models/plant_model.dart';

/// Repository interface and implementations for Medicinal Plants data
abstract class PlantRepository {
  Future<List<Plant>> getAllPlants();
  Future<Plant?> getPlantById(String id);
  Future<List<Plant>> searchPlants(String query);
  Future<List<Plant>> getFeaturedPlants();
  Future<List<Plant>> getPlantsByDisease(String diseaseId);
}

/// SQLite persistent Plant Repository
class SqlitePlantRepository implements PlantRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  @override
  Future<List<Plant>> getAllPlants() => _db.getAllPlants();

  @override
  Future<Plant?> getPlantById(String id) => _db.getPlantById(id);

  @override
  Future<List<Plant>> searchPlants(String query) => _db.searchPlants(query);

  @override
  Future<List<Plant>> getFeaturedPlants() => _db.getFeaturedPlants();

  @override
  Future<List<Plant>> getPlantsByDisease(String diseaseId) => _db.getPlantsByDisease(diseaseId);
}

class MockPlantRepository implements PlantRepository {
  final List<Plant> _plants = List.unmodifiable(mockPlants);

  @override
  Future<List<Plant>> getAllPlants() async {
    // Simulate brief network/disk latency
    await Future.delayed(const Duration(milliseconds: 50));
    return _plants;
  }

  @override
  Future<Plant?> getPlantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 20));
    try {
      return _plants.firstWhere(
        (p) => p.id.toLowerCase() == id.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Plant>> searchPlants(String query) async {
    await Future.delayed(const Duration(milliseconds: 30));
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _plants;

    return _plants.where((p) {
      final matchesCommonName = p.commonName.toLowerCase().contains(q);
      final matchesScientificName = p.scientificName.toLowerCase().contains(q);
      final matchesFamily = p.family.toLowerCase().contains(q);
      final matchesUses = p.medicinalUses.any((u) => u.toLowerCase().contains(q));
      final matchesVernacular = p.vernacularNames.values.any((v) => v.toLowerCase().contains(q));
      return matchesCommonName || matchesScientificName || matchesFamily || matchesUses || matchesVernacular;
    }).toList();
  }

  @override
  Future<List<Plant>> getFeaturedPlants() async {
    await Future.delayed(const Duration(milliseconds: 20));
    // Return first 5 iconic plants
    return _plants.take(5).toList();
  }

  @override
  Future<List<Plant>> getPlantsByDisease(String diseaseId) async {
    await Future.delayed(const Duration(milliseconds: 30));
    return _plants.where((p) {
      final d = diseaseId.toLowerCase();
      return p.medicinalUses.any((u) => u.toLowerCase().contains(d)) ||
          p.traditionalUses.any((u) => u.toLowerCase().contains(d));
    }).toList();
  }
}
