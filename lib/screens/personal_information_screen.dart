import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../shared/tradix_shared.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;

    if (user == null) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    try {
      final row = await client
          .from('profiles')
          .select('full_name, phone')
          .eq('id', user.id)
          .maybeSingle();

      final fullName = row?['full_name'] as String?;
      final phone = row?['phone'] as String?;

      if (!mounted) return;

      _nameController.text = (fullName != null && fullName.trim().isNotEmpty)
          ? fullName.trim()
          : 'Mary Sims';

      _phoneController.text = phone ?? '';
      _emailController.text = user.email ?? '';
    } catch (_) {
      if (!mounted) return;
      _nameController.text = 'Mary Sims';
      _phoneController.text = '';
      _emailController.text = user.email ?? '';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveAndExit() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;

    if (user == null) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and email are required')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await client.from('profiles').upsert({
        'id': user.id,
        'full_name': name,
        'phone': phone,
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (email != (user.email ?? '')) {
        await client.auth.updateUser(
          UserAttributes(email: email),
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save profile')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pageBg = isDark ? TradixThemeColors.darkPageBg : TradixColors.pageBg;
    final headerBg = isDark ? TradixThemeColors.darkSurface : TradixColors.tealDark;
    final titleColor = isDark ? TradixThemeColors.darkText : Colors.white;
    final cardTextColor =
    isDark ? TradixThemeColors.darkText : TradixColors.dark;
    final fieldBg =
    isDark ? TradixThemeColors.darkCardAlt : const Color(0xFFE8E8ED);
    final fieldBorder = isDark ? TradixThemeColors.darkBorder : TradixColors.line;
    final fieldHint =
    isDark ? TradixThemeColors.darkMuted : const Color(0xFF9AA3AA);

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 26),
              decoration: BoxDecoration(
                color: headerBg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Personal Information',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: isDark
                      ? TradixThemeColors.darkTeal
                      : TradixColors.teal,
                ),
              )
                  : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel(text: 'Name'),
                    const SizedBox(height: 8),
                    _InfoField(
                      controller: _nameController,
                      hintText: 'Enter your name',
                      keyboardType: TextInputType.name,
                      fieldBg: fieldBg,
                      fieldBorder: fieldBorder,
                      hintColor: fieldHint,
                      textColor: cardTextColor,
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(text: 'Phone'),
                    const SizedBox(height: 8),
                    _InfoField(
                      controller: _phoneController,
                      hintText: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                      fieldBg: fieldBg,
                      fieldBorder: fieldBorder,
                      hintColor: fieldHint,
                      textColor: cardTextColor,
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(text: 'Email'),
                    const SizedBox(height: 8),
                    _InfoField(
                      controller: _emailController,
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      fieldBg: fieldBg,
                      fieldBorder: fieldBorder,
                      hintColor: fieldHint,
                      textColor: cardTextColor,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveAndExit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isDark ? TradixThemeColors.darkTeal : TradixColors.teal,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: const Color(0x33000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Save and Exit',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
    final isDark = TradixThemeController.isDark;

    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: isDark ? TradixThemeColors.darkText : TradixColors.dark,
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final Color fieldBg;
  final Color fieldBorder;
  final Color hintColor;
  final Color textColor;

  const _InfoField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.fieldBg,
    required this.fieldBorder,
    required this.hintColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fieldBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 15,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            color: hintColor,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
