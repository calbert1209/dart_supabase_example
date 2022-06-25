import 'package:dart_supabase_example/services/supabase_secrets_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppState with ChangeNotifier {
  AppState(SupabaseSecretsStore secretsStore) : _secretStore = secretsStore;

  final SupabaseSecretsStore _secretStore;
  bool isSignedIn = false;

  Future<void> signIn() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    isSignedIn = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    isSignedIn = false;
    notifyListeners();
  }
}

appStateFromContext(BuildContext context) => Provider.of<AppState>(context);
