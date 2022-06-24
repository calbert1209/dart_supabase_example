import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;
  bool _isSignedIn = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 3000));
    setState(() {
      _isLoading = false;
      _isSignedIn = true;
    });
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 3000));
    setState(() {
      _isLoading = false;
      _isSignedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isLoading) const CircularProgressIndicator(),
            if (_isLoading) const SizedBox(height: 10.0),
            Icon(
              _isSignedIn ? Icons.lock_open : Icons.lock,
            ),
            ElevatedButton(
              onPressed: _isSignedIn
                  ? null
                  : () {
                      print('sign in button pushed');
                      _signIn();
                    },
              child: const Text("sign in"),
            ),
            ElevatedButton(
              onPressed: _isSignedIn
                  ? () {
                      print('sign out button pushed');
                      _signOut();
                    }
                  : null,
              child: const Text("sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
