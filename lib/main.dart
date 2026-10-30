import 'package:flutter/material.dart';

void main() {
  runApp(const PasswordMeterApp());
}

class PasswordMeterApp extends StatelessWidget {
  const PasswordMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password Strength Meter',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const PasswordDemoPage(),
    );
  }
}

class PasswordDemoPage extends StatelessWidget {
  const PasswordDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    size: 48,
                    color: Color(0xFF6C63FF),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Create a secure password',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF20213A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Check your password strength as you type.',
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  const SizedBox(height: 28),

                  // Our reusable widget.
                  const PasswordStrengthMeter(),

                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Your password stays in this demo.',
                      style: TextStyle(fontSize: 12, color: Colors.black45),
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

// REUSABLE WIDGET
class PasswordStrengthMeter extends StatefulWidget {
  final ValueChanged<String>? onPasswordChanged;

  const PasswordStrengthMeter({super.key, this.onPasswordChanged});

  @override
  State<PasswordStrengthMeter> createState() => _PasswordStrengthMeterState();
}

class _PasswordStrengthMeterState extends State<PasswordStrengthMeter> {
  final TextEditingController _controller = TextEditingController();

  bool _obscurePassword = true;

  String get _password => _controller.text;

  // Five password checks.
  bool get _hasMinLength => _password.length >= 8;

  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(_password);

  bool get _hasLowercase => RegExp(r'[a-z]').hasMatch(_password);

  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_password);

  bool get _hasSpecialCharacter => RegExp(r'[^A-Za-z0-9]').hasMatch(_password);

  int get _score {
    return [
      _hasMinLength,
      _hasUppercase,
      _hasLowercase,
      _hasNumber,
      _hasSpecialCharacter,
    ].where((check) => check).length;
  }

  String get _strengthLabel {
    if (_password.isEmpty) return 'Not entered';
    switch (_score) {
      case 0:
      case 1:
        return 'Very weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Strong';
      default:
        return 'Very strong';
    }
  }

  Color get _strengthColor {
    if (_password.isEmpty) return Colors.blueGrey;
    switch (_score) {
      case 0:
      case 1:
        return const Color(0xFFE53935);
      case 2:
        return const Color(0xFFFF8F00);
      case 3:
        return const Color(0xFFF9C80E);
      case 4:
        return const Color(0xFF43A047);
      default:
        return const Color(0xFF00897B);
    }
  }

  void _handlePasswordChanged(String value) {
    setState(() {});
    widget.onPasswordChanged?.call(value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Password',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 10),

          // Password input and visibility button.
          TextField(
            controller: _controller,
            obscureText: _obscurePassword,
            onChanged: _handlePasswordChanged,
            decoration: InputDecoration(
              hintText: 'Enter a password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE0E2EB)),
              ),
            ),
          ),

          const SizedBox(height: 22),

          // Strength label and score.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Password strength',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                _strengthLabel,
                style: TextStyle(
                  color: _strengthColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Five animated strength segments.
          Row(
            children: List.generate(5, (index) {
              final bool isActive = _password.isNotEmpty && index < _score;

              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 8,
                  margin: EdgeInsets.only(right: index == 4 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: isActive ? _strengthColor : const Color(0xFFE8E9F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 24),

          const Text(
            'Password requirements',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 14),

          _requirementRow('At least 8 characters', _hasMinLength),
          _requirementRow('One uppercase letter (A–Z)', _hasUppercase),
          _requirementRow('One lowercase letter (a–z)', _hasLowercase),
          _requirementRow('One number (0–9)', _hasNumber),
          _requirementRow(
            'One special character (!@#...)',
            _hasSpecialCharacter,
          ),

          const SizedBox(height: 20),

          // Feedback message.
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: _strengthColor.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _password.isEmpty
                  ? 'Start typing to check your password.'
                  : _score == 5
                  ? 'Excellent! All five requirements are met.'
                  : 'You have met $_score of 5 requirements.',
              style: TextStyle(
                color: _strengthColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _requirementRow(String label, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isMet ? Icons.check_circle : Icons.circle_outlined,
              key: ValueKey(isMet),
              color: isMet ? const Color(0xFF2E9D65) : Colors.black38,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isMet ? const Color(0xFF2E9D65) : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
