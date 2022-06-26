import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as base_provider;
import 'package:supabase/supabase.dart';
import 'package:dart_supabase_example/services/local_session_store.dart';
import 'package:dart_supabase_example/services/supabase_secrets_store.dart';

class AppState with ChangeNotifier {
  AppState._({
    required SupabaseSecretsStore secretsStore,
    required SupabaseClient client,
    required LocalSessionStore sessionStore,
    this.isSignedIn = false,
  })  : _secretStore = secretsStore,
        _client = client,
        _sessionStore = sessionStore;

  final SupabaseSecretsStore _secretStore;
  final SupabaseClient _client;
  final LocalSessionStore _sessionStore;
  bool isSignedIn;
  GotrueError? error;

  static Future<AppState> initialize(
    SupabaseSecretsStore secretsStore,
    SupabaseClient client,
    LocalSessionStore sessionStore,
  ) async {
    final session = await _tryToRecoverSession(sessionStore, client);
    return AppState._(
      secretsStore: secretsStore,
      client: client,
      sessionStore: sessionStore,
      isSignedIn: session != null,
    );
  }

  static Future<Session?> _tryToRecoverSession(
    LocalSessionStore sessionStore,
    SupabaseClient client,
  ) async {
    final String? serializedSession = sessionStore.serializedSession;
    if (serializedSession == null) return Future.value(null);

    try {
      final response = await client.auth.recoverSession(serializedSession);
      return response.data;
    } catch (e) {
      print(e);
    }

    return Future.value(null);
  }

  Future<bool> _clearSession() => _sessionStore.clear();

  Future<void> _signIn(String email, String password) async {
    final response = await _client.auth.signIn(
      email: email,
      password: password,
    );
    if (response.error != null) {
      error = response.error;
      print(error);
    } else {
      await _sessionStore.save(response.data!);
      isSignedIn = true;
      notifyListeners();
    }
  }

  Future<void> signIn(String userId, String password) async {
    final session = await _tryToRecoverSession(_sessionStore, _client);
    if (session != null) {
      isSignedIn = true;
      notifyListeners();
      return;
    }

    return _signIn(userId, password);
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

  String? get debugUserId => kDebugMode ? _secretStore.userId : null;
  String? get debugPassword => kDebugMode ? _secretStore.password : null;
}

AppState appStateFromContext(BuildContext context) =>
    base_provider.Provider.of<AppState>(context);
