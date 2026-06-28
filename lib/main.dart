import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/reset_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/markets_screen.dart';
import 'screens/portfolio_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/sign_in_screen.dart';
import 'shared/tradix_shared.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null ||
      supabaseUrl.isEmpty ||
      supabaseAnonKey == null ||
      supabaseAnonKey.isEmpty) {
    throw StateError('Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env');
  }

  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabaseAnonKey,
  );

  runApp(const TradixApp());
}

class TradixApp extends StatelessWidget {
  const TradixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: TradixThemeController.darkMode,
      builder: (context, isDark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TradiX',
          theme: _lightTheme(),
          darkTheme: _darkTheme(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: AuthGate(),
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => AuthGate(),
              settings: settings,
            );
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => AuthGate(),
              settings: settings,
            );
          },
        );
      },
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: TradixColors.pageBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: TradixColors.teal,
        brightness: Brightness.light,
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: TradixThemeColors.darkPageBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: TradixThemeColors.darkTeal,
        brightness: Brightness.dark,
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Supabase.instance.client.auth;

    return StreamBuilder<AuthState>(
      stream: auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = auth.currentSession;
        final event = snapshot.data?.event;

        if (snapshot.connectionState == ConnectionState.waiting &&
            session == null) {
          return const _AuthLoadingScreen();
        }

        if (event == AuthChangeEvent.passwordRecovery) {
          return ResetPasswordScreen();
        }

        if (session != null) {
          return RootScreen();
        }

        return SignInScreen();
      },
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: TradixColors.pageBg,
      body: Center(
        child: CircularProgressIndicator(
          color: TradixColors.teal,
        ),
      ),
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

  final pages = [
    HomeScreen(),
    MarketsScreen(),
    PortfolioScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? TradixThemeColors.darkPageBg : TradixColors.pageBg,
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
