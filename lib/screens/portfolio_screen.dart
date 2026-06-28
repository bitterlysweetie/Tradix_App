import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/marketstack_service.dart';
import '../shared/tradix_shared.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBg = isDark ? TradixThemeColors.darkPageBg : TradixColors.pageBg;
    final titleColor = isDark ? TradixThemeColors.darkText : TradixColors.dark;
    final mutedColor = isDark ? TradixThemeColors.darkMuted : TradixColors.muted;

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
          children: [
            const SizedBox(height: 2),
            Center(
              child: Text(
                'My Portfolio',
                style: GoogleFonts.instrumentSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
            ),
            const SizedBox(height: 18),
            PortfolioSummaryCard(),
            const SizedBox(height: 12),
            AssetAllocationCard(),
            const SizedBox(height: 12),
            PerformanceCard(),
            const SizedBox(height: 18),
            Text(
              'Your holdings',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 10),
            PortfolioHoldingsSection(),
            const SizedBox(height: 8),
            Text(
              '',
              style: TextStyle(color: mutedColor),
            ),
          ],
        ),
      ),
    );
  }
}

class PortfolioSummaryCard extends StatelessWidget {
  const PortfolioSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;
    final cardBg = isDark ? TradixThemeColors.darkSurface : TradixColors.tealDark;
    final cardShadow = isDark ? TradixThemeColors.darkShadow : TradixColors.cardShadow;
    final titleColor = isDark ? TradixThemeColors.darkText : Colors.white;
    final chipBg = isDark ? TradixThemeColors.darkGreen : const Color(0xFFA3E9BA);
    final chipBorder = isDark ? TradixThemeColors.darkGreenSoft : const Color(0xFF3CBF65);
    final chipText = isDark ? TradixThemeColors.darkGreenSoft : const Color(0xFF0D4E1F);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: cardShadow,
            blurRadius: 16,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Portfolio Value',
            style: TextStyle(
              fontSize: 12,
              color: titleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$10,835.46',
            style: TextStyle(
              fontSize: 26,
              height: 1,
              color: titleColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: chipBg,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: chipBorder, width: 1),
              ),
              child: Text(
                '▲ +\$319.16 (+1.6%) today',
                style: TextStyle(
                  fontSize: 11,
                  color: chipText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AssetAllocationCard extends StatelessWidget {
  const AssetAllocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;
    final cardBg = isDark ? TradixThemeColors.darkSurface : TradixColors.white;
    final border = isDark ? TradixThemeColors.darkBorder : TradixColors.line;
    final titleColor = isDark ? TradixThemeColors.darkText : TradixColors.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asset Allocation',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: CustomPaint(
                  painter: DonutPainter(isDark: isDark),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: AllocationLegend(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AllocationLegend extends StatelessWidget {
  const AllocationLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LegendRow(color: TradixColors.purple, ticker: 'AAPL', value: '35%'),
        const SizedBox(height: 8),
        LegendRow(color: TradixColors.orange, ticker: 'NVDA', value: '25%'),
        const SizedBox(height: 8),
        LegendRow(color: TradixColors.yellow, ticker: 'TSLA', value: '25%'),
        const SizedBox(height: 8),
        LegendRow(color: TradixColors.blue, ticker: 'MSFT', value: '15%'),
      ],
    );
  }
}

class LegendRow extends StatelessWidget {
  final Color color;
  final String ticker;
  final String value;

  const LegendRow({
    super.key,
    required this.color,
    required this.ticker,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;
    final textColor = isDark ? TradixThemeColors.darkText : TradixColors.dark;

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            ticker,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class PerformanceCard extends StatelessWidget {
  const PerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;
    final cardBg = isDark ? TradixThemeColors.darkSurface : TradixColors.white;
    final border = isDark ? TradixThemeColors.darkBorder : TradixColors.line;
    final titleColor = isDark ? TradixThemeColors.darkText : TradixColors.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance (6 month)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 140,
            child: Stack(
              children: [
                Positioned.fill(
                  left: 26,
                  right: 4,
                  bottom: 18,
                  top: 0,
                  child: CustomPaint(
                    painter: PerformancePainter(isDark: isDark),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YAxisLabel('100'),
                  YAxisLabel('75'),
                  YAxisLabel('50'),
                  YAxisLabel('25'),
                  YAxisLabel('0'),
                ],
              ),
            ),
            Positioned(
              left: 30,
              right: 4,
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  XAxisLabel('Apr 6'),
                  XAxisLabel('Apr 7'),
                  XAxisLabel('Apr 8'),
                  XAxisLabel('Apr 9'),
                  XAxisLabel('Apr 10'),
                  XAxisLabel('Apr 11'),
                  XAxisLabel('Apr 12'),
                ],
              ),
            ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class YAxisLabel extends StatelessWidget {
  final String text;

  const YAxisLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        color: isDark ? TradixThemeColors.darkMuted : const Color(0xFF9AA3AA),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class XAxisLabel extends StatelessWidget {
  final String text;

  const XAxisLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        color: isDark ? TradixThemeColors.darkMuted : const Color(0xFF9AA3AA),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class PortfolioHoldingsSection extends StatefulWidget {
  const PortfolioHoldingsSection({super.key});

  @override
  State<PortfolioHoldingsSection> createState() =>
      _PortfolioHoldingsSectionState();
}

class _PortfolioHoldingsSectionState extends State<PortfolioHoldingsSection> {
  final MarketstackService _service = MarketstackService();
  late Future<List<_HoldingItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadHoldings();
  }

  Future<List<_HoldingItem>> _loadHoldings() async {
    const fakeShares = <String, double>{
      'AAPL': 18,
      'TSLA': 7,
      'NVDA': 12,
      'AMZN': 4,
    };

    final response = await _service.fetchStockData(
      symbols: fakeShares.keys.toList(),
      limit: 30,
    );

    final List<dynamic> rawData = response['data'] ?? [];
    final Map<String, Map<String, dynamic>> latestBySymbol = {};

    for (final item in rawData) {
      if (item is! Map<String, dynamic>) continue;

      final symbol = item['symbol']?.toString() ?? '';
      if (symbol.isEmpty || latestBySymbol.containsKey(symbol)) continue;

      latestBySymbol[symbol] = item;
    }

    final holdings = <_HoldingItem>[];

    for (final entry in fakeShares.entries) {
      final symbol = entry.key;
      final shares = entry.value;
      final item = latestBySymbol[symbol];

      if (item == null) continue;

      final close = (item['close'] as num?)?.toDouble() ?? 0.0;
      final open = (item['open'] as num?)?.toDouble() ?? close;
      final changePercent = open == 0 ? 0.0 : ((close - open) / open) * 100;

      holdings.add(
        _HoldingItem(
          symbol: symbol,
          company: _companyName(symbol),
          shares: shares,
          price: close,
          changePercent: changePercent,
        ),
      );
    }

    holdings.sort((a, b) => b.marketValue.compareTo(a.marketValue));
    return holdings;
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_HoldingItem>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(color: TradixColors.teal),
            ),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Holdings loading error:\n${snapshot.error}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: TradixThemeController.isDark
                    ? TradixThemeColors.darkText
                    : TradixColors.dark,
              ),
            ),
          );
        }

        final holdings = snapshot.data ?? [];

        if (holdings.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'No holdings data available.',
              style: TextStyle(
                fontSize: 12,
                color: TradixThemeController.isDark
                    ? TradixThemeColors.darkMuted
                    : TradixColors.muted,
              ),
            ),
          );
        }

        return Column(
          children: holdings
              .map(
                (holding) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _HoldingCard(holding: holding),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _HoldingItem {
  final String symbol;
  final String company;
  final double shares;
  final double price;
  final double changePercent;

  const _HoldingItem({
    required this.symbol,
    required this.company,
    required this.shares,
    required this.price,
    required this.changePercent,
  });

  double get marketValue => shares * price;
}

class _HoldingCard extends StatelessWidget {
  final _HoldingItem holding;

  const _HoldingCard({required this.holding});

  @override
  Widget build(BuildContext context) {
    final isDark = TradixThemeController.isDark;
    final positive = holding.changePercent >= 0;
    final changeBg = positive
        ? (isDark ? TradixThemeColors.darkGreenSoft : TradixColors.greenSoft)
        : (isDark ? TradixThemeColors.darkRedSoft : TradixColors.redSoft);
    final changeColor = positive
        ? (isDark ? TradixThemeColors.darkGreen : TradixColors.green)
        : (isDark ? TradixThemeColors.darkRed : TradixColors.red);
    final cardBg = isDark ? TradixThemeColors.darkSurface : TradixColors.white;
    final border = isDark ? TradixThemeColors.darkBorder : TradixColors.line;
    final titleColor = isDark ? TradixThemeColors.darkText : TradixColors.dark;
    final subtitleColor = isDark ? TradixThemeColors.darkMuted : TradixColors.muted;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CompanyLogo(
            symbol: holding.symbol,
            size: 38,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding.symbol,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  holding.company,
                  style: TextStyle(
                    fontSize: 11,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${holding.shares.toStringAsFixed(0)} shares',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${holding.marketValue.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: changeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${positive ? '+' : ''}${holding.changePercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: changeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
