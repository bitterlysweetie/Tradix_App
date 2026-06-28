import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../shared/tradix_shared.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _forgotPassword() async {
    final email = _emailCtrl.text.trim();

    if (email.isEmpty) {
      _showMessage('Enter your email first');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'tradix://reset-password',
      );

      _showMessage('Password reset link sent. Check your email.');
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

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Enter email and password');
      return;
    }

    if (!_isLogin && name.isEmpty) {
      _showMessage('Enter your name');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final supabase = Supabase.instance.client;

      if (_isLogin) {
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } else {
        final response = await supabase.auth.signUp(
          email: email,
          password: password,
          data: {
            'full_name': name,
          },
        );

        final user = response.user;

        if (response.session != null && user != null) {
          await supabase.from('profiles').upsert({
            'id': user.id,
            'full_name': name,
            'updated_at': DateTime.now().toIso8601String(),
          });
        }

        if (!mounted) return;

        if (response.session == null) {
          _showMessage('Check your email to confirm the account.');
        }
      }
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
    final gradientColors = isDark
        ? const [
      Color(0xFF07111F),
      TradixColors.tealDark,
    ]
        : const [
      Color(0xFFFDF7F8),
      TradixColors.tealDark,
    ];

    final cardBg = isDark ? TradixThemeColors.darkSurface : Colors.white;
    final cardShadow = isDark ? TradixThemeColors.darkShadow : const Color(0x22000000);
    final titleColor = isDark ? TradixThemeColors.darkText : TradixColors.dark;
    final bodyColor = isDark ? TradixThemeColors.darkMuted : TradixColors.muted;
    final fieldFill = isDark ? TradixThemeColors.darkSurfaceAlt : const Color(0xFFE8E8ED);
    final fieldText = isDark ? TradixThemeColors.darkText : TradixColors.dark;
    final fieldBorder = isDark ? TradixThemeColors.darkBorder : Colors.transparent;
    final tabBarFill = isDark ? TradixThemeColors.darkSurfaceAlt : const Color(0xFFE8E9EC);
    final tabActiveBg = isDark ? TradixThemeColors.darkCard : Colors.white;
    final tabActiveText = isDark ? TradixThemeColors.darkText : TradixColors.tealInk;
    final tabInactiveText = isDark ? TradixThemeColors.darkMuted : TradixColors.muted;
    final labelColor = isDark ? TradixThemeColors.darkText : TradixColors.dark;
    final hintColor = isDark ? TradixThemeColors.darkMuted : TradixColors.muted;
    final iconCircleBg = isDark ? TradixThemeColors.darkIconBg : const Color(0xFFB9D2D7);
    final linkColor = isDark ? TradixThemeColors.darkTealSoft : TradixColors.tealDark;
    final linkDecoration = isDark ? TradixThemeColors.darkTealSoft : TradixColors.teal;
    final buttonGradient = isDark
        ? const [
      Color(0xFF0F1A2A),
      Color(0xFF4F7E8B),
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
                      colors: gradientColors,
                      stops: const [0.37, 1],
                    ),
                  ),
                ),
                Positioned(
                  top: 18,
                  right: 24,
                  child: GestureDetector(
                    onTap: TradixThemeController.toggle,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconCircleBg,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Icon(
                        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        size: 21,
                        color: isDark
                            ? TradixThemeColors.darkText
                            : const Color(0xFF2E2E2E),
                      ),
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
                          top: h * 0.10,
                          left: 0,
                          right: 0,
                          child: const Center(
                            child: _TradixLogo(),
                          ),
                        ),
                        Positioned(
                          top: h * 0.32,
                          left: w * 0.13,
                          right: w * 0.13,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 18, 15, 22),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: cardShadow,
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
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: titleColor,
                                      ),
                                      children: [
                                        const TextSpan(text: 'Welcome to '),
                                        TextSpan(
                                          text: 'TradiX',
                                          style: TextStyle(
                                            color: isDark
                                                ? TradixThemeColors.darkTeal
                                                : TradixColors.tealDark,
                                          ),
                                        ),
                                        const TextSpan(text: '!'),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: tabBarFill,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      _TabButton(
                                        label: 'Log in',
                                        active: _isLogin,
                                        activeBg: tabActiveBg,
                                        activeText: tabActiveText,
                                        inactiveText: tabInactiveText,
                                        onTap: () =>
                                            setState(() => _isLogin = true),
                                      ),
                                      _TabButton(
                                        label: 'Register',
                                        active: !_isLogin,
                                        activeBg: tabActiveBg,
                                        activeText: tabActiveText,
                                        inactiveText: tabInactiveText,
                                        onTap: () =>
                                            setState(() => _isLogin = false),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (!_isLogin) ...[
                                  _FieldLabel(text: 'Name', color: labelColor),
                                  const SizedBox(height: 6),
                                  _InputField(
                                    controller: _nameCtrl,
                                    hint: 'Enter your name',
                                    keyboardType: TextInputType.name,
                                    fillColor: fieldFill,
                                    textColor: fieldText,
                                    hintColor: hintColor,
                                    borderColor: fieldBorder,
                                  ),
                                  const SizedBox(height: 14),
                                ],
                                _FieldLabel(text: 'Email', color: labelColor),
                                const SizedBox(height: 6),
                                _InputField(
                                  controller: _emailCtrl,
                                  hint: 'Enter your email',
                                  keyboardType: TextInputType.emailAddress,
                                  fillColor: fieldFill,
                                  textColor: fieldText,
                                  hintColor: hintColor,
                                  borderColor: fieldBorder,
                                ),
                                const SizedBox(height: 14),
                                _FieldLabel(text: 'Password', color: labelColor),
                                const SizedBox(height: 6),
                                _InputField(
                                  controller: _passCtrl,
                                  hint: 'Enter your password',
                                  obscure: _obscurePassword,
                                  fillColor: fieldFill,
                                  textColor: fieldText,
                                  hintColor: hintColor,
                                  borderColor: fieldBorder,
                                  suffix: GestureDetector(
                                    onTap: () => setState(
                                          () => _obscurePassword = !_obscurePassword,
                                    ),
                                    child: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 18,
                                      color: bodyColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: _isSubmitting ? null : _forgotPassword,
                                    child: Text(
                                      'Forgot your password?',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: linkColor,
                                        decoration: TextDecoration.underline,
                                        decorationColor: linkDecoration,
                                      ),
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
                                      onPressed: _isSubmitting ? null : _submit,
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
                                          : Text(
                                        _isLogin ? 'Log in' : 'Register',
                                        style: const TextStyle(
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

class _TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color activeBg;
  final Color activeText;
  final Color inactiveText;

  const _TabButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    required this.activeBg,
    required this.activeText,
    required this.inactiveText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: active
                ? const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 6,
                offset: Offset(0, 0),
              ),
            ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: active ? activeText : inactiveText,
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _FieldLabel({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType keyboardType;
  final Widget? suffix;
  final Color fillColor;
  final Color textColor;
  final Color hintColor;
  final Color borderColor;

  const _InputField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
    required this.fillColor,
    required this.textColor,
    required this.hintColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 13,
        color: textColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 13,
          color: hintColor,
        ),
        filled: true,
        fillColor: fillColor,
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
          borderSide: BorderSide(color: borderColor, width: 1.2),
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
