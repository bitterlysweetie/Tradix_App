import 'package:flutter/material.dart';
import '../shared/tradix_shared.dart';
import '../main.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLogin = true;
  bool _obscurePassword = true;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RootScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TradixColors.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            // Dark mode toggle
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 16, 0),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: TradixColors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: TradixColors.cardShadow,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.dark_mode_outlined,
                    size: 17,
                    color: TradixColors.muted,
                  ),
                ),
              ),
            ),

            const Spacer(flex: 1),

            // Logo
            const _TradixLogo(),

            const Spacer(flex: 2),

            // Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                decoration: BoxDecoration(
                  color: TradixColors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 18,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Center(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: TradixColors.dark,
                          ),
                          children: [
                            TextSpan(text: 'Welcome to '),
                            TextSpan(
                              text: 'TradiX',
                              style: TextStyle(color: TradixColors.teal),
                            ),
                            TextSpan(text: '!'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Login / Register toggle
                    Container(
                      height: 38,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: TradixColors.pageBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          _TabButton(
                            label: 'Log in',
                            active: _isLogin,
                            onTap: () => setState(() => _isLogin = true),
                          ),
                          _TabButton(
                            label: 'Register',
                            active: !_isLogin,
                            onTap: () => setState(() => _isLogin = false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Email
                    const _FieldLabel(text: 'Email'),
                    const SizedBox(height: 6),
                    _InputField(
                      controller: _emailCtrl,
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 13),

                    // Password
                    const _FieldLabel(text: 'Password'),
                    const SizedBox(height: 6),
                    _InputField(
                      controller: _passCtrl,
                      hint: 'Enter your password',
                      obscure: _obscurePassword,
                      suffix: GestureDetector(
                        onTap: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: TradixColors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Forgot your password?',
                          style: TextStyle(
                            fontSize: 12,
                            color: TradixColors.teal,
                            decoration: TextDecoration.underline,
                            decorationColor: TradixColors.teal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TradixColors.tealInk,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: const Color(0x33000000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _isLogin ? 'Log in' : 'Register',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(color: TradixColors.line)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Text(
                            'or continue with',
                            style: TextStyle(
                              fontSize: 11,
                              color: TradixColors.muted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: TradixColors.line)),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Social buttons
                    Row(
                      children: [
                        Expanded(
                          child: _SocialButton(
                            label: 'Google',
                            icon: Icons.g_mobiledata_rounded,
                            iconColor: const Color(0xFF4285F4),
                            onTap: _submit,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _SocialButton(
                            label: 'Apple',
                            icon: Icons.apple,
                            iconColor: TradixColors.dark,
                            onTap: _submit,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class _TradixLogo extends StatelessWidget {
  const _TradixLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: TradixColors.teal,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x336AA3AB),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.trending_up_rounded,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: active ? TradixColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: active
                ? const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? TradixColors.dark : TradixColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: TradixColors.dark,
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

  const _InputField({
    required this.controller,
    required this.hint,
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
      style: const TextStyle(
        fontSize: 13,
        color: TradixColors.dark,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 13,
          color: TradixColors.muted,
        ),
        filled: true,
        fillColor: TradixColors.pageBg,
        suffixIcon: suffix != null
            ? Padding(
          padding: const EdgeInsets.only(right: 12),
          child: suffix,
        )
            : null,
        suffixIconConstraints: const BoxConstraints(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: TradixColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: TradixColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: TradixColors.teal, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: TradixColors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: TradixColors.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: TradixColors.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}