import 'package:dart_supabase_example/widgets/fixed_height_linear_progress_indicator.dart';
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
            ),
            ElevatedButton(
              onPressed: isSignedIn
                  ? null
                  : () => whileLoading(() => appState.signIn()),
              child: const Text("sign in"),
            ),
            ElevatedButton(
              onPressed: isSignedIn
                  ? () => whileLoading(() => appState.signOut())
                  : null,
              child: const Text("sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
