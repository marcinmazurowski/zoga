import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/zoga_logo.dart';

class LoginPage extends StatefulWidget {
  final void Function(AppUser user) onLoggedIn;

  const LoginPage({super.key, required this.onLoggedIn});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum _LoginStep { email, code }

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  _LoginStep _step = _LoginStep.email;
  bool _loading = false;
  String? _error;
  String? _devCode;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final email = _emailController.text.trim();
    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _error = 'Podaj poprawny adres email');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final code = await AuthService.instance.requestCode(email);
    setState(() {
      _loading = false;
      _step = _LoginStep.code;
      _devCode = code; // PoC only: no email backend yet, so we show the code.
    });
  }

  Future<void> _verifyCode() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final user = await AuthService.instance.verifyCode(
      _emailController.text,
      _codeController.text.trim(),
    );
    setState(() => _loading = false);
    if (user == null) {
      setState(() => _error = 'Nieprawidłowy kod');
      return;
    }
    widget.onLoggedIn(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ZogaLogo(fontSize: 40),
                const SizedBox(height: 8),
                const Text(
                  'Multidimensional Movement',
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 1,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),
                if (_step == _LoginStep.email) ..._buildEmailStep(),
                if (_step == _LoginStep.code) ..._buildCodeStep(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEmailStep() {
    return [
      const Text(
        'Podaj adres email, aby uzyskać dostęp do swoich kursów',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: AppColors.textPrimary),
      ),
      const SizedBox(height: 24),
      TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      if (_error != null) _errorText(),
      const SizedBox(height: 20),
      _primaryButton(
        label: 'Wyślij kod',
        onPressed: _loading ? null : _sendCode,
      ),
    ];
  }

  List<Widget> _buildCodeStep() {
    return [
      Text(
        'Wysłaliśmy kod na adres\n${_emailController.text.trim()}',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
      ),
      if (_devCode != null) ...[
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'PoC (brak backendu email): kod to $_devCode',
            style: const TextStyle(fontSize: 12, color: AppColors.secondary),
          ),
        ),
      ],
      const SizedBox(height: 24),
      TextField(
        controller: _codeController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, letterSpacing: 6),
        decoration: InputDecoration(
          labelText: 'Kod',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      if (_error != null) _errorText(),
      const SizedBox(height: 20),
      _primaryButton(
        label: 'Zaloguj się',
        onPressed: _loading ? null : _verifyCode,
      ),
      TextButton(
        onPressed: _loading ? null : () => setState(() => _step = _LoginStep.email),
        child: const Text('Zmień adres email'),
      ),
    ];
  }

  Widget _errorText() => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          _error!,
          style: const TextStyle(color: AppColors.error, fontSize: 13),
        ),
      );

  Widget _primaryButton({required String label, required VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(label),
      ),
    );
  }
}
