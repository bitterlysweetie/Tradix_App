import 'dart:math' as math;
import 'package:flutter/material.dart';


class AppRoutes {
  static const home = '/home';
  static const markets = '/markets';
  static const portfolio = '/portfolio';
  static const buyPro = '/buy-pro';
  static const profile = '/profile';
}

class TradixColors {
  static const pageBg = Color(0xFFF7F8FA);
  static const white = Color(0xFFFFFFFF);
  static const teal = Color(0xFF6AA3AB);
  static const tealDark = Color(0xFF446B73);
  static const tealSoft = Color(0xFF8DB9BF);
  static const tealInk = Color(0xFF2D5A61);
  static const dark = Color(0xFF111827);
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

class TradixBottomBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int index)? onTap;

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
      decoration: const BoxDecoration(
        color: TradixColors.white,
        boxShadow: [
          BoxShadow(
            color: TradixColors.cardShadow,
            blurRadius: 16,
            offset: Offset(0, -4),
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
                onTap: () {
                  if (onTap != null) {
                    onTap!(index);
                    return;
                  }

                  final route = switch (index) {
                    0 => AppRoutes.home,
                    1 => AppRoutes.markets,
                    2 => AppRoutes.portfolio,
                    3 => AppRoutes.profile,
                    _ => AppRoutes.portfolio,
                  };

                  if (route != _routeForIndex(currentIndex)) {
                    Navigator.of(context).pushNamedAndRemoveUntil(route, (r) => false);
                  }
                },
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

String _routeForIndex(int index) {
  return switch (index) {
    0 => AppRoutes.home,
    1 => AppRoutes.markets,
    2 => AppRoutes.portfolio,
    3 => AppRoutes.profile,
    _ => AppRoutes.portfolio,
  };
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
    final color = active ? TradixColors.tealInk : const Color(0xFFCDD1D6);

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
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Color(0xFF232B33),
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
        color: TradixColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
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
                color: const Color(0xFFF2F3F4),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(icon, size: 16, color: const Color(0xFF5B646C)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: TradixColors.dark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: TradixColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 22, color: Color(0xFF9AA3AA)),
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

  const SwitchRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
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
                color: const Color(0xFFF2F3F4),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(icon, size: 16, color: const Color(0xFF5B646C)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: TradixColors.dark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: TradixColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: (_) {},
              activeColor: TradixColors.teal,
              activeTrackColor: TradixColors.tealSoft,
              inactiveThumbColor: const Color(0xFFF9FAFB),
              inactiveTrackColor: const Color(0xFFC7CDD3),
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
    return const Divider(height: 1, thickness: 1, color: Color(0xFFE9ECEF));
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 144,
        height: 36,
        child: ElevatedButton(
          onPressed: () {},
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

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
      decoration: const BoxDecoration(color: TradixColors.teal),
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
          ProfileAvatar(),
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
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

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
            boxShadow: const [
              BoxShadow(
                color: Color(0x25000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: TradixColors.teal,
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
            color: const Color(0x80FFFFFF),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x15000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.close, size: 18, color: Colors.white),
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
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2A000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.workspace_premium_outlined,
        size: 34,
        color: TradixColors.tealInk,
      ),
    );
  }
}

class UpgradePill extends StatelessWidget {
  const UpgradePill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Text(
        'UPGRADE TO PRO',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
          color: TradixColors.tealInk,
        ),
      ),
    );
  }
}

class BuyProTitle extends StatelessWidget {
  const BuyProTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        text: 'Unlock ',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 24,
          height: 1.15,
        ),
        children: [
          TextSpan(
            text: 'Premium',
            style: TextStyle(color: TradixColors.tealInk),
          ),
          TextSpan(text: '\nTrading Insights'),
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
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        'Get real-time alerts, AI analysis,\nadvanced charts, and unlimited\nportfolio tracking.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          height: 1.25,
          color: Colors.white,
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
              color: const Color(0x5CFFFFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Monthly',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: TradixColors.tealInk,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Annual',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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
        color: const Color(0x88C7E2E7),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                'PRO',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Text(
                '\$99.99',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'per year',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const FeatureRow(text: 'Unlimited watchlist'),
          const FeatureRow(text: 'Real-time alerts'),
          const FeatureRow(text: 'AI-powered stock analysis'),
          const FeatureRow(text: 'Advanced candlestick charts'),
          const SizedBox(height: 4),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'View more >',
              style: TextStyle(
                fontSize: 9,
                color: Colors.white70,
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
                  backgroundColor: TradixColors.tealInk,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: TradixColors.tealInk,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Buy',
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
          const Icon(
            Icons.check_circle_outline,
            size: 15,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
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
          backgroundColor: const Color(0x88B7D4DA),
          foregroundColor: Colors.white,
          elevation: 2,
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
  const DonutPainter();

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
      ..color = const Color(0xFFEFF2F4)
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Segment {
  final double value;
  final Color color;

  _Segment(this.value, this.color);
}

class PerformancePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF69B3B8)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x5569B3B8),
          Color(0x1169B3B8),
          Color(0x0069B3B8),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final gridPaint = Paint()
      ..color = const Color(0xFFE6EAED)
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
        2.8,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        p,
        1.8,
        Paint()..color = const Color(0xFF69B3B8),
      );
    }
  }

  Path _smoothPath(List<Offset> points) {
    if (points.isEmpty) return Path();
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final mid = Offset((current.dx + next.dx) / 2, (current.dy + next.dy) / 2);
      path.quadraticBezierTo(current.dx, current.dy, mid.dx, mid.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}