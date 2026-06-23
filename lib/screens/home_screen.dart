import 'package:flutter/material.dart';
import '../shared/tradix_shared.dart';
import '../services/marketstack_service.dart';
import 'stock_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MarketstackService _apiService = MarketstackService();

  late Future<Map<String, dynamic>> _dynamicMarketDataFuture;
  List<String> _loadedSymbols = [];

  @override
  void initState() {
    super.initState();
    _dynamicMarketDataFuture = _loadDynamicData();
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
    return Scaffold(
      backgroundColor: TradixColors.pageBg,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dynamicMarketDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: TradixColors.teal),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    'Market loading error:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: TradixColors.dark),
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('No market data available'),
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
              })
                  .whereType<CandleData>()
                  .toList();
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 96),
              children: [
                _buildPortfolioCard(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Portfolio performance',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: TradixColors.dark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildChartSection(candles),
                      const SizedBox(height: 20),
                      _buildDynamicWatchlist(groupedData),
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

  Widget _buildPortfolioCard() {
    return SizedBox(
      height: 250,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 220,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
            decoration: const BoxDecoration(
              color: Color(0xFF5F9EA0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning,',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFE8F3F3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Mary Sims',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEFF4F4),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'MS',
                        style: TextStyle(
                          color: Color(0xFF315F61),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Center(
                  child: Text(
                    'Total portfolio value:',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    '\$17,826',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
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
            bottom: 12,
            child: Center(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8AF0A4),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFF35B86B),
                    width: 1.2,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      size: 14,
                      color: Color(0xFF159447),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '+\$319.16 (+1.6%) today',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF176B38),
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

  Widget _buildChartSection(List<CandleData> candles) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: candles.isEmpty
          ? const Center(child: Text('No chart data'))
          : CandlestickChart(candles: candles),
    );
  }

  Widget _buildDynamicWatchlist(Map<String, List<dynamic>> groupedData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Watchlist',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: TradixColors.dark,
              ),
            ),
            Text(
              'View all >',
              style: TextStyle(
                fontSize: 12,
                color: TradixColors.teal,
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
      changeText =
      '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%';
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: TradixColors.pageBg,
              child: Text(
                symbol.length > 4 ? symbol.substring(0, 4) : symbol,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: TradixColors.dark,
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _companyName(symbol),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    changeText,
                    style: TextStyle(
                      fontSize: 11,
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFF9CA3AF),
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

  const CandlestickChart({
    super.key,
    required this.candles,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CandlestickPainter(candles),
      child: const SizedBox.expand(),
    );
  }
}

class CandlestickPainter extends CustomPainter {
  final List<CandleData> candles;

  CandlestickPainter(this.candles);

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
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
        style: const TextStyle(
          color: Color(0xFF6B7280),
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
      final color = isUp ? const Color(0xFF12C76F) : const Color(0xFFFF3B4D);

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
    return oldDelegate.candles != candles;
  }
}