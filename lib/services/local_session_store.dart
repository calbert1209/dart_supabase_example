import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';

const String _sessionEntryKey = 'sessionEntry';

abstract class ISessionStore<T> {
  String? get serializedSession;
  Future<bool> save(T session);
  Future<bool> clear();
}

class LocalSessionStore implements ISessionStore<Session> {
  LocalSessionStore._(this._preferences);

  final SharedPreferences _preferences;

  static Future<LocalSessionStore> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    return LocalSessionStore._(preferences);
  }

  @override
  String? get serializedSession => _preferences.getString(_sessionEntryKey);

  @override
  Future<bool> save(Session session) => _preferences.setString(
        _sessionEntryKey,
        session.persistSessionString,
      );

  @override
  Future<bool> clear() => _preferences.remove(_sessionEntryKey);
}
