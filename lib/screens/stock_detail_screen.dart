import 'package:flutter/material.dart';
import '../services/marketstack_service.dart';
import '../shared/tradix_shared.dart';

class StockDetailScreen extends StatefulWidget {
  final String symbol;
  final String name;

  const StockDetailScreen({
    super.key,
    required this.symbol,
    required this.name,
  });

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  final MarketstackService _service = MarketstackService();

  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchStockHistory(symbol: widget.symbol, limit: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TradixColors.pageBg,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _future,
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
                    'Stock loading error:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final rawData = snapshot.data?['data'] as List<dynamic>? ?? [];

            final candles = rawData
                .whereType<Map<String, dynamic>>()
                .map((item) {
              final open = (item['open'] as num?)?.toDouble();
              final high = (item['high'] as num?)?.toDouble();
              final low = (item['low'] as num?)?.toDouble();
              final close = (item['close'] as num?)?.toDouble();
              final volume = (item['volume'] as num?)?.toDouble();

              if (open == null ||
                  high == null ||
                  low == null ||
                  close == null) {
                return null;
              }

              return DetailCandleData(
                open: open,
                high: high,
                low: low,
                close: close,
                volume: volume ?? 0,
              );
            })
                .whereType<DetailCandleData>()
                .toList()
                .reversed
                .toList();

            final latest = candles.isNotEmpty ? candles.last : null;
            final first = candles.isNotEmpty ? candles.first : null;

            final price = latest?.close ?? 0;
            final open = latest?.open ?? 0;
            final close = latest?.close ?? 0;
            final volume = latest?.volume ?? 0;
            final high52 = candles.isEmpty
                ? 0.0
                : candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);
            final changePercent = open == 0 ? 0.0 : ((close - open) / open) * 100;
            final isPositive = changePercent >= 0;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            widget.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: TradixColors.dark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.symbol,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: TradixColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const ProfileAvatarSmall(),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: TradixColors.dark,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: _ChangeBadge(
                    value: '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
                    positive: isPositive,
                  ),
                ),
                const SizedBox(height: 10),
                const _RangeTabs(),
                const SizedBox(height: 18),
                Container(
                  height: 210,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4F4),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: candles.isEmpty
                      ? const Center(child: Text('No chart data'))
                      : DetailCandlestickChart(candles: candles),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TradeButton(label: 'Sell', color: TradixColors.tealSoft),
                    const SizedBox(width: 20),
                    _TradeButton(label: 'Buy', color: TradixColors.tealInk),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Statistics',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: TradixColors.dark,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: TradixColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: TradixColors.line),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _StatItem(label: 'Open', value: '\$${open.toStringAsFixed(2)}')),
                          Expanded(child: _StatItem(label: 'Volume', value: _formatVolume(volume))),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: _StatItem(label: 'Close', value: '\$${close.toStringAsFixed(2)}')),
                          Expanded(child: _StatItem(label: '30D High', value: '\$${high52.toStringAsFixed(2)}')),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: _StatItem(label: 'First Close', value: '\$${(first?.close ?? 0).toStringAsFixed(2)}')),
                          Expanded(child: _StatItem(label: 'P/E Ratio', value: 'N/A')),
                        ],
                      ),
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

  String _formatVolume(double value) {
    if (value >= 1000000000) return '${(value / 1000000000).toStringAsFixed(1)}B';
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }
}

class DetailCandleData {
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  DetailCandleData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
}

class DetailCandlestickChart extends StatelessWidget {
  final List<DetailCandleData> candles;

  const DetailCandlestickChart({
    super.key,
    required this.candles,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DetailCandlestickPainter(candles),
      child: const SizedBox.expand(),
    );
  }
}

class DetailCandlestickPainter extends CustomPainter {
  final List<DetailCandleData> candles;

  DetailCandlestickPainter(this.candles);

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    const leftPadding = 40.0;
    const bottomPadding = 28.0;
    const topPadding = 10.0;

    final chartWidth = size.width - leftPadding - 4;
    final chartHeight = size.height - topPadding - bottomPadding;

    final maxPrice = candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    final minPrice = candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    final range = maxPrice - minPrice == 0 ? 1 : maxPrice - minPrice;

    double priceToY(double price) {
      return topPadding + ((maxPrice - price) / range) * chartHeight;
    }

    final gridPaint = Paint()
      ..color = const Color(0xFFD5E4E4)
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i <= 3; i++) {
      final y = topPadding + chartHeight * i / 3;
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width, y), gridPaint);

      final labelPrice = maxPrice - range * i / 3;
      textPainter.text = TextSpan(
        text: labelPrice.toStringAsFixed(2),
        style: const TextStyle(fontSize: 9, color: Color(0xFF6B7280)),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    final candleWidth = chartWidth / candles.length;
    final bodyWidth = candleWidth * 0.45;

    for (int i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = leftPadding + candleWidth * i + candleWidth / 2;

      final openY = priceToY(c.open);
      final closeY = priceToY(c.close);
      final highY = priceToY(c.high);
      final lowY = priceToY(c.low);

      final isUp = c.close >= c.open;
      final paint = Paint()
        ..color = isUp ? const Color(0xFF12C76F) : const Color(0xFFFF3B4D)
        ..strokeWidth = 1.2;

      canvas.drawLine(Offset(x, highY), Offset(x, lowY), paint);

      final top = openY < closeY ? openY : closeY;
      final bottom = openY > closeY ? openY : closeY;

      canvas.drawRect(
        Rect.fromLTRB(
          x - bodyWidth / 2,
          top,
          x + bodyWidth / 2,
          bottom < top + 2 ? top + 2 : bottom,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DetailCandlestickPainter oldDelegate) {
    return oldDelegate.candles != candles;
  }
}

class _ChangeBadge extends StatelessWidget {
  final String value;
  final bool positive;

  const _ChangeBadge({
    required this.value,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: positive ? TradixColors.greenSoft : TradixColors.redSoft,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: positive ? TradixColors.green : TradixColors.red,
        ),
      ),
    );
  }
}

class _RangeTabs extends StatelessWidget {
  const _RangeTabs();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RangeTab(label: '1D', active: true),
        _RangeTab(label: '1W'),
        _RangeTab(label: '1M'),
        _RangeTab(label: '1Y'),
      ],
    );
  }
}

class _RangeTab extends StatelessWidget {
  final String label;
  final bool active;

  const _RangeTab({
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: active ? TradixColors.tealInk : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: active ? Colors.white : TradixColors.tealInk,
        ),
      ),
    );
  }
}

class _TradeButton extends StatelessWidget {
  final String label;
  final Color color;

  const _TradeButton({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 86,
      height: 38,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: TradixColors.muted)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class ProfileAvatarSmall extends StatelessWidget {
  const ProfileAvatarSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFEFF4F4),
        border: Border.all(color: TradixColors.tealDark, width: 2),
      ),
      alignment: Alignment.center,
      child: const Text(
        'MS',
        style: TextStyle(
          color: TradixColors.tealInk,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}