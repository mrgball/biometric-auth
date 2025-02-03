import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication bioAuth = LocalAuthentication();
  bool _isAuthenticated = false;

  Future<void> _authenticate() async {
    try {
      bool canCheckBiometrics = await bioAuth.canCheckBiometrics;

      if (!canCheckBiometrics) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Biometric authentication not available'),
        ));
        return;
      }

      bool isAuthenticated = await bioAuth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticated',
        options: AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      setState(() {
        _isAuthenticated = isAuthenticated;
      });

      if (isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Authentication successfull!'),
        ));
      }
    } catch (e) {
      print('Error during authentication: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('isAuthenticated: ${_isAuthenticated}');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isAuthenticated ? "Authenticated!" : "Tap to authenticate",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text('Authenticate with bioometrics'),
            )
          ],
        ),
      ),
    );
  }
}
