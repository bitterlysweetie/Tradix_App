import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppRoutes {
  static const home = '/home';
  static const markets = '/markets';
  static const portfolio = '/portfolio';
  static const buyPro = '/buy-pro';
  static const profile = '/profile';
  static const signIn = '/sign-in';
}

class TradixThemeController {
  TradixThemeController._();

  static final ValueNotifier<bool> darkMode = ValueNotifier<bool>(false);

  static bool get isDark => darkMode.value;

  static void setDarkMode(bool value) {
    if (darkMode.value == value) return;
    darkMode.value = value;
  }

  static void toggle() {
    darkMode.value = !darkMode.value;
  }

  static Color blend(Color light, Color dark) {
    return isDark ? dark : light;
  }
}

class TradixThemeColors {
  static const darkPageBg = Color(0xFF0B1320);
  static const darkSurface = Color(0xFF111A2B);
  static const darkSurfaceAlt = Color(0xFF182235);
  static const darkCard = Color(0xFF1A2437);
  static const darkCardAlt = Color(0xFF202C41);
  static const darkLine = Color(0xFF2B364B);
  static const darkText = Color(0xFFE8EEF7);
  static const darkMuted = Color(0xFF8D9AAF);
  static const darkBorder = Color(0xFF2A3447);
  static const darkShadow = Color(0x4D000000);
  static const darkTeal = Color(0xFF6FAFB6);
  static const darkTealSoft = Color(0xFF8AC8CC);
  static const darkTealInk = Color(0xFF98DADF);
  static const darkTealPro = Color(0xFF0E1726);
  static const darkGreen = Color(0xFF72E09D);
  static const darkGreenSoft = Color(0xFF18362A);
  static const darkRed = Color(0xFFFF7470);
  static const darkRedSoft = Color(0xFF3B2430);
  static const darkIconBg = Color(0xFF2A3447);
  static const darkIcon = Color(0xFFC7CFDB);
  static const darkTrack = Color(0xFF566175);
}

class TradixColors {
  static const pageBg = Color(0xFFF7F8FA);
  static const white = Color(0xFFFFFFFF);
  static const tealLight = Color(0xFF73BDC7);
  static const teal = Color(0xFF52A8AD);
  static const tealDark = Color(0xFF5A929A);
  static const tealSoft = Color(0xFF8DB9BF);
  static const tealInk = Color(0xFF245D65);
  static const tealPro = Color(0xFF162D31);
  static const dark = Color(0xFF111827);
  static const darkPro = Color(0xFF162431);
  static const muted = Color(0xFF8B949E);
  static const line = Color(0xFFE5E8EC);
  static const green = Color(0xFF49D07D);
  static const greenSoft = Color(0xFFCFF5D9);
  static const red = Color(0xFFE94B42);
  static const redSoft = Color(0xFFFBD6D3);
  static const purple = Color(0xFFC63FE8);
  static const orange = Color(0xFFF5A524);
  static const yellow = Color(0xFFFFC93A);
  static const blue = Color(0xFF4E8CFF);
  static const cardShadow = Color(0x1A000000);
}

Color _blend(Color light, Color dark) => TradixThemeController.blend(light, dark);

class TradixBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const TradixBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_BottomNavItemData>[
      _BottomNavItemData(Icons.home_rounded, 'Home'),
      _BottomNavItemData(Icons.language_rounded, 'Markets'),
      _BottomNavItemData(Icons.folder_open_rounded, 'Portfolio'),
      _BottomNavItemData(Icons.person_rounded, 'Profile'),
    ];

    return Container(
      height: 102,
      decoration: BoxDecoration(
        color: _blend(TradixColors.white, TradixThemeColors.darkSurface),
        boxShadow: [
          BoxShadow(
            color: _blend(TradixColors.cardShadow, TradixThemeColors.darkShadow),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final active = index == currentIndex;

            return Expanded(
              child: InkWell(
                onTap: onTap == null ? null : () => onTap!(index),
                child: _BottomNavItem(
                  icon: item.icon,
                  label: item.label,
                  active: active,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _BottomNavItemData {
  final IconData icon;
  final String label;

  const _BottomNavItemData(this.icon, this.label);
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? _blend(TradixColors.tealInk, TradixThemeColors.darkTealSoft)
        : _blend(const Color(0xFFCDD1D6), TradixThemeColors.darkMuted);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Center(
        child: SizedBox(
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 27, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  height: 1.0,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: _blend(const Color(0xFF232B33), TradixThemeColors.darkMuted),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final List<Widget> children;

  const SectionCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _blend(TradixColors.white, TradixThemeColors.darkCard),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _blend(const Color(0x00000000), TradixThemeColors.darkBorder),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _blend(const Color(0x14000000), TradixThemeColors.darkShadow),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class MenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const MenuRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _blend(
                  const Color(0xFFF2F3F4),
                  TradixThemeColors.darkIconBg,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                icon,
                size: 16,
                color: _blend(const Color(0xFF5B646C), TradixThemeColors.darkIcon),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _blend(TradixColors.dark, TradixThemeColors.darkText),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: _blend(TradixColors.muted, TradixThemeColors.darkMuted),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 22,
              color: _blend(const Color(0xFF9AA3AA), TradixThemeColors.darkMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SwitchRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final iconBg = _blend(
      const Color(0xFFF2F3F4),
      TradixThemeColors.darkIconBg,
    );

    final iconColor = _blend(
      const Color(0xFF5B646C),
      TradixThemeColors.darkIcon,
    );

    final titleColor = _blend(
      TradixColors.dark,
      TradixThemeColors.darkText,
    );

    final subtitleColor = _blend(
      TradixColors.muted,
      TradixThemeColors.darkMuted,
    );

    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: TradixColors.white,
              activeTrackColor: _blend(
                TradixColors.tealDark,
                TradixThemeColors.darkTeal,
              ),
              inactiveThumbColor: _blend(
                const Color(0xFFF9FAFB),
                const Color(0xFFDBE1EA),
              ),
              inactiveTrackColor: _blend(
                const Color(0xFFC7CDD3),
                TradixThemeColors.darkTrack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DividerRow extends StatelessWidget {
  const DividerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: _blend(const Color(0xFFE9ECEF), TradixThemeColors.darkLine),
    );
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const DeleteButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 144,
        height: 36,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: TradixColors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Delete Account',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class CompanyLogo extends StatelessWidget {
  final String symbol;
  final double size;

  const CompanyLogo({
    super.key,
    required this.symbol,
    this.size = 38,
  });

  String? _assetForSymbol(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'AAPL':
        return 'assets/apple.png';
      case 'TSLA':
        return 'assets/tesla.png';
      case 'NVDA':
        return 'assets/nvidia.png';
      case 'AMZN':
        return 'assets/amazon.png';
      case 'MSFT':
        return 'assets/microsoft.png';
      case 'GOOG':
      case 'GOOGL':
        return 'assets/google.png';
      case 'META':
        return 'assets/meta.png';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = _assetForSymbol(symbol);

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.14),
      decoration: BoxDecoration(
        color: _blend(
          const Color(0xFFF3F4F6),
          TradixThemeColors.darkSurfaceAlt,
        ),
        borderRadius: BorderRadius.circular(size * 0.24),
        border: Border.all(
          color: _blend(const Color(0x00000000), TradixThemeColors.darkBorder),
          width: 1,
        ),
      ),
      child: asset != null
          ? Image.asset(
        asset,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _FallbackLogo(symbol: symbol),
      )
          : _FallbackLogo(symbol: symbol),
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  final String symbol;

  const _FallbackLogo({required this.symbol});

  @override
  Widget build(BuildContext context) {
    final label = symbol.isNotEmpty
        ? symbol.substring(0, symbol.length > 2 ? 2 : 1)
        : '?';

    return Center(
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: _blend(TradixColors.dark, TradixThemeColors.darkText),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
      decoration: BoxDecoration(
        color: _blend(TradixColors.teal, TradixThemeColors.darkSurface),
      ),
      child: Column(
        children: [
          Text(
            'Profile and Settings',
            style: TextStyle(
              fontSize: 22,
              color: _blend(Colors.white, TradixThemeColors.darkText),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          TradixInitialsAvatar(
            name: 'New User',
            size: 72,
            backgroundColor: _blend(Colors.white, TradixThemeColors.darkCard),
            borderColor: _blend(
              const Color(0xFFEFEFEF),
              TradixThemeColors.darkBorder,
            ),
            textColor: _blend(TradixColors.tealInk, TradixThemeColors.darkTealInk),
            fontSize: 24,
          ),
          const SizedBox(height: 12),
          Text(
            'Mary Sims',
            style: TextStyle(
              fontSize: 18,
              color: _blend(Colors.white, TradixThemeColors.darkText),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'newuser@email.com',
            style: TextStyle(
              fontSize: 12,
              color: _blend(const Color(0xE6FFFFFF), TradixThemeColors.darkMuted),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class TradixInitialsAvatar extends StatelessWidget {
  final String name;
  final double size;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double fontSize;

  const TradixInitialsAvatar({
    super.key,
    required this.name,
    this.size = 72,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFEFEFEF),
    this.textColor = TradixColors.tealInk,
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name);
    final isDark = TradixThemeController.isDark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: isDark ? TradixColors.tealDark : const Color(0xFFFFFFFF),
            blurRadius: 12,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  String _initials(String value) {
    final clean = value.trim();

    if (clean.isEmpty) return 'NU';

    final parts = clean
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'NU';

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    final first = parts.first[0];
    final last = parts.last[0];
    return (first + last).toUpperCase();
  }
}

class UpgradeButtonOverlap extends StatelessWidget {
  const UpgradeButtonOverlap({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -16),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              BoxShadow(
                color: _blend(
                  const Color(0x25000000),
                  TradixThemeColors.darkShadow,
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _blend(TradixColors.teal, TradixThemeColors.darkTeal),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              elevation: 0,
            ),
            child: const Text(
              'UPGRADE TO PRO',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuyProCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const BuyProCloseButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _blend(TradixColors.tealSoft, TradixThemeColors.darkIconBg),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _blend(
                  const Color(0x15000000),
                  TradixThemeColors.darkShadow,
                ),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Icon(
            Icons.close,
            size: 18,
            color: _blend(Colors.white, TradixThemeColors.darkText),
          ),
        ),
      ),
    );
  }
}

class BuyProIcon extends StatelessWidget {
  const BuyProIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: _blend(Colors.white, TradixThemeColors.darkText),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _blend(
              const Color(0xFFFFFFFF),
              TradixThemeColors.darkText,
            ),
            blurRadius: 18,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Icon(
        Icons.workspace_premium_outlined,
        size: 45,
        color: _blend(TradixColors.tealInk, TradixColors.tealDark),
      ),
    );
  }
}

class UpgradePill extends StatelessWidget {
  const UpgradePill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 7),
      decoration: BoxDecoration(
        color: _blend(Colors.white, TradixThemeColors.darkText),
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
            color: _blend(
              const Color(0xFFFFFFFF),
              TradixThemeColors.darkText,
            ),
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Text(
        'UPGRADE TO PRO',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
          color: _blend(TradixColors.tealInk, TradixColors.tealInk),
        ),
      ),
    );
  }
}

class BuyProTitle extends StatelessWidget {
  const BuyProTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Unlock ',
        style: TextStyle(
          color: _blend(Colors.white, TradixThemeColors.darkText),
          fontWeight: FontWeight.w800,
          fontSize: 24,
          height: 1.15,
        ),
        children: [
          TextSpan(
            text: 'Premium',
            style: TextStyle(
              color: _blend(TradixColors.tealPro, TradixColors.teal),
            ),
          ),
          TextSpan(
            text: '\nTrading Insights',
            style: TextStyle(
              color: _blend(Colors.white, TradixThemeColors.darkText),
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class BuyProSubtitle extends StatelessWidget {
  const BuyProSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        'Get real-time alerts, AI analysis,\nadvanced charts, and unlimited\nportfolio tracking.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          height: 1.25,
          color: _blend(Colors.white, TradixThemeColors.darkText),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class PlanToggle extends StatelessWidget {
  const PlanToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: _blend(TradixColors.tealSoft, TradixColors.tealSoft),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Monthly',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _blend(Colors.white, TradixThemeColors.darkText),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _blend(TradixColors.tealPro, TradixColors.tealPro),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Annual',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _blend(Colors.white, Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: -7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: TradixColors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Save 30%',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProPlanCard extends StatelessWidget {
  const ProPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: _blend(TradixColors.tealSoft, TradixColors.tealSoft),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _blend(const Color(0x00000000), const Color(0x00000000)),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _blend(
              const Color(0x22000000),
              TradixThemeColors.darkShadow,
            ),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'PRO',
                style: TextStyle(
                  fontSize: 16,
                  color: _blend(Colors.white, Colors.white),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '\$99.99',
                style: TextStyle(
                  fontSize: 17,
                  color: _blend(Colors.white, Colors.white),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'per year',
              style: TextStyle(
                fontSize: 10,
                color: _blend(Colors.white, Colors.white),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FeatureRow(text: 'Unlimited watchlist'),
          FeatureRow(text: 'Real-time alerts'),
          FeatureRow(text: 'AI-powered stock analysis'),
          FeatureRow(text: 'Advanced candlestick charts'),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'View more >',
              style: TextStyle(
                fontSize: 9,
                color: _blend(Colors.white70, Colors.white70),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 108,
              height: 32,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blend(TradixColors.tealPro, TradixColors.tealPro),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _blend(TradixColors.tealPro, TradixColors.tealPro),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Buy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureRow extends StatelessWidget {
  final String text;

  const FeatureRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 15,
            color: _blend(Colors.white, TradixThemeColors.darkText),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                color: _blend(Colors.white, TradixThemeColors.darkText),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FreeTrialButton extends StatelessWidget {
  const FreeTrialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 34,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _blend(TradixColors.tealSoft, TradixColors.tealSoft),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Try free 7-days trial',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class DonutPainter extends CustomPainter {
  final bool isDark;

  DonutPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final segments = <_Segment>[
      _Segment(0.35, TradixColors.purple),
      _Segment(0.25, TradixColors.orange),
      _Segment(0.25, TradixColors.yellow),
      _Segment(0.15, TradixColors.blue),
    ];

    const gap = 0.06;
    var start = -math.pi / 2;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..color = isDark
          ? TradixThemeColors.darkSurfaceAlt
          : const Color(0xFFEFF2F4)
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, math.pi * 2, false, bgPaint);

    for (final segment in segments) {
      final sweep = (math.pi * 2) * segment.value - gap;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round
        ..color = segment.color;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += (math.pi * 2) * segment.value;
    }
  }

  @override
  bool shouldRepaint(covariant DonutPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

class _Segment {
  final double value;
  final Color color;

  _Segment(this.value, this.color);
}

class PerformancePainter extends CustomPainter {
  final bool isDark;

  PerformancePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = isDark ? TradixThemeColors.darkTealSoft : const Color(0xFF69B3B8)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          isDark ? const Color(0x556FAFB6) : const Color(0x5569B3B8),
          isDark ? const Color(0x116FAFB6) : const Color(0x1169B3B8),
          isDark ? const Color(0x006FAFB6) : const Color(0x0069B3B8),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final gridPaint = Paint()
      ..color = isDark ? TradixThemeColors.darkLine : const Color(0xFFE6EAED)
      ..strokeWidth = 1;

    for (int i = 0; i < 3; i++) {
      final y = size.height * (i + 1) / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final values = <double>[0.48, 0.66, 0.38, 0.42, 0.58, 0.44, 0.56, 0.40, 0.62, 0.46];
    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height - (values[i] * size.height);
      points.add(Offset(x, y));
    }

    final linePath = _smoothPath(points);
    final fillPath = Path()..addPath(linePath, Offset.zero);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);

    for (final p in points) {
      canvas.drawCircle(
        p,
        4,
        Paint()..color = isDark ? TradixThemeColors.darkSurface : Colors.white,
      );
      canvas.drawCircle(
        p,
        3,
        Paint()
          ..color =
              isDark ? TradixThemeColors.darkTealSoft : const Color(0xFF69B3B8),
      );
    }
  }

  Path _smoothPath(List<Offset> points) {
    if (points.isEmpty) return Path();
    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant PerformancePainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
