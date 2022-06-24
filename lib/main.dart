import 'dart:convert' show json;
import 'package:dart_supabase_example/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SupabaseSecretsStore {
  SupabaseSecretsStore._({
    required this.url,
    required this.key,
    required this.userId,
    required this.password,
  });

  final String url;
  final String key;
  final String userId;
  final String password;

  factory SupabaseSecretsStore.fromJson(Map<String, dynamic> jsonMap) {
    final url = jsonMap['supabaseURL'];
    final key = jsonMap['supabaseAnonKey'];
    final userId = jsonMap['devUserName'];
    final password = jsonMap['devPassword'];

    if ([url, key, userId, password].any((x) => x == null)) {
      throw StateError('null value in args');
    }

    return SupabaseSecretsStore._(
      url: jsonMap['supabaseURL']!,
      key: jsonMap['supabaseAnonKey']!,
      userId: jsonMap['devUserName']!,
      password: jsonMap['devPassword']!,
    );
  }
}

Future<SupabaseSecretsStore> loadAsset() {
  return rootBundle.loadStructuredData<SupabaseSecretsStore>(
    'assets/secrets.json',
    (value) => Future.value(
      SupabaseSecretsStore.fromJson(
        json.decode(value),
      ),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  loadAsset().then((config) => print(config));

  runApp(const MyApp());
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
