import 'dart:async';
import 'dart:convert' show json;

const String _secretsPath = 'assets/secrets.json';
typedef AssetLoaderFunction<T> = Future<T> Function(
  String key,
  Future<T> Function(String value) parser,
);

abstract class ISecretsStore {
  String get url;
  String get key;
  String get userId;
  String get password;
}

class SupabaseSecretsStore implements ISecretsStore {
  SupabaseSecretsStore._({
    required this.url,
    required this.key,
    required this.userId,
    required this.password,
  });

  @override
  final String url;
  @override
  final String key;
  @override
  final String userId;
  @override
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
