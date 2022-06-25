import 'dart:async';
import 'dart:convert' show json;

const String _secretsPath = 'assets/secrets.json';
typedef AssetLoaderFunction<T> = Future<T> Function(
  String key,
  Future<T> Function(String value) parser,
);

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

  factory SupabaseSecretsStore._fromJson(Map<String, dynamic> jsonMap) {
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

  static Future<SupabaseSecretsStore> loadFromAssetBundle(
    AssetLoaderFunction<SupabaseSecretsStore> assetLoaderFunction,
  ) {
    return assetLoaderFunction(
      _secretsPath,
      (assetData) => Future.value(
        SupabaseSecretsStore._fromJson(
          json.decode(assetData),
        ),
      ),
    );
  }
}
