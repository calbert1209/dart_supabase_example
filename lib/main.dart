import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase/supabase.dart';
import 'package:dart_supabase_example/app_state.dart';
import 'package:dart_supabase_example/pages/sign_in_page.dart';
import 'package:dart_supabase_example/services/local_session_store.dart';
import 'package:dart_supabase_example/services/supabase_secrets_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final secretsStore = await SupabaseSecretsStore.loadFromAssetBundle(
    rootBundle.loadStructuredData<SupabaseSecretsStore>,
  );

  final supabaseClient = SupabaseClient(secretsStore.url, secretsStore.key);
  final sessionStore = await LocalSessionStore.initialize();
  final appState = await AppState.initialize(
    secretsStore,
    supabaseClient,
    sessionStore,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => appState,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInPage(title: 'Flutter Demo Home Page'),
    );
  }
}
