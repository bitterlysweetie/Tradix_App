import 'package:flutter/material.dart';
import '../shared/tradix_shared.dart';

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TradixColors.pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 96),
          children: [
            const Center(
              child: Text(
                'Markets and News',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: TradixColors.dark,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: TradixColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  _MarketRow(ticker: 'AAPL', name: 'Apple Inc.', price: '\$189.30', change: '+1.2%', positive: true),
                  SizedBox(height: 10),
                  _MarketRow(ticker: 'TSLA', name: 'Tesla Inc.', price: '\$213.17', change: '+2.7%', positive: true),
                  SizedBox(height: 10),
                  _MarketRow(ticker: 'NVDA', name: 'Nvidia Inc.', price: '\$413.17', change: '-2.7%', positive: false),
                  SizedBox(height: 10),
                  _MarketRow(ticker: 'AMZN', name: 'Amazon Inc.', price: '\$713.17', change: '-2.7%', positive: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketRow extends StatelessWidget {
  final String ticker;
  final String name;
  final String price;
  final String change;
  final bool positive;

  const _MarketRow({
    required this.ticker,
    required this.name,
    required this.price,
    required this.change,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = positive ? TradixColors.green : TradixColors.red;
    final badgeBg = positive ? TradixColors.greenSoft : TradixColors.redSoft;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: TradixColors.line),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                ticker[0],
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: TradixColors.dark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticker,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: TradixColors.dark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 11,
                    color: TradixColors.muted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: TradixColors.dark,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              change,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}