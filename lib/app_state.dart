import 'package:dart_supabase_example/services/supabase_secrets_store.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as base_provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';

const String sessionEntryKey = 'sessionEntry';

class AppState with ChangeNotifier {
  AppState._({
    required SupabaseSecretsStore secretsStore,
    required SupabaseClient client,
    required SharedPreferences preferences,
    this.isSignedIn = false,
  })  : _secretStore = secretsStore,
        _client = client,
        _preferences = preferences;

  final SupabaseSecretsStore _secretStore;
  final SupabaseClient _client;
  final SharedPreferences _preferences;
  bool isSignedIn;
  GotrueError? error;

  static Future<AppState> initialize(
    SupabaseSecretsStore secretsStore,
    SupabaseClient client,
    SharedPreferences preferences,
  ) async {
    final session = await _tryToRecoverSession(preferences, client);
    return AppState._(
      secretsStore: secretsStore,
      client: client,
      preferences: preferences,
      isSignedIn: session != null,
    );
  }

  static Future<Session?> _tryToRecoverSession(preferences, client) async {
    final String? serializedSession = preferences.getString(sessionEntryKey);
    if (serializedSession == null) return Future.value(null);

    try {
      final response = await client.auth.recoverSession(serializedSession);
      return response.data;
    } catch (e) {
      print(e);
    }

    return Future.value(null);
  }

  Future<bool> _clearSession() => _preferences.remove(sessionEntryKey);

  Future<void> _signIn(String email, String password) async {
    final response = await _client.auth.signIn(
      email: email,
      password: password,
    );
    if (response.error != null) {
      error = response.error;
      print(error);
    } else {
      final serializedSession = response.data!.persistSessionString;
      await _preferences.setString(sessionEntryKey, serializedSession);
      isSignedIn = true;
      notifyListeners();
    }
  }

  Future<void> signIn() async {
    final session = await _tryToRecoverSession(_preferences, _client);
    if (session != null) {
      isSignedIn = true;
      notifyListeners();
      return;
    }

    return _signIn(_secretStore.userId, _secretStore.password);
  }

  Future<void> signOut() async {
    await _clearSession();
    final response = await _client.auth.signOut();

    if (response.error != null) {
      error = response.error;
      print(error);
    } else {
      isSignedIn = false;
    }
    notifyListeners();
  }
}

appStateFromContext(BuildContext context) =>
    base_provider.Provider.of<AppState>(context);
