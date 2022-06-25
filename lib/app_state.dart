import 'package:dart_supabase_example/services/supabase_secrets_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as base_provider;
import 'package:supabase/supabase.dart';

class AppState with ChangeNotifier {
  AppState(SupabaseSecretsStore secretsStore, SupabaseClient client)
      : _secretStore = secretsStore,
        _client = client;

  late SupabaseSecretsStore _secretStore;
  late SupabaseClient _client;
  bool isSignedIn = false;
  GotrueError? error;

  Future<void> _signIn(String email, String password) async {
    final response = await _client.auth.signIn(
      email: email,
      password: password,
    );
    if (response.error != null) {
      error = response.error;
      print(error);
    } else {
      isSignedIn = true;
    }
    notifyListeners();
  }

  Future<void> signIn() {
    return _signIn(_secretStore.userId, _secretStore.password);
  }

  Future<void> signOut() async {
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
