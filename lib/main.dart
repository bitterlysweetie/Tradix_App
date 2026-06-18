import 'package:flutter/material.dart';

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
        switchTheme: SwitchThemeData(
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: TradixColors.pageBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TradixColors.teal,
          brightness: Brightness.light,
        ),
      ),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentIndex = 0;

  final pages = const [
    HomeScreen(),
    MarketsScreen(),
    PortfolioScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: TradixBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}