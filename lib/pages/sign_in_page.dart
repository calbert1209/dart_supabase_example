import 'package:dart_supabase_example/widgets/fixed_height_linear_progress_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dart_supabase_example/app_state.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;
  String? _userId;
  String? _password;

  Future<void> whileLoading(Future<void> Function() fn) async {
    setState(() {
      _isLoading = true;
    });
    await fn();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = appStateFromContext(context);
    final isSignedIn = appState.isSignedIn;
    final userId = (_userId ?? appState.debugUserId);
    final password = (_password ?? appState.debugPassword);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FixedHeightLinearProgressIndicator(isShowing: _isLoading),
            const SizedBox(height: 10.0),
            Icon(
              isSignedIn ? Icons.lock_open : Icons.lock,
              color: Colors.teal.shade800,
            ),
            ElevatedButton(
              onPressed: isSignedIn || userId == null || password == null
                  ? null
                  : () => whileLoading(
                        () => appState.signIn(userId, password),
                      ),
              child: const Text("sign in"),
            ),
            ElevatedButton(
              onPressed: isSignedIn
                  ? () => whileLoading(() => appState.signOut())
                  : null,
              child: const Text("sign out"),
            ),
            const SizedBox(height: 18),
            TextFormField(
              readOnly: isSignedIn,
              enabled: !isSignedIn,
              decoration: const InputDecoration(
                labelText: 'Email',
                contentPadding: EdgeInsets.all(10.0),
              ),
              initialValue: appState.debugUserId,
              onChanged: (value) => setState(() {
                _userId = value;
              }),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              readOnly: isSignedIn,
              enabled: !isSignedIn,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                contentPadding: EdgeInsets.all(10.0),
              ),
              initialValue: appState.debugPassword,
              onChanged: (value) => setState(() {
                _password = value;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
