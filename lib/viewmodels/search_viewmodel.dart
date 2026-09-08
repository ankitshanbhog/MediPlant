import 'package:flutter/foundation.dart';
import '../data/models/disease_model.dart';
import '../data/models/plant_model.dart';
import '../data/repositories/disease_repository.dart';
import '../data/repositories/plant_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final DiseaseRepository _diseaseRepository;
  final PlantRepository _plantRepository;

  SearchViewModel({
    required DiseaseRepository diseaseRepository,
    required PlantRepository plantRepository,
  })  : _diseaseRepository = diseaseRepository,
        _plantRepository = plantRepository {
    init();
  }

  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<Disease> _allDiseases = [];
  List<Disease> _filteredDiseases = [];
  List<Plant> _matchingPlants = [];
  List<String> _categories = ['All'];
  bool _isLoading = false;

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  List<Disease> get filteredDiseases => _filteredDiseases;
  List<Plant> get matchingPlants => _matchingPlants;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get hasNoResults =>
      !_isLoading &&
      _searchQuery.trim().isNotEmpty &&
      _filteredDiseases.isEmpty &&
      _matchingPlants.isEmpty;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _allDiseases = await _diseaseRepository.getAllDiseases();
    _filteredDiseases = _allDiseases;
    final catList = await _diseaseRepository.getCategories();
    _categories = ['All', ...catList];
    await _updateMatchingPlants();

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void clearSearch() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _applyFilters();
  }

  Future<void> _applyFilters() async {
    _isLoading = true;
    notifyListeners();

    final q = _searchQuery.trim().toLowerCase();

    _filteredDiseases = _allDiseases.where((d) {
      final matchesCategory = _selectedCategory == 'All' ||
          d.category.toLowerCase() == _selectedCategory.toLowerCase();

      if (q.isEmpty) return matchesCategory;

      final matchesName = d.name.toLowerCase().contains(q);
      final matchesSymptoms = d.symptoms.any((s) => s.toLowerCase().contains(q));
      final matchesDesc = d.description.toLowerCase().contains(q);

      return matchesCategory && (matchesName || matchesSymptoms || matchesDesc);
    }).toList();

    await _updateMatchingPlants();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _updateMatchingPlants() async {
    if (_searchQuery.trim().isEmpty && _selectedCategory == 'All') {
      _matchingPlants = await _plantRepository.getFeaturedPlants();
      return;
    }

    final query = _searchQuery.trim();
    if (query.isNotEmpty) {
      _matchingPlants = await _plantRepository.searchPlants(query);
      if (_matchingPlants.isEmpty && _filteredDiseases.isNotEmpty) {
        // Collect plants linked to matched diseases
        final plantIds = _filteredDiseases.expand((d) => d.relatedPlantIds).toSet();
        final List<Plant> linked = [];
        for (final id in plantIds) {
          final p = await _plantRepository.getPlantById(id);
          if (p != null) linked.add(p);
        }
        _matchingPlants = linked;
      }
    } else {
      // Filtered by category
      final plantIds = _filteredDiseases.expand((d) => d.relatedPlantIds).toSet();
      final List<Plant> linked = [];
      for (final id in plantIds) {
        final p = await _plantRepository.getPlantById(id);
        if (p != null) linked.add(p);
      }
      _matchingPlants = linked;
    }
  }
}
