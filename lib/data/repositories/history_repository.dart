import '../database_helper.dart';
import '../models/history_item_model.dart';

/// Repository interface and implementations for Scan History
abstract class HistoryRepository {
  Future<List<HistoryItem>> getHistory();
  Future<void> addHistoryItem(HistoryItem item);
  Future<void> deleteHistoryItem(String id);
  Future<void> clearHistory();
}

/// SQLite persistent History Repository
class SqliteHistoryRepository implements HistoryRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  @override
  Future<List<HistoryItem>> getHistory() => _db.getHistory();

  @override
  Future<void> addHistoryItem(HistoryItem item) => _db.addHistoryItem(item);

  @override
  Future<void> deleteHistoryItem(String id) => _db.deleteHistoryItem(id);

  @override
  Future<void> clearHistory() => _db.clearHistory();
}

class MockHistoryRepository implements HistoryRepository {
  final List<HistoryItem> _history = [];

  @override
  Future<List<HistoryItem>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 20));
    return List<HistoryItem>.from(_history);
  }

  @override
  Future<void> addHistoryItem(HistoryItem item) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _history.insert(0, item);
  }

  @override
  Future<void> deleteHistoryItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _history.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> clearHistory() async {
    await Future.delayed(const Duration(milliseconds: 10));
    _history.clear();
  }
}
