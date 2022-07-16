import 'package:supabase/supabase.dart';

abstract class IPlatformClient<S, R> {
  Future<S?> tryToRecoverSession(String? serializedSession);
  Future<bool> signIn(
    String userId,
    String password, {
    String? serializedSession,
  });
  Future<R> signOut();
}

class SupabasePlatformClient
    implements IPlatformClient<Session, GotrueResponse> {
  SupabasePlatformClient(SupabaseClient client) : _client = client;

  final SupabaseClient _client;

  @override
  Future<Session?> tryToRecoverSession(String? serializedSession) async {
    if (serializedSession == null) return Future.value(null);

    try {
      final response = await _client.auth.recoverSession(serializedSession);
      return response.data;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return Future.value(null);
  }

  Future<GotrueSessionResponse> _signIn(
    String userId,
    String password,
  ) =>
      _client.auth.signIn(email: userId, password: password);

  @override
  Future<bool> signIn(
    String userId,
    String password, {
    String? serializedSession,
  }) async {
    Session? session;
    if (serializedSession != null) {
      session = await tryToRecoverSession(serializedSession);
    }

    if (session == null) {
      final response = await _signIn(userId, password);
      session = response.data;
    }

    return Future.value(session != null);
  }

  @override
  Future<GotrueResponse> signOut() async => _client.auth.signOut();
}
