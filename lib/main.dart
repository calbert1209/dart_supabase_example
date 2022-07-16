import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase/supabase.dart';
import 'package:dart_supabase_example/app_state.dart';
import 'package:dart_supabase_example/pages/sign_in_page.dart';
import 'package:dart_supabase_example/services/local_session_store.dart';
import 'package:dart_supabase_example/services/supabase_secrets_store.dart';
import 'package:dart_supabase_example/services/snack_bar_dispatcher.dart';
import 'package:dart_supabase_example/services/supabase_platform_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final secretsStore = await SupabaseSecretsStore.loadFromAssetBundle(
    rootBundle.loadStructuredData<SupabaseSecretsStore>,
  );
  final sessionStore = await LocalSessionStore.initialize();
  final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  final appState = await AppState.initialize(
    secretsStore: secretsStore,
    sessionStore: sessionStore,
    platformClient: SupabasePlatformClient(
      SupabaseClient(secretsStore.url, secretsStore.key),
    ),
    snackBarDispatcher: SnackBarDispatcher(rootScaffoldMessengerKey),
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => appState,
      child: MyApp(
        messengerKey: rootScaffoldMessengerKey,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp(
      {Key? key, required GlobalKey<ScaffoldMessengerState> messengerKey})
      : _messengerKey = messengerKey,
        super(key: key);

  final GlobalKey<ScaffoldMessengerState> _messengerKey;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Supabase Example',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      scaffoldMessengerKey: _messengerKey,
      home: const SignInPage(title: 'Dart Supabase Example'),
    );
  }
}
