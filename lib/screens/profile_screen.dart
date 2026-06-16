import 'package:flutter/material.dart';
import '../shared/tradix_shared.dart';

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
                color: TradixColors.teal,
              ),
              child: const Column(
                children: [
                  Text(
                    'Profile and Settings',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 18),
                  _ProfileAvatar(),
                  SizedBox(height: 12),
                  Text(
                    'Mary Sims',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'mary.sims@email.com',
                    style: TextStyle(
                      fontSize: 12,
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
                          Navigator.of(context).pushNamed(AppRoutes.buyPro);
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    const SectionLabel(text: 'ACCOUNT INFORMATION'),
                    const SizedBox(height: 8),
                    const SectionCard(
                      children: [
                        MenuRow(
                          icon: Icons.person,
                          title: 'Personal Information',
                          subtitle: 'Name, email, phone',
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
                    const SectionLabel(text: 'PREFERENCES'),
                    const SizedBox(height: 8),
                    const SectionCard(
                      children: [
                        SwitchRow(
                          icon: Icons.dark_mode,
                          title: 'Dark Mode',
                          subtitle: 'Enabled',
                          value: true,
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
      bottomNavigationBar: const TradixBottomBar(currentIndex: 3),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEFEFEF), width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'MS',
          style: TextStyle(
            fontSize: 24,
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
          elevation: 3,
          shadowColor: const Color(0x33000000),
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
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}