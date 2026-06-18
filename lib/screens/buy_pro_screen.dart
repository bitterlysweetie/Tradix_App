import 'package:flutter/material.dart';

import '../shared/tradix_shared.dart';

class BuyProScreen extends StatelessWidget {
  const BuyProScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TradixColors.teal,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [TradixColors.tealLight, TradixColors.tealDark],
            stops: [0.1, 0.4]
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
                    const BuyProIcon(),
                    const SizedBox(height: 12),
                    const UpgradePill(),
                    const SizedBox(height: 16),
                    const BuyProTitle(),
                    const SizedBox(height: 10),
                    const BuyProSubtitle(),
                    const SizedBox(height: 20),
                    const PlanToggle(),
                    const SizedBox(height: 16),
                    const ProPlanCard(),
                    const SizedBox(height: 10),
                    const FreeTrialButton(),
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