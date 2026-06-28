import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/currency_service.dart';
import '../services/location_service.dart';
import '../services/marketstack_service.dart';
import '../shared/tradix_shared.dart';
import 'stock_detail_screen.dart';

class MarketsScreen extends StatefulWidget {
  const MarketsScreen({super.key});

  @override
  State<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  final MarketstackService _service = MarketstackService();
  final LocationService _locationService = LocationService();
  final TextEditingController _searchController = TextEditingController();

  String _selectedCurrency = 'USD';
  late Future<Map<String, dynamic>> _future;
  bool _showNews = false;
  String _searchQuery = '';

  List<String> _symbols = const ['AAPL', 'TSLA', 'NVDA', 'AMZN'];
  String? _detectedCountryCode;

  static const Map<String, String> _companyNames = {
    'AAPL': 'Apple Inc.',
    'TSLA': 'Tesla Inc.',
    'NVDA': 'Nvidia Inc.',
    'AMZN': 'Amazon Inc.',
    'SAP': 'SAP SE',
    'DTE.DE': 'Deutsche Telekom AG',
    'ALV.DE': 'Allianz SE',
    'BMW.DE': 'BMW AG',
    'HSBA.L': 'HSBC Holdings',
    'BP.L': 'BP plc',
    'AZN.L': 'AstraZeneca',
    'ULVR.L': 'Unilever',
    'MC.PA': 'LVMH',
    'OR.PA': 'LOréal',
    'SAN.PA': 'Sanofi',
    'TTE.PA': 'TotalEnergies',
    '7203.T': 'Toyota Motor Corp.',
    '6758.T': 'Sony Group Corp.',
    '9984.T': 'SoftBank Group Corp.',
    '9432.T': 'NTT Corp.',
    'RELIANCE.NS': 'Reliance Industries',
    'TCS.NS': 'Tata Consultancy Services',
    'INFY.NS': 'Infosys',
    'HDFCBANK.NS': 'HDFC Bank',
  };

  @override
  void initState() {
    super.initState();
    _future = _resolveSymbolsAndLoad();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _resolveSymbolsAndLoad() async {
    String? countryCode;
    try {
      countryCode = await _locationService
          .getCountryCode()
          .timeout(const Duration(seconds: 12));
    } catch (e) {
      debugPrint('Location error: $e');
      countryCode = null;
    }

    final normalizedCode = countryCode?.toUpperCase();
    debugPrint('Detected country: ${normalizedCode ?? 'unknown'}');

    _detectedCountryCode = normalizedCode;
    _symbols = _symbolsForCountry(normalizedCode);

    return _service.fetchStockData(symbols: _symbols, limit: 100);
  }

  List<String> _symbolsForCountry(String? countryCode) {
    switch (countryCode) {
      case 'DE':
        return const ['SAP', 'DTE.DE', 'ALV.DE', 'BMW.DE'];
      case 'GB':
        return const ['HSBA.L', 'BP.L', 'AZN.L', 'ULVR.L'];
      case 'FR':
        return const ['MC.PA', 'OR.PA', 'SAN.PA', 'TTE.PA'];
      case 'JP':
        return const ['7203.T', '6758.T', '9984.T', '9432.T'];
      case 'IN':
        return const ['RELIANCE.NS', 'TCS.NS', 'INFY.NS', 'HDFCBANK.NS'];
      case 'US':
      default:
        return const ['AAPL', 'TSLA', 'NVDA', 'AMZN'];
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _resolveSymbolsAndLoad();
    });
    await _future;
  }

  String _companyName(String symbol) {
    return _companyNames[symbol.toUpperCase()] ?? symbol;
  }

