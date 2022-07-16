import 'package:dart_supabase_example/services/snack_bar_dispatcher.dart';
import 'package:dart_supabase_example/services/supabase_platform_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as base_provider;
import 'package:supabase/supabase.dart';
import 'package:dart_supabase_example/services/local_session_store.dart';
import 'package:dart_supabase_example/services/supabase_secrets_store.dart';

class AppState with ChangeNotifier {
  AppState._({
    required ISecretsStore secretsStore,
    required IPlatformClient platformClient,
    required ISessionStore sessionStore,
    required ISnackBarDispatcher snackBarDispatcher,
    this.isSignedIn = false,
  })  : _secretStore = secretsStore,
        _platformClient = platformClient,
        _sessionStore = sessionStore,
        _snackBarDispatcher = snackBarDispatcher;

  final ISecretsStore _secretStore;
  final IPlatformClient _platformClient;
  final ISessionStore _sessionStore;
  final ISnackBarDispatcher _snackBarDispatcher;

  bool isSignedIn;
  GotrueError? error;

  static Future<AppState> initialize({
    required ISecretsStore secretsStore,
    required IPlatformClient platformClient,
    required ISessionStore sessionStore,
    required ISnackBarDispatcher snackBarDispatcher,
  }) async {
    final session = await platformClient.tryToRecoverSession(
      sessionStore.serializedSession,
    );

    return AppState._(
      secretsStore: secretsStore,
      platformClient: platformClient,
      sessionStore: sessionStore,
      snackBarDispatcher: snackBarDispatcher,
      isSignedIn: session != null,
    );
  }

  Future<void> signIn(String userId, String password) async {
    try {
      isSignedIn = await _platformClient.signIn(
        userId,
        password,
        serializedSession: _sessionStore.serializedSession,
      );
    } catch (e) {
      isSignedIn = false;
    } finally {
      notifyListeners();
      _snackBarDispatcher.showText(
        isSignedIn ? 'signed in' : 'could not sign in',
      );
    }
  }

  Future<void> signOut() async {
    await _sessionStore.clear();
    final response = await _platformClient.signOut();

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

  static AppState of(BuildContext context) =>
      base_provider.Provider.of<AppState>(context);
}
