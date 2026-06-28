import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../shared/tradix_shared.dart';
import 'sign_in_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _savePassword() async {
    final password = _passwordCtrl.text;
    final confirmPassword = _confirmPasswordCtrl.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Enter and confirm your new password');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: password),
      );

      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SignInScreen()),
            (_) => false,
      );
    } on AuthException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage('Something went wrong');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pageBg = isDark ? TradixThemeColors.darkPageBg : TradixColors.pageBg;
    final topGradient = isDark
        ? const [
      Color(0xFF07111F),
      TradixColors.tealDark,
    ]
        : const [
      Color(0xFFFDF7F8),
      TradixColors.tealDark,
    ];

    final cardBg = isDark ? TradixThemeColors.darkSurface : Colors.white;
    final titleColor = isDark ? TradixThemeColors.darkText : TradixColors.dark;
    final fieldBg =
    isDark ? TradixThemeColors.darkCardAlt : const Color(0xFFE8E8ED);
    final fieldHint = isDark ? TradixThemeColors.darkMuted : TradixColors.muted;
    final fieldText = isDark ? TradixThemeColors.darkText : TradixColors.dark;
    final iconCircle =
    isDark ? TradixThemeColors.darkIconBg : const Color(0xFFB9D2D7);
    final iconColor = isDark ? TradixThemeColors.darkText : const Color(0xFF2E2E2E);
    final buttonGradient = isDark
        ? const [
      TradixThemeColors.darkTeal,
      TradixThemeColors.darkTealSoft,
    ]
        : const [
      TradixColors.tealPro,
      TradixColors.tealSoft,
    ];

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: topGradient,
                      stops: const [0.37, 1],
                    ),
                  ),
                ),
                Positioned(
                  top: 18,
                  right: 24,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconCircle,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_reset_rounded,
                      size: 21,
                      color: iconColor,
                    ),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final h = constraints.maxHeight;
                    final w = constraints.maxWidth;

                    return Stack(
                      children: [
                        Positioned(
                          top: h * 0.15,
                          left: 0,
                          right: 0,
                          child: const Center(
                            child: _TradixLogo(),
                          ),
                        ),
                        Positioned(
                          top: h * 0.37,
                          left: w * 0.13,
                          right: w * 0.13,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 18, 15, 22),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? TradixThemeColors.darkShadow
                                      : const Color(0x22000000),
                                  blurRadius: 22,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Text(
                                    'Reset password',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: titleColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                _FieldLabel(text: 'New password'),
                                const SizedBox(height: 6),
                                _InputField(
                                  controller: _passwordCtrl,
                                  hint: 'Enter new password',
                                  obscure: _obscurePassword,
                                  fieldBg: fieldBg,
                                  fieldText: fieldText,
                                  fieldHint: fieldHint,
                                  suffix: GestureDetector(
                                    onTap: () => setState(
                                          () => _obscurePassword = !_obscurePassword,
                                    ),
                                    child: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 18,
                                      color: fieldHint,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                _FieldLabel(text: 'Confirm password'),
                                const SizedBox(height: 6),
                                _InputField(
                                  controller: _confirmPasswordCtrl,
                                  hint: 'Confirm new password',
                                  obscure: _obscureConfirmPassword,
                                  fieldBg: fieldBg,
                                  fieldText: fieldText,
                                  fieldHint: fieldHint,
                                  suffix: GestureDetector(
                                    onTap: () => setState(
                                          () => _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                                    ),
                                    child: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 18,
                                      color: fieldHint,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: buttonGradient,
                                      ),
                                      borderRadius: BorderRadius.circular(11),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x33000000),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed:
                                      _isSubmitting ? null : _savePassword,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(11),
                                        ),
                                      ),
                                      child: _isSubmitting
                                          ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                          : const Text(
                                        'Save password',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TradixLogo extends StatelessWidget {
  const _TradixLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      width: 120,
      height: 120,
      fit: BoxFit.contain,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;

    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? TradixThemeColors.darkText : TradixColors.dark,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Color fieldBg;
  final Color fieldText;
  final Color fieldHint;
  final Widget? suffix;
  final TextInputType keyboardType;

  const _InputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.fieldBg,
    required this.fieldText,
    required this.fieldHint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 13,
        color: fieldText,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 13,
          color: fieldHint,
        ),
        filled: true,
        fillColor: fieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: TradixColors.teal, width: 1.2),
        ),
        suffixIcon: suffix != null
            ? Padding(
          padding: const EdgeInsets.only(right: 12),
          child: suffix,
        )
            : null,
        suffixIconConstraints: const BoxConstraints(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
      ),
    );
  }
}
