import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';

const String _sessionEntryKey = 'sessionEntry';

class LocalSessionStore {
  LocalSessionStore._(this._preferences);

  final SharedPreferences _preferences;

  static Future<LocalSessionStore> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    return LocalSessionStore._(preferences);
  }

  String? get serializedSession => _preferences.getString(_sessionEntryKey);

  Future<bool> save(Session session) => _preferences.setString(
        _sessionEntryKey,
        session.persistSessionString,
      );

  Future<bool> clear() => _preferences.remove(_sessionEntryKey);
}
