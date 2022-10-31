import 'package:shared_preferences/shared_preferences.dart';

class SearchHistory {
  static const _LIMIT = 20;
  static const SEARCH_HISTORY = "searchhistory";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //clear the search history
  Future<void> clearSearchHistory() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList(SEARCH_HISTORY, []);
  }

  // return the search history
  Future<List<String>> getSearchHistory() async {
    final SharedPreferences prefs = await _prefs;
    final searchHistory = prefs.getStringList(SEARCH_HISTORY);
    if (searchHistory == null) return [];
    return searchHistory;
  }

  // Add text or set text first if already exists in search
  Future<void> setSearchHistory(String text) async {
    final SharedPreferences prefs = await _prefs;
    List<String>? searchHistory = prefs.getStringList(SEARCH_HISTORY);
    if (searchHistory == null) {
      searchHistory = [];
      searchHistory.insert(0, text);
    } else {
      final pos = searchHistory.indexOf(text);
      if (pos != 0) {
        if (pos != -1) searchHistory.removeAt(pos);
        searchHistory.insert(0, text);
        if (_LIMIT != -1 && searchHistory.length > _LIMIT)
          searchHistory.removeLast();
      }
      prefs.setStringList(SEARCH_HISTORY, searchHistory);
    }
  }
}
