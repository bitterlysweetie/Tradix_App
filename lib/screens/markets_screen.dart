import 'package:flutter/material.dart';
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

  late Future<Map<String, dynamic>> _future;

  final List<String> _symbols = const [
    'AAPL',
    'TSLA',
    'NVDA',
    'AMZN',
    'MSFT',
    'GOOGL',
    'META',
    'AMD',
  ];

  @override
  void initState() {
    super.initState();
    _future = _loadMarketData();
  }

  Future<Map<String, dynamic>> _loadMarketData() {
    return _service.fetchStockData(
      symbols: _symbols,
      limit: 100,
    );
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
      'AMD': 'Advanced Micro Devices',
    };

    return names[symbol] ?? symbol;
  }

  IconData _companyIcon(String symbol) {
    const icons = {
      'AAPL': Icons.apple,
      'TSLA': Icons.electric_car,
      'NVDA': Icons.memory,
      'AMZN': Icons.shopping_bag_outlined,
      'MSFT': Icons.window,
      'GOOGL': Icons.search,
      'META': Icons.public,
      'AMD': Icons.developer_board,
    };

    return icons[symbol] ?? Icons.show_chart;
  }

  Color _companyIconBg(String symbol) {
    const colors = {
      'AAPL': Color(0xFF05070A),
      'TSLA': Color(0xFFE50914),
      'NVDA': Color(0xFF05070A),
      'AMZN': Color(0xFFFFFFFF),
      'MSFT': Color(0xFF2F80ED),
      'GOOGL': Color(0xFFFFFFFF),
      'META': Color(0xFF1877F2),
      'AMD': Color(0xFF111827),
    };

    return colors[symbol] ?? TradixColors.teal;
  }

  Color _companyIconColor(String symbol) {
    if (symbol == 'AMZN' || symbol == 'GOOGL') {
      return TradixColors.dark;
    }

    if (symbol == 'NVDA') {
      return const Color(0xFF76B900);
    }

    return Colors.white;
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

  Future<void> _refresh() async {
    setState(() {
      _future = _loadMarketData();
    });

    await _future;
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
                    'Markets loading error:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: TradixColors.dark),
                  ),
                ),
              );
            }

            final rawData = snapshot.data?['data'] as List<dynamic>? ?? [];
            final rows = _buildRows(rawData);

            return RefreshIndicator(
              color: TradixColors.teal,
              onRefresh: _refresh,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(30, 48, 30, 112),
                children: [
                  const Center(
                    child: Text(
                      'Markets and News',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _SearchBar(),
                  const SizedBox(height: 22),
                  const _ModeTabs(),
                  const SizedBox(height: 20),
                  const _CategoryTabs(),
                  const SizedBox(height: 12),
                  if (rows.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(18),
                      child: Center(child: Text('No market data available')),
                    )
                  else
                    ...rows.map((stockData) {
                      final symbol = stockData['symbol']?.toString() ?? '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 13),
                        child: _MarketCard(
                          stockData: stockData,
                          companyName: _companyName(symbol),
                          icon: _companyIcon(symbol),
                          iconBg: _companyIconBg(symbol),
                          iconColor: _companyIconColor(symbol),
                          onTap: () => _openStockDetail(symbol),
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: const Color(0xFF5F9EA0),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, size: 18, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Search stocks, news or ETFs...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTabs extends StatelessWidget {
  const _ModeTabs();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8EC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF5F9EA0),
                borderRadius: BorderRadius.circular(7),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'Stocks',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.newspaper, size: 18, color: Color(0xFF6B7280)),
                  SizedBox(width: 6),
                  Text(
                    'News',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w700,
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

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _CategoryChip(label: 'All', active: true),
        SizedBox(width: 7),
        _CategoryChip(label: 'Technology'),
        SizedBox(width: 7),
        _CategoryChip(label: 'Finance'),
        SizedBox(width: 7),
        _CategoryChip(label: 'Health'),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool active;

  const _CategoryChip({
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 29,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF5F9EA0) : const Color(0xFFEDEFF4),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: active ? const Color(0xFF5F9EA0) : const Color(0xFFD3D7DF),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: active ? Colors.white : const Color(0xFF4B5563),
        ),
      ),
    );
  }
}

class _MarketCard extends StatelessWidget {
  final Map<String, dynamic> stockData;
  final String companyName;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback? onTap;

  const _MarketCard({
    required this.stockData,
    required this.companyName,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final symbol = stockData['symbol']?.toString() ?? '';

    final close = (stockData['close'] as num?)?.toDouble() ?? 0.0;
    final open = (stockData['open'] as num?)?.toDouble() ?? 0.0;

    final changePrice = close - open;
    final changePercent = open == 0 ? 0.0 : (changePrice / open) * 100;
    final positive = changePercent >= 0;

    final badgeBg = positive ? const Color(0xFFCFF5D9) : const Color(0xFFF8BFC0);
    final badgeBorder = positive ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    final badgeText = positive ? const Color(0xFF047857) : const Color(0xFFB91C1C);

    final priceText = '\$${close.toStringAsFixed(2)}';
    final changeText =
        '${positive ? '+' : ''}${changePercent.toStringAsFixed(1)}%';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: 96,
        padding: const EdgeInsets.fromLTRB(12, 13, 13, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFF9ED1D4),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 31,
                  height: 31,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: iconBg == Colors.white
                          ? const Color(0xFFD1D5DB)
                          : iconBg,
                    ),
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 86),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symbol,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          companyName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          priceText,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 1,
              right: 1,
              child: Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: badgeBorder, width: 1.4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      positive ? Icons.trending_up : Icons.trending_down,
                      size: 14,
                      color: badgeText,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      changeText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: badgeText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}