  void _openStockDetail(String symbol) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StockDetailScreen(
          symbol: symbol,
          name: _companyName(symbol),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _buildRows(List<dynamic> rawData) {
    final latestBySymbol = <String, Map<String, dynamic>>{};

    for (final item in rawData.whereType<Map<String, dynamic>>()) {
      final symbol = item['symbol']?.toString();
      if (symbol == null || symbol.isEmpty) continue;
      latestBySymbol.putIfAbsent(symbol, () => item);
    }

    return _symbols
        .where((symbol) => latestBySymbol.containsKey(symbol))
        .map((symbol) => latestBySymbol[symbol]!)
        .toList();
  }

  List<Map<String, dynamic>> _filterRows(List<Map<String, dynamic>> rows) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return rows;

    return rows.where((stockData) {
      final symbol = stockData['symbol']?.toString() ?? '';
      final companyName = _companyName(symbol);

      return symbol.toLowerCase().contains(query) ||
          companyName.toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildScrollableContent(List<Widget> children) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
        children: children,
      ),
    );
  }

  Widget _buildLoadingState() {
    final isDark = TradixThemeController.isDark;

    return _buildScrollableContent([
      const SizedBox(height: 120),
      Center(
        child: CircularProgressIndicator(
          color: isDark ? TradixThemeColors.darkTeal : TradixColors.teal,
        ),
      ),
    ]);
  }

  Widget _buildErrorState(Object? error) {
    final isDark = TradixThemeController.isDark;

    return _buildScrollableContent([
      const SizedBox(height: 90),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          'Markets loading error:\n$error',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? TradixThemeColors.darkText : TradixColors.dark,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ),
    ]);
  }

  Widget _buildLoadedState(List<Map<String, dynamic>> rows) {
    final filteredRows = _filterRows(rows);
    final isDark = TradixThemeController.isDark;
    final titleColor = isDark ? TradixThemeColors.darkText : TradixColors.dark;
    final subtitleColor =
    isDark ? TradixThemeColors.darkMuted : const Color(0xFF8A8F98);

    return _buildScrollableContent([
      Center(
        child: Text(
          'Markets and News',
          style: GoogleFonts.instrumentSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
      ),
      if (_detectedCountryCode != null) ...[
        const SizedBox(height: 4),
        Center(
          child: Text(
            'Showing markets for $_detectedCountryCode',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
          ),
        ),
      ],
      const SizedBox(height: 20),
      _SearchBar(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        onClear: () {
          setState(() {
            _searchQuery = '';
            _searchController.clear();
          });
        },
      ),
      const SizedBox(height: 12),
      _CurrencySelector(
        selectedCurrency: _selectedCurrency,
        onChanged: (currency) {
          setState(() {
            _selectedCurrency = currency;
          });
        },
      ),
      const SizedBox(height: 20),
      _ModeTabs(
        showNews: _showNews,
        onStocks: () => setState(() => _showNews = false),
        onNews: () => setState(() => _showNews = true),
      ),
      const SizedBox(height: 18),
      if (_showNews)
        _NewsList(query: _searchQuery)
      else if (filteredRows.isEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Center(
            child: Text(
              _searchQuery.trim().isEmpty
                  ? 'No market data available for your region yet.'
                  : 'No stocks found for "$_searchQuery".',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? TradixThemeColors.darkMuted
                    : const Color(0xFF8A8F98),
              ),
            ),
          ),
        )
      else
        ...filteredRows.map((stockData) {
          final symbol = stockData['symbol']?.toString() ?? '';

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _MarketCard(
              stockData: stockData,
              companyName: _companyName(symbol),
              currencyCode: _selectedCurrency,
              onTap: () => _openStockDetail(symbol),
            ),
          );
        }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? TradixThemeColors.darkPageBg : TradixColors.pageBg,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error);
            }

            final rawData = snapshot.data?['data'] as List<dynamic>? ?? [];
            final rows = _buildRows(rawData);

            return _buildLoadedState(rows);
          },
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;
    final bg = isDark ? TradixThemeColors.darkSurfaceAlt : TradixColors.tealDark;
    final textColor =
    isDark ? TradixThemeColors.darkText : Colors.white.withValues(alpha: 0.96);
    final hintColor =
    isDark ? TradixThemeColors.darkMuted : Colors.white.withValues(alpha: 0.78);

    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 18, color: hintColor),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: textColor,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search stocks, news or ETFs...',
                hintStyle: TextStyle(
                  color: hintColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.close, size: 16, color: hintColor),
              ),
            ),
        ],
      ),
    );
  }
}

