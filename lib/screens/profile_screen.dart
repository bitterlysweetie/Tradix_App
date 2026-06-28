import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/buy_pro_screen.dart';
import '../screens/personal_information_screen.dart';
import '../screens/sign_in_screen.dart';
import '../shared/tradix_shared.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<_ProfileData> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<_ProfileData> _loadProfile() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;

    if (user == null) {
      return const _ProfileData(
        name: 'New User',
        email: 'new.user@email.com',
      );
    }

    try {
      final row = await client
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .maybeSingle();

      final fullName = row?['full_name'] as String?;

      return _ProfileData(
        name: (fullName != null && fullName.trim().isNotEmpty)
            ? fullName.trim()
            : 'New User',
        email: user.email ?? 'new.user@email.com',
      );
    } catch (_) {
      return _ProfileData(
        name: 'New User',
        email: user.email ?? 'new.user@email.com',
      );
    }
  }

  Future<void> _openPersonalInfo() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PersonalInformationScreen(),
      ),
    );

    if (!mounted) return;

    setState(() {
      _profileFuture = _loadProfile();
    });
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
          (_) => false,
    );
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete account?'),
          content: const Text(
            'This will permanently delete your account and profile data.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'delete-account',
      );

      if (response.status != 200) {
        throw Exception('Delete failed');
      }

      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SignInScreen()),
            (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pageBg = isDark ? TradixThemeColors.darkPageBg : TradixColors.pageBg;
    final headerBg = isDark ? TradixThemeColors.darkSurface : TradixColors.tealDark;
    final titleColor = isDark ? TradixThemeColors.darkText : Colors.white;
    final emailColor = isDark ? TradixThemeColors.darkText : const Color(0xE6FFFFFF);
    final avatarBg = isDark ? TradixColors.tealDark : const Color(0xFFECECEC);
    final avatarBorder = isDark ? TradixThemeColors.darkBorder : const Color(0xFFEFEFEF);
    final logoutBg = isDark ? TradixThemeColors.darkTeal : TradixColors.tealDark;
    final logoutShadow = isDark ? TradixThemeColors.darkShadow : const Color(0x33000000);
    final upgradeShadow = isDark ? TradixThemeColors.darkShadow : TradixColors.tealDark;
    final upgradeBg = isDark ? TradixThemeColors.darkTeal : TradixColors.teal;

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 34),
              decoration: BoxDecoration(
                color: headerBg,
              ),
              child: FutureBuilder<_ProfileData>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  final data = snapshot.data ??
                      const _ProfileData(
                        name: 'New User',
                        email: 'new.user@email.com',
                      );

                  return Column(
                    children: [
                      Text(
                        'Profile and Settings',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 22,
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TradixInitialsAvatar(
                        name: data.name,
                        size: 90,
                        backgroundColor: avatarBg,
                        borderColor: avatarBorder,
                        textColor: isDark
                            ? TradixColors.tealPro
                            : TradixColors.tealInk,
                        fontSize: 26,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        data.name,
                        style: TextStyle(
                          fontSize: 20,
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: emailColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: pageBg,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                  children: [
                    Center(
                      child: _UpgradeButton(
                        backgroundColor: upgradeBg,
                        shadowColor: upgradeShadow,
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (_, _, _) => const BuyProScreen(),
                              transitionsBuilder: (_, animation, __, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    SectionLabel(text: 'ACCOUNT INFORMATION'),
                    const SizedBox(height: 8),
                    SectionCard(
                      children: [
                        InkWell(
                          onTap: _openPersonalInfo,
                          child: MenuRow(
                            icon: Icons.person,
                            title: 'Personal Information',
                            subtitle: 'Name, email, phone',
                          ),
                        ),
                        DividerRow(),
                        MenuRow(
                          icon: Icons.lock,
                          title: 'Security & Privacy',
                          subtitle: 'Password, 2FA, biometrics',
                        ),
                        DividerRow(),
                        MenuRow(
                          icon: Icons.credit_card,
                          title: 'Payment Methods',
                          subtitle: 'Manage cards & account',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SectionLabel(text: 'PREFERENCES'),
                    const SizedBox(height: 8),
                    SectionCard(
                      children: [
                        SwitchRow(
                          icon: Icons.dark_mode,
                          title: 'Dark Mode',
                          subtitle:
                          TradixThemeController.isDark ? 'Enabled' : 'Disabled',
                          value: TradixThemeController.isDark,
                          onChanged: (value) {
                            setState(() {
                              TradixThemeController.setDarkMode(value);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SectionLabel(text: 'NOTIFICATIONS'),
                    const SizedBox(height: 8),
                    SectionCard(
                      children: [
                        SwitchRow(
                          icon: Icons.campaign,
                          title: 'Market News',
                          subtitle: 'Breaking news updates',
                          value: true,
                        ),
                        DividerRow(),
                        SwitchRow(
                          icon: Icons.folder_open,
                          title: 'Portfolio Updates',
                          subtitle: 'Performance reports',
                          value: false,
                        ),
                        DividerRow(),
                        SwitchRow(
                          icon: Icons.sell,
                          title: 'Marketing',
                          subtitle: 'Promotions & Tips',
                          value: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SectionLabel(text: 'ACCOUNT INFORMATION'),
                    const SizedBox(height: 8),
                    SectionCard(
                      children: [
                        MenuRow(
                          icon: Icons.help_outline,
                          title: 'Help Center',
                          subtitle: 'FAQs and support',
                        ),
                        DividerRow(),
                        MenuRow(
                          icon: Icons.description_outlined,
                          title: 'Terms & Conditions',
                          subtitle: 'Legal documents',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: logoutBg,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shadowColor: logoutShadow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Log out',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DeleteButton(
                      onPressed: _deleteAccount,
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileData {
  final String name;
  final String email;

  const _ProfileData({
    required this.name,
    required this.email,
  });
}

class _UpgradeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color shadowColor;

  const _UpgradeButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 34,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: shadowColor,
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
        child: const Center(
          child: Text(
            'UPGRADE TO PRO',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: TradixColors.tealDark,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
