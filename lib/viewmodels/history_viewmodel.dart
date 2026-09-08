import 'package:flutter/foundation.dart';
import '../data/models/history_item_model.dart';
import '../data/repositories/history_repository.dart';

class HistoryViewModel extends ChangeNotifier {
  final HistoryRepository _historyRepository;

  HistoryViewModel({
    required HistoryRepository historyRepository,
  }) : _historyRepository = historyRepository {
    loadHistory();
  }

  List<HistoryItem> _items = [];
  bool _isLoading = false;
  String _filterQuery = '';

  List<HistoryItem> get items {
    if (_filterQuery.trim().isEmpty) return _items;
    final q = _filterQuery.toLowerCase();
    return _items.where((i) {
      return i.plantName.toLowerCase().contains(q) ||
          i.scientificName.toLowerCase().contains(q);
    }).toList();
  }

  bool get isLoading => _isLoading;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    _items = await _historyRepository.getHistory();

    _isLoading = false;
    notifyListeners();
  }

  void setFilterQuery(String query) {
    _filterQuery = query;
    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    await _historyRepository.deleteHistoryItem(id);
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _historyRepository.clearHistory();
    _items.clear();
    notifyListeners();
  }
}
