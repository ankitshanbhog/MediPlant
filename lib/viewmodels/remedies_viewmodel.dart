import 'package:flutter/foundation.dart';
import '../data/models/remedy_model.dart';
import '../data/repositories/remedy_repository.dart';

class RemediesViewModel extends ChangeNotifier {
  final RemedyRepository _remedyRepository;

  RemediesViewModel({
    required RemedyRepository remedyRepository,
  }) : _remedyRepository = remedyRepository {
    init();
  }

  List<Remedy> _allRemedies = [];
  List<Remedy> _filteredRemedies = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final Set<String> _bookmarkedIds = {};
  bool _isLoading = false;

  List<Remedy> get remedies => _filteredRemedies;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  Set<String> get bookmarkedIds => _bookmarkedIds;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _allRemedies = await _remedyRepository.getAllRemedies();
    _filteredRemedies = _allRemedies;
    _categories = await _remedyRepository.getCategories();

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void toggleBookmark(String remedyId) {
    if (_bookmarkedIds.contains(remedyId)) {
      _bookmarkedIds.remove(remedyId);
    } else {
      _bookmarkedIds.add(remedyId);
    }
    notifyListeners();
  }

  bool isBookmarked(String remedyId) => _bookmarkedIds.contains(remedyId);

  void _applyFilters() {
    final q = _searchQuery.trim().toLowerCase();

    _filteredRemedies = _allRemedies.where((r) {
      final matchesCategory = _selectedCategory == 'All' ||
          r.category.toLowerCase() == _selectedCategory.toLowerCase() ||
          r.condition.toLowerCase().contains(_selectedCategory.toLowerCase());

      if (q.isEmpty) return matchesCategory;

      final matchesTitle = r.title.toLowerCase().contains(q);
      final matchesCondition = r.condition.toLowerCase().contains(q);
      final matchesPlant = r.primaryPlantName.toLowerCase().contains(q);
      final matchesIngredients = r.ingredients.any((i) => i.toLowerCase().contains(q));

      return matchesCategory &&
          (matchesTitle || matchesCondition || matchesPlant || matchesIngredients);
    }).toList();

    notifyListeners();
  }
}
