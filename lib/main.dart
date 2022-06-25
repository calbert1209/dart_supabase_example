import 'dart:async';
import 'package:dart_supabase_example/pages/sign_in_page.dart';
import 'package:dart_supabase_example/services/supabase_secrets_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase/supabase.dart';

import 'app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final secretsStore = await SupabaseSecretsStore.loadFromAssetBundle(
    rootBundle.loadStructuredData<SupabaseSecretsStore>,
  );

  final supabaseClient = SupabaseClient(secretsStore.url, secretsStore.key);

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(secretsStore, supabaseClient),
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
