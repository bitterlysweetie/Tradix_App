import 'package:flutter/material.dart';
import '../shared/tradix_shared.dart';
import '../screens/buy_pro_screen.dart';
import '../screens/personal_information_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TradixColors.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 34),
              decoration: const BoxDecoration(
                color: TradixColors.tealDark,
              ),
              child: Column(
                children: [
                  Text(
                    'Profile and Settings',
                    style: GoogleFonts.instrumentSans(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                  _ProfileAvatar(),
                  SizedBox(height: 15),
                  Text(
                    'Mary Sims',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'mary.sims@email.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xE6FFFFFF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: TradixColors.pageBg,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                  children: [
                    Center(
                      child: _UpgradeButton(
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
                    const SectionLabel(text: 'ACCOUNT INFORMATION'),
                    const SizedBox(height: 8),
                    SectionCard(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PersonalInformationScreen(),
                              ),
                            );
                          },
                          child: const MenuRow(
                            icon: Icons.person,
                            title: 'Personal Information',
                            subtitle: 'Name, email, phone',
                          ),
                        ),
                        const DividerRow(),
                        const MenuRow(
                          icon: Icons.lock,
                          title: 'Security & Privacy',
                          subtitle: 'Password, 2FA, biometrics',
                        ),
                        const DividerRow(),
                        const MenuRow(
                          icon: Icons.credit_card,
                          title: 'Payment Methods',
                          subtitle: 'Manage cards & account',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const SectionLabel(text: 'PREFERENCES'),
                    const SizedBox(height: 8),
                    const SectionCard(
                      children: [
                        SwitchRow(
                          icon: Icons.dark_mode,
                          title: 'Dark Mode',
                          subtitle: 'Disabled',
                          value: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const SectionLabel(text: 'NOTIFICATIONS'),
                    const SizedBox(height: 8),
                    const SectionCard(
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
                    const SectionLabel(text: 'ACCOUNT INFORMATION'),
                    const SizedBox(height: 8),
                    const SectionCard(
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
                    const SizedBox(height: 18),
                    const DeleteButton(),
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

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFECECEC),
        border: Border.all(color: const Color(0xFFEFEFEF), width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFFFFFFF),
            blurRadius: 14,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'MS',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: TradixColors.tealInk,
          ),
        ),
      ),
    );
  }
}

class _UpgradeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _UpgradeButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 34,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: TradixColors.teal,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: TradixColors.teal,
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
                  color: Color(0x1A000000),
                  offset: Offset(0,2)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}