class _ModeTabs extends StatelessWidget {
  final bool showNews;
  final VoidCallback onStocks;
  final VoidCallback onNews;

  const _ModeTabs({
    required this.showNews,
    required this.onStocks,
    required this.onNews,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;
    final bg =
    isDark ? TradixThemeColors.darkSurfaceAlt : const Color(0xFFE9E9ED);

    return Container(
      height: 62,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeTabButton(
              label: 'Stocks',
              icon: Icons.trending_up,
              active: !showNews,
              onTap: onStocks,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _ModeTabButton(
              label: 'News',
              icon: Icons.newspaper,
              active: showNews,
              onTap: onNews,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _ModeTabButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;
    final activeBg =
    isDark ? TradixThemeColors.darkPageBg : TradixColors.tealDark;
    final inactiveText =
    isDark ? TradixThemeColors.darkMuted : const Color(0xFF666A70);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: active ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: active
                ? const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 6,
                offset: Offset(0, 0),
              ),
            ]
                : null,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: active ? Colors.white : inactiveText,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: active ? Colors.white : inactiveText,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MarketCard extends StatelessWidget {
  final Map<String, dynamic> stockData;
  final String companyName;
  final VoidCallback? onTap;
  final String currencyCode;

  const _MarketCard({
    required this.stockData,
    required this.companyName,
    required this.currencyCode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;
    final symbol = stockData['symbol']?.toString() ?? '';
    final close = (stockData['close'] as num?)?.toDouble() ?? 0.0;
    final open = (stockData['open'] as num?)?.toDouble() ?? 0.0;

    final changePercent = open == 0 ? 0.0 : ((close - open) / open) * 100;
    final positive = changePercent >= 0;

    final badgeBg = positive
        ? (isDark
        ? TradixThemeColors.darkGreenSoft
        : const Color(0xFFD7F5E0))
        : (isDark ? TradixThemeColors.darkRedSoft : const Color(0xFFFADBDC));
    final badgeText = positive
        ? (isDark ? TradixThemeColors.darkGreen : const Color(0xFF1B9C5C))
        : (isDark ? TradixThemeColors.darkRed : const Color(0xFFD23B3F));

    final cardBg = isDark ? TradixThemeColors.darkSurface : Colors.white;
    final textColor = isDark ? TradixThemeColors.darkText : Colors.black;
    final subtitleColor =
    isDark ? TradixThemeColors.darkMuted : const Color(0xFF8A8F98);
    final logoBg =
    isDark ? TradixThemeColors.darkSurfaceAlt : const Color(0xFFF1F2F5);
    final chevronColor =
    isDark ? TradixThemeColors.darkMuted : const Color(0xFFB9BDC6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: logoBg,
                borderRadius: BorderRadius.circular(21),
              ),
              child: Center(
                child: _MarketLogo(
                  symbol: symbol,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    companyName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyService.formatPrice(close, currencyCode),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${positive ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: badgeText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: chevronColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketLogo extends StatelessWidget {
  final String symbol;
  final double size;

  const _MarketLogo({
    required this.symbol,
    this.size = 30,
  });

  static const Map<String, String> _assets = {
    'AAPL': 'assets/apple.png',
    'TSLA': 'assets/tesla.png',
    'NVDA': 'assets/nvidia.png',
    'AMZN': 'assets/amazon.png',
  };

  @override
  Widget build(BuildContext context) {
    final asset = _assets[symbol.toUpperCase()];

    if (asset != null) {
      return Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _MarketLogoFallback(
          symbol: symbol,
          size: size,
        ),
      );
    }

    return _MarketLogoFallback(
      symbol: symbol,
      size: size,
    );
  }
}

class _MarketLogoFallback extends StatelessWidget {
  final String symbol;
  final double size;

  const _MarketLogoFallback({
    required this.symbol,
    required this.size,
  });

  String _initials(String value) {
    final clean = value.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    if (clean.isEmpty) return '?';
    if (clean.length == 1) return clean.toUpperCase();
    return clean.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;

    return Center(
      child: Text(
        _initials(symbol),
        style: TextStyle(
          fontSize: size * 0.34,
          fontWeight: FontWeight.w800,
          color: isDark ? TradixThemeColors.darkText : TradixColors.dark,
        ),
      ),
    );
  }
}

class _NewsList extends StatelessWidget {
  final String query;

  const _NewsList({
    this.query = '',
  });

  static const _news = [
    _NewsItem(
      title: 'Apple releases new product lineup',
      subtitle:
      'Apple announced its latest product lineup with innovative features.',
      time: '2 hours ago',
      imageUrl:
      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=200',
    ),
    _NewsItem(
      title: 'Q2 Earnings Beat Expectations Despite Market Headwinds',
      subtitle: 'Apple reported stronger than expected earnings.',
      time: '5 hours ago',
      imageUrl:
      'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=200',
    ),
    _NewsItem(
      title: 'Analysts Raise Price Target Following Product Launch',
      subtitle: 'Major investment firms increased their outlook.',
      time: '1 day ago',
      imageUrl:
      'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200',
    ),
    _NewsItem(
      title: 'Q2 Earnings Beat Expectations Despite Market Headwinds',
      subtitle: 'Apple reported stronger than expected earnings.',
      time: '5 hours ago',
      imageUrl:
      'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=200',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final q = query.trim().toLowerCase();
    final filtered = _news.where((item) {
      if (q.isEmpty) return true;
      return item.title.toLowerCase().contains(q) ||
          item.subtitle.toLowerCase().contains(q) ||
          item.time.toLowerCase().contains(q);
    }).toList();

    if (filtered.isEmpty) {
      final isDark = TradixThemeController.isDark;

      return Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Center(
          child: Text(
            'No news found.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? TradixThemeColors.darkMuted
                  : const Color(0xFF8A8F98),
            ),
          ),
        ),
      );
    }

    return Column(
      children: filtered
          .map(
            (item) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _NewsCard(item: item),
        ),
      )
          .toList(),
    );
  }
}

class _NewsItem {
  final String title;
  final String subtitle;
  final String time;
  final String imageUrl;

  const _NewsItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.imageUrl,
  });
}

class _NewsCard extends StatelessWidget {
  final _NewsItem item;

  const _NewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;
    final cardBg =
    isDark ? TradixThemeColors.darkSurface : TradixColors.tealDark;
    final titleColor = isDark ? TradixThemeColors.darkText : Colors.white;
    final bodyColor =
    isDark ? TradixThemeColors.darkMuted : const Color(0xE0FFFFFF);

    return Container(
      height: 106,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.imageUrl,
              width: 78,
              height: 78,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 78,
                height: 78,
                color: const Color(0xFF4D7F87),
                child: const Icon(
                  Icons.newspaper,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: bodyColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.time,
                    style: TextStyle(
                      color: bodyColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencySelector extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String> onChanged;

  const _CurrencySelector({
    required this.selectedCurrency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const currencies = ['USD', 'EUR', 'GBP', 'JPY', 'KZT'];
    final isDark = TradixThemeController.isDark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: currencies.map((code) {
                final active = code == selectedCurrency;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () => onChanged(code),
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 42,
                        minHeight: 24,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: active
                            ? (isDark
                            ? TradixThemeColors.darkTeal
                            : TradixColors.tealDark)
                            : (isDark
                            ? TradixThemeColors.darkSurfaceAlt
                            : Colors.white),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: active
                              ? (isDark
                              ? TradixThemeColors.darkTeal
                              : TradixColors.tealDark)
                              : (isDark
                              ? TradixThemeColors.darkBorder
                              : TradixColors.line),
                        ),
                      ),
                      child: Text(
                        code,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: active
                              ? Colors.white
                              : (isDark
                              ? TradixThemeColors.darkMuted
                              : const Color(0xFF6F7780)),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
