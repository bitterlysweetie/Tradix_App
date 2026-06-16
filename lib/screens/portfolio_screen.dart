import 'package:flutter/material.dart';

import '../shared/tradix_shared.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TradixColors.pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
          children: const [
            SizedBox(height: 2),
            Center(
              child: Text(
                'My Portfolio',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: TradixColors.dark,
                ),
              ),
            ),
            SizedBox(height: 18),
            PortfolioSummaryCard(),
            SizedBox(height: 12),
            AssetAllocationCard(),
            SizedBox(height: 12),
            PerformanceCard(),
            SizedBox(height: 18),
            Text(
              'Your holdings',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: TradixColors.dark,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const TradixBottomBar(currentIndex: 2),
    );
  }
}

class PortfolioSummaryCard extends StatelessWidget {
  const PortfolioSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: TradixColors.teal,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Portfolio Value',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '\$17,826',
            style: TextStyle(
              fontSize: 26,
              height: 1,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: TradixColors.green,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color(0xFF3CBF65), width: 1),
              ),
              child: const Text(
                '▲ +\$319.16 (+1.6%) today',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF0D4E1F),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: TradixColors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: TradixColors.line),
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
          const Text(
            'Asset Allocation',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: TradixColors.dark,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              SizedBox(
                width: 96,
                height: 96,
                child: CustomPaint(
                  painter: DonutPainter(),
                ),
              ),
              SizedBox(width: 14),
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
      children: const [
        LegendRow(color: TradixColors.purple, ticker: 'AAPL', value: '35%'),
        SizedBox(height: 8),
        LegendRow(color: TradixColors.orange, ticker: 'NVDA', value: '25%'),
        SizedBox(height: 8),
        LegendRow(color: TradixColors.yellow, ticker: 'TSLA', value: '25%'),
        SizedBox(height: 8),
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
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: TradixColors.dark,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: TradixColors.dark,
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: TradixColors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: TradixColors.line),
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
          const Text(
            'Performance (6 month)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: TradixColors.dark,
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
                    painter: PerformancePainter(),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
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
                    children: const [
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
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFF9AA3AA),
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
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFF9AA3AA),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}