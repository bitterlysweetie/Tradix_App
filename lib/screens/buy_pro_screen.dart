import 'package:flutter/material.dart';
import '../shared/tradix_shared.dart';

class BuyProScreen extends StatelessWidget {
  const BuyProScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? TradixThemeColors.darkPageBg : TradixColors.teal,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const RadialGradient(
                  center: Alignment.center,
                  radius: 1,
                  colors: [
                    Color(0xFF335667),
                    TradixColors.darkPro,
                    Color(0xFF07111F),
                  ],
                  stops: [0, 0.3, 0.6],
                )
              : const RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [TradixColors.tealLight, TradixColors.tealDark],
                  stops: [0.0, 1.0],
                ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 10),
                      ),
                    ),
                    BuyProCloseButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(height: 42),
                    BuyProIcon(),
                    const SizedBox(height: 12),
                    UpgradePill(),
                    const SizedBox(height: 16),
                    BuyProTitle(),
                    const SizedBox(height: 10),
                    BuyProSubtitle(),
                    const SizedBox(height: 20),
                    PlanToggle(),
                    const SizedBox(height: 16),
                    ProPlanCard(),
                    const SizedBox(height: 10),
                    FreeTrialButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
