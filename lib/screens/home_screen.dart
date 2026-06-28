import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/marketstack_service.dart';
import '../services/profile_name_service.dart';
import '../shared/tradix_shared.dart';
import 'stock_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MarketstackService _apiService = MarketstackService();
  late Future<String> _displayNameFuture;
  late Future<Map<String, dynamic>> _dynamicMarketDataFuture;
  List<String> _loadedSymbols = [];

  @override
  void initState() {
    super.initState();
    _dynamicMarketDataFuture = _loadDynamicData();
    _displayNameFuture = ProfileNameService.loadDisplayName();
  }

  Future<Map<String, dynamic>> _loadDynamicData() async {
    _loadedSymbols = await _apiService.fetchActiveTickers(limit: 5);

    if (_loadedSymbols.isEmpty) {
      throw Exception('Marketstack returned an empty ticker list.');
    }

    return await _apiService.fetchStockData(symbols: _loadedSymbols);
  }

  String _companyName(String symbol) {
    const names = {
      'AAPL': 'Apple Inc.',
      'TSLA': 'Tesla Inc.',
      'NVDA': 'Nvidia Inc.',
      'AMZN': 'Amazon Inc.',
      'MSFT': 'Microsoft Corp.',
      'GOOGL': 'Alphabet Inc.',
      'META': 'Meta Platforms Inc.',
    };

    return names[symbol] ?? symbol;
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBg = isDark ? TradixThemeColors.darkPageBg : TradixColors.pageBg;
    final textColor = isDark ? TradixThemeColors.darkText : TradixColors.dark;
    final headerBg = isDark ? TradixColors.dark : TradixColors.tealDark;
    final headerTextColor = isDark ? TradixThemeColors.darkText : Colors.white;
    final chipBg = isDark
        ? TradixThemeColors.darkGreen
        : const Color(0xFF8AF0A4);
    final chipBorder = isDark
        ? TradixThemeColors.darkGreenSoft
        : const Color(0xFF35B86B);
    final chipText = isDark
        ? TradixThemeColors.darkGreenSoft
        : const Color(0xFF176B38);
    final chipIcon = isDark
        ? TradixThemeColors.darkGreenSoft
        : const Color(0xFF159447);

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dynamicMarketDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: isDark
                      ? TradixThemeColors.darkTealSoft
                      : TradixColors.tealDark,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    'Market loading error:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor),
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'No market data available',
                  style: TextStyle(color: textColor),
                ),
              );
            }

            final List<dynamic> rawData = snapshot.data!['data'] ?? [];
            final Map<String, List<dynamic>> groupedData = {};

            for (final symbol in _loadedSymbols) {
              groupedData[symbol] = rawData.where((item) {
                if (item is! Map<String, dynamic>) return false;
                return item['symbol'] == symbol;
              }).toList();
            }

            List<CandleData> candles = [];

            if (_loadedSymbols.isNotEmpty &&
                groupedData[_loadedSymbols.first] != null &&
                groupedData[_loadedSymbols.first]!.isNotEmpty) {
              candles = groupedData[_loadedSymbols.first]!
                  .reversed
                  .map<CandleData?>((item) {
                if (item is! Map<String, dynamic>) return null;

                final open = (item['open'] as num?)?.toDouble();
                final high = (item['high'] as num?)?.toDouble();
                final low = (item['low'] as num?)?.toDouble();
                final close = (item['close'] as num?)?.toDouble();

                if (open == null ||
                    high == null ||
                    low == null ||
                    close == null) {
                  return null;
                }

                return CandleData(
                  open: open,
                  high: high,
                  low: low,
                  close: close,
                );
              }).whereType<CandleData>().toList();
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 96),
              children: [
                _buildPortfolioCard(
                  headerBg: headerBg,
                  headerTextColor: headerTextColor,
                  chipBg: chipBg,
                  chipBorder: chipBorder,
                  chipText: chipText,
                  chipIcon: chipIcon,
                  textColor: textColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Portfolio performance',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildChartSection(candles, isDark: isDark),
                      const SizedBox(height: 20),
                      _buildDynamicWatchlist(groupedData, isDark: isDark),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortfolioCard({
    required Color headerBg,
    required Color headerTextColor,
    required Color chipBg,
    required Color chipBorder,
    required Color chipText,
    required Color chipIcon,
    required Color textColor,
  }) {
    final isDark = TradixThemeController.isDark;
    final avatarBg = isDark
        ? TradixColors.tealDark
        : const Color(0xFFEFF4F4);
    final avatarBorder = isDark
        ? TradixThemeColors.darkBorder
        : TradixColors.white;
    final subText = isDark ? TradixThemeColors.darkText : const Color(0xFFE8F3F3);

    return SizedBox(
      height: 248,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 34),
            decoration: BoxDecoration(
              color: headerBg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Home',
                    style: GoogleFonts.instrumentSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: headerTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<String>(
                      future: _displayNameFuture,
                      builder: (context, snapshot) {
                        final name = snapshot.data ?? 'New User';

                        return Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome,',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: headerTextColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    FutureBuilder<String>(
                      future: _displayNameFuture,
                      builder: (context, snapshot) {
                        final name = snapshot.data ?? 'New User';

                        return TradixInitialsAvatar(
                          name: name,
                          size: 44,
                          backgroundColor: avatarBg,
                          borderColor: avatarBorder,
                          textColor: isDark
                              ? TradixColors.tealPro
                              : TradixColors.tealInk,
                          fontSize: 16,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Total portfolio value:',
                    style: TextStyle(
                      fontSize: 13,
                      color: headerTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    '\$17,826',
                    style: TextStyle(
                      fontSize: 28,
                      color: headerTextColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: chipBorder,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      size: 14,
                      color: chipIcon,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+\$319.16 (+1.6%) today',
                      style: TextStyle(
                        fontSize: 12,
                        color: chipText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(List<CandleData> candles, {required bool isDark}) {
    final bg = isDark ? TradixThemeColors.darkSurface : Colors.white;
    final border = isDark ? TradixThemeColors.darkBorder : Colors.transparent;

    return Container(
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: isDark ? Border.all(color: border) : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: candles.isEmpty
          ? Center(
        child: Text(
          'No chart data',
          style: TextStyle(
            color: isDark
                ? TradixThemeColors.darkText
                : TradixColors.dark,
          ),
        ),
      )
          : CandlestickChart(
              candles: candles,
              isDark: isDark,
            ),
    );
  }

  Widget _buildDynamicWatchlist(
      Map<String, List<dynamic>> groupedData, {
        required bool isDark,
      }) {
    final titleColor = isDark ? TradixThemeColors.darkText : TradixColors.dark;
    final linkColor = isDark
        ? TradixThemeColors.darkTealSoft
        : TradixColors.teal;
    final cardBg = isDark ? TradixThemeColors.darkSurface : Colors.white;
    final cardBorder = isDark ? TradixThemeColors.darkBorder : Colors.transparent;
    final subtitleColor =
    isDark ? TradixThemeColors.darkMuted : Colors.grey;
    final chevronColor = isDark
        ? TradixThemeColors.darkMuted
        : const Color(0xFF9CA3AF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Watchlist',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
            Text(
              'View all >',
              style: TextStyle(
                fontSize: 12,
                color: linkColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._loadedSymbols.map((symbol) {
          final history = groupedData[symbol] ?? [];
          final latestData = history.isNotEmpty ? history.first : null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildStockTile(
              symbol,
              latestData,
              isDark: isDark,
              cardBg: cardBg,
              cardBorder: cardBorder,
              subtitleColor: subtitleColor,
              chevronColor: chevronColor,
              onTap: () => _openStockDetail(symbol),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStockTile(
      String symbol,
      dynamic stockData, {
        required bool isDark,
        required Color cardBg,
        required Color cardBorder,
        required Color subtitleColor,
        required Color chevronColor,
        VoidCallback? onTap,
      }) {
    String priceText = '\$0.00';
    String changeText = '0.00%';
    bool isPositive = true;

    if (stockData is Map<String, dynamic>) {
      final double close = (stockData['close'] as num?)?.toDouble() ?? 0.0;
      final double open = (stockData['open'] as num?)?.toDouble() ?? 0.0;

      final double changePrice = close - open;
      final double changePercent = open != 0 ? (changePrice / open) * 100 : 0.0;

      priceText = '\$${close.toStringAsFixed(2)}';
      isPositive = changePercent >= 0;
      changeText = '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%';
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(8),
          border: isDark ? Border.all(color: cardBorder) : null,
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CompanyLogo(
              symbol: symbol,
              size: 38,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? TradixThemeColors.darkText
                          : TradixColors.dark,
                    ),
                  ),
                  Text(
                    _companyName(symbol),
                    style: TextStyle(
                      fontSize: 12,
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
                  priceText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? TradixThemeColors.darkText
                        : TradixColors.dark,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? (isDark
                        ? TradixThemeColors.darkGreenSoft
                        : const Color(0xFFE8F5E9))
                        : (isDark
                        ? TradixThemeColors.darkRedSoft
                        : const Color(0xFFFFEBEE)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    changeText,
                    style: TextStyle(
                      fontSize: 11,
                      color: isPositive
                          ? (isDark
                          ? TradixThemeColors.darkGreen
                          : Colors.green)
                          : (isDark
                          ? TradixThemeColors.darkRed
                          : Colors.red),
                      fontWeight: FontWeight.bold,
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

class CandleData {
  final double open;
  final double high;
  final double low;
  final double close;

  CandleData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}

class CandlestickChart extends StatelessWidget {
  final List<CandleData> candles;
  final bool isDark;

  const CandlestickChart({
    super.key,
    required this.candles,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CandlestickPainter(candles, isDark),
      child: const SizedBox.expand(),
    );
  }
}

class CandlestickPainter extends CustomPainter {
  final List<CandleData> candles;
  final bool isDark;

  CandlestickPainter(this.candles, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final gridPaint = Paint()
      ..color = isDark ? TradixThemeColors.darkLine : const Color(0xFFE5E7EB)
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    const rightPadding = 48.0;
    const bottomPadding = 18.0;
    const topPadding = 10.0;

    final chartWidth = size.width - rightPadding;
    final chartHeight = size.height - bottomPadding - topPadding;

    final maxPrice = candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    final minPrice = candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    final priceRange = maxPrice - minPrice == 0 ? 1 : maxPrice - minPrice;

    double priceToY(double price) {
      return topPadding + ((maxPrice - price) / priceRange) * chartHeight;
    }

    for (int i = 0; i <= 3; i++) {
      final y = topPadding + chartHeight * i / 3;

      canvas.drawLine(
        Offset(0, y),
        Offset(chartWidth, y),
        gridPaint,
      );

      final price = maxPrice - priceRange * i / 3;

      textPainter.text = TextSpan(
        text: price.toStringAsFixed(2),
        style: TextStyle(
          color: isDark ? TradixThemeColors.darkMuted : const Color(0xFF6B7280),
          fontSize: 9,
        ),
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(chartWidth + 6, y - 6));
    }

    final candleWidth = chartWidth / candles.length;
    final bodyWidth = candleWidth * 0.48;

    for (int i = 0; i < candles.length; i++) {
      final candle = candles[i];

      final x = candleWidth * i + candleWidth / 2;
      final openY = priceToY(candle.open);
      final closeY = priceToY(candle.close);
      final highY = priceToY(candle.high);
      final lowY = priceToY(candle.low);

      final isUp = candle.close >= candle.open;
      final color = isUp
          ? const Color(0xFF12C76F)
          : const Color(0xFFFF3B4D);

      final candlePaint = Paint()
        ..color = color
        ..strokeWidth = 1.3;

      canvas.drawLine(
        Offset(x, highY),
        Offset(x, lowY),
        candlePaint,
      );

      final top = openY < closeY ? openY : closeY;
      final bottom = openY > closeY ? openY : closeY;

      canvas.drawRect(
        Rect.fromLTRB(
          x - bodyWidth / 2,
          top,
          x + bodyWidth / 2,
          bottom < top + 2 ? top + 2 : bottom,
        ),
        candlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CandlestickPainter oldDelegate) {
    return oldDelegate.candles != candles || oldDelegate.isDark != isDark;
  }
}
