import 'package:flutter/material.dart';

import '../../services/auth/auth_service.dart';
import '../../services/auth/auth_services.dart';
import '../../theme/philotes_colors.dart';
import 'verify_email_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  bool get _hasMinimumLength => _passwordController.text.length >= 15;

  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(_passwordController.text);

  bool get _hasLowercase => RegExp(r'[a-z]').hasMatch(_passwordController.text);

  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_passwordController.text);

  bool get _hasSymbol =>
      RegExp(r'[^A-Za-z0-9]').hasMatch(_passwordController.text);

  bool get _passwordMeetsRequirements =>
      _hasMinimumLength &&
      _hasUppercase &&
      _hasLowercase &&
      _hasNumber &&
      _hasSymbol;

  bool get _emailIsValid {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      return false;
    }

    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  bool get _passwordsMatch =>
      _confirmPasswordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  bool get _formIsValid =>
      _emailIsValid && _passwordMeetsRequirements && _passwordsMatch;

  void _refreshValidation(String value) {
    setState(() {});
  }

  Future<void> _createAccount() async {
    if (!_formIsValid) return;
    final email = _emailController.text.trim();
    try {
      await AuthServices.current.register(
        email: email,
        password: _passwordController.text,
      );
      await AuthServices.current.login(
        email: email,
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => VerifyEmailScreen(email: email),
        ),
      );
    } on AuthApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Philotes could not reach the account service. '
            'Confirm the backend is running and try again.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhilotesColors.ivory,
      appBar: AppBar(
        backgroundColor: PhilotesColors.ivory,
        foregroundColor: PhilotesColors.navy,
        elevation: 0,
        title: const Text(
          'Join Philotes',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Create Your Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Container(
                      width: 135,
                      height: 2,
                      decoration: BoxDecoration(
                        color: PhilotesColors.gold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Your Philotes account starts with a verified email '
                    'address and a secure password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Email Address',
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    key: const Key('emailField'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    onChanged: _refreshValidation,
                    decoration: InputDecoration(
                      hintText: 'name@example.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.65),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: PhilotesColors.gold.withValues(alpha: 0.65),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: PhilotesColors.gold,
                          width: 2,
                        ),
                      ),
                      errorText:
                          _emailController.text.isNotEmpty && !_emailIsValid
                          ? 'Enter a valid email address.'
                          : null,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Create Password',
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    key: const Key('passwordField'),
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.next,
                    onChanged: _refreshValidation,
                    decoration: InputDecoration(
                      hintText: 'Create a secure password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        key: const Key('passwordVisibilityButton'),
                        tooltip: _showPassword
                            ? 'Hide password'
                            : 'Show password',
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.65),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: PhilotesColors.gold.withValues(alpha: 0.65),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: PhilotesColors.gold,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: PhilotesColors.gold.withValues(alpha: 0.55),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your password must include:',
                          style: TextStyle(
                            color: PhilotesColors.navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 10),

                        _PasswordRequirement(
                          label: 'At least 15 characters',
                          complete: _hasMinimumLength,
                        ),

                        _PasswordRequirement(
                          label: 'At least 1 uppercase letter',
                          complete: _hasUppercase,
                        ),

                        _PasswordRequirement(
                          label: 'At least 1 lowercase letter',
                          complete: _hasLowercase,
                        ),

                        _PasswordRequirement(
                          label: 'At least 1 number',
                          complete: _hasNumber,
                        ),

                        _PasswordRequirement(
                          label: 'At least 1 symbol',
                          complete: _hasSymbol,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Confirm Password',
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    key: const Key('confirmPasswordField'),
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.done,
                    onChanged: _refreshValidation,
                    onSubmitted: (_) {
                      if (_formIsValid) {
                        _createAccount();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your password again',
                      prefixIcon: const Icon(Icons.lock_reset_outlined),
                      suffixIcon: IconButton(
                        key: const Key('confirmPasswordVisibilityButton'),
                        tooltip: _showConfirmPassword
                            ? 'Hide password'
                            : 'Show password',
                        onPressed: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _showConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.65),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: PhilotesColors.gold.withValues(alpha: 0.65),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: PhilotesColors.gold,
                          width: 2,
                        ),
                      ),
                      errorText:
                          _confirmPasswordController.text.isNotEmpty &&
                              !_passwordsMatch
                          ? 'Passwords do not match.'
                          : null,
                    ),
                  ),

                  if (_passwordsMatch) ...[
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: PhilotesColors.gold,
                          size: 18,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Passwords match',
                          style: TextStyle(
                            color: PhilotesColors.navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 30),

                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      key: const Key('createAccountButton'),
                      onPressed: _formIsValid ? _createAccount : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: PhilotesColors.navy,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: PhilotesColors.navy.withValues(
                          alpha: 0.35,
                        ),
                        disabledForegroundColor: Colors.white.withValues(
                          alpha: 0.75,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'We will verify your email address before you continue '
                    'with your Philotes profile.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Friendship  •  Trust  •  Community  •  Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.gold,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordRequirement extends StatelessWidget {
  const _PasswordRequirement({required this.label, required this.complete});

  final String label;
  final bool complete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            complete ? Icons.check_circle : Icons.radio_button_unchecked,
            color: complete ? PhilotesColors.gold : PhilotesColors.silver,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: complete ? PhilotesColors.navy : PhilotesColors.silver,
                fontSize: 13,
                fontWeight: complete ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
