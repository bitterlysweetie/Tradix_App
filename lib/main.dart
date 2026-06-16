import 'package:flutter/material.dart';

import 'screens/buy_pro_screen.dart';
import 'screens/home_screen.dart';
import 'screens/markets_screen.dart';
import 'screens/portfolio_screen.dart';
import 'screens/profile_screen.dart';
import 'shared/tradix_shared.dart';

void main() {
  runApp(const TradixApp());
}

class TradixApp extends StatelessWidget {
  const TradixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tradix',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: TradixColors.pageBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TradixColors.teal,
          brightness: Brightness.light,
        ),
      ),
      initialRoute: AppRoutes.portfolio,
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.markets: (_) => const MarketsScreen(),
        AppRoutes.portfolio: (_) => const PortfolioScreen(),
        AppRoutes.buyPro: (_) => const BuyProScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
      },
    );
  }
}