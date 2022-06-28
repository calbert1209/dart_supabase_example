import 'package:dart_supabase_example/services/snack_bar_dispatcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as base_provider;
import 'package:supabase/supabase.dart';
import 'package:dart_supabase_example/services/local_session_store.dart';
import 'package:dart_supabase_example/services/supabase_secrets_store.dart';

class AppState with ChangeNotifier {
  AppState._({
    required ISecretsStore secretsStore,
    required SupabaseClient client,
    required ISessionStore sessionStore,
    required ISnackBarDispatcher snackBarDispatcher,
    this.isSignedIn = false,
  })  : _secretStore = secretsStore,
        _client = client,
        _sessionStore = sessionStore,
        _snackBarDispatcher = snackBarDispatcher;

  final ISecretsStore _secretStore;
  final SupabaseClient _client;
  final ISessionStore _sessionStore;
  final ISnackBarDispatcher _snackBarDispatcher;

  bool isSignedIn;
  GotrueError? error;

  static Future<AppState> initialize(
    ISecretsStore secretsStore,
    SupabaseClient client,
    ISessionStore sessionStore,
    ISnackBarDispatcher snackBarDispatcher,
  ) async {
    final session = await _tryToRecoverSession(sessionStore, client);
    return AppState._(
      secretsStore: secretsStore,
      client: client,
      sessionStore: sessionStore,
      snackBarDispatcher: snackBarDispatcher,
      isSignedIn: session != null,
    );
  }

  static Future<Session?> _tryToRecoverSession(
    ISessionStore sessionStore,
    SupabaseClient client,
  ) async {
    final String? serializedSession = sessionStore.serializedSession;
    if (serializedSession == null) return Future.value(null);

    try {
      final response = await client.auth.recoverSession(serializedSession);
      return response.data;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return Future.value(null);
  }

  Future<void> _signIn(String email, String password) async {
    final response = await _client.auth.signIn(
      email: email,
      password: password,
    );
    if (response.error != null) {
      error = response.error;
      _snackBarDispatcher.showText(error!.message);
    } else {
      await _sessionStore.save(response.data!);
      isSignedIn = true;
      _snackBarDispatcher.showText('You\'re in like Flynn');
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
    await _sessionStore.clear();
    final response = await _client.auth.signOut();

    if (response.error != null) {
      error = response.error;
      _snackBarDispatcher.showText(error!.message);
    } else {
      isSignedIn = false;
      _snackBarDispatcher.showText('Goodbye');
    }
    notifyListeners();
  }

  String? get debugUserId => kDebugMode ? _secretStore.userId : null;
  String? get debugPassword => kDebugMode ? _secretStore.password : null;
}

AppState appStateFromContext(BuildContext context) =>
    base_provider.Provider.of<AppState>(context);
