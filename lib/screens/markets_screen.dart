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
  bool _showNews = false;

  final List<String> _symbols = const [
    'AAPL',
    'TSLA',
    'NVDA',
    'AMZN',
  ];

  @override
  void initState() {
    super.initState();
    _future = _loadMarketData();
  }

  Future<Map<String, dynamic>> _loadMarketData() {
    return _service.fetchStockData(symbols: _symbols, limit: 100);
  }

  String _companyName(String symbol) {
    const names = {
      'AAPL': 'Apple Inc.',
      'TSLA': 'Tesla Inc.',
      'NVDA': 'Nvidia Inc.',
      'AMZN': 'Amazon Inc.',
    };

    return names[symbol] ?? symbol;
  }

  String _logoUrl(String symbol) {
    const logos = {
      'AAPL': 'https://logo.clearbit.com/apple.com',
      'TSLA': 'https://logo.clearbit.com/tesla.com',
      'NVDA': 'https://logo.clearbit.com/nvidia.com',
      'AMZN': 'https://logo.clearbit.com/amazon.com',
    };

    return logos[symbol] ?? '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TradixColors.pageBg,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _future,
          builder: (context, snapshot) {
            final rawData = snapshot.data?['data'] as List<dynamic>? ?? [];
            final rows = _buildRows(rawData);

            return ListView(
              padding: const EdgeInsets.fromLTRB(32, 58, 32, 112),
              children: [
                const Center(
                  child: Text(
                    'Markets and News',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const _SearchBar(),
                const SizedBox(height: 28),
                _ModeTabs(
                  showNews: _showNews,
                  onStocks: () => setState(() => _showNews = false),
                  onNews: () => setState(() => _showNews = true),
                ),
                const SizedBox(height: 24),
                if (_showNews)
                  const _NewsList()
                else ...[
                  const _CategoryTabs(),
                  const SizedBox(height: 16),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: TradixColors.teal,
                        ),
                      ),
                    )
                  else if (snapshot.hasError)
                    Text(
                      'Markets loading error:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    )
                  else
                    ...rows.map((stockData) {
                      final symbol = stockData['symbol']?.toString() ?? '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _MarketCard(
                          stockData: stockData,
                          companyName: _companyName(symbol),
                          logoUrl: _logoUrl(symbol),
                          onTap: () => _openStockDetail(symbol),
                        ),
                      );
                    }),
                ],
              ],
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
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 14),
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
    return Container(
      height: 70,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9ED),
        borderRadius: BorderRadius.circular(8),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: active ? const Color(0xFF5F9EA0) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: active
              ? Border.all(color: const Color(0xFF4A8688), width: 2)
              : null,
          boxShadow: active
              ? const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: active ? Colors.white : const Color(0xFF666A70),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : const Color(0xFF666A70),
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ],
        ),
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
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF5F9EA0) : const Color(0xFFEDEFF4),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: active ? const Color(0xFF5F9EA0) : const Color(0xFFC9CED8),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
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
  final String logoUrl;
  final VoidCallback? onTap;

  const _MarketCard({
    required this.stockData,
    required this.companyName,
    required this.logoUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final symbol = stockData['symbol']?.toString() ?? '';
    final close = (stockData['close'] as num?)?.toDouble() ?? 0.0;
    final open = (stockData['open'] as num?)?.toDouble() ?? 0.0;

    final changePercent = open == 0 ? 0.0 : ((close - open) / open) * 100;
    final positive = changePercent >= 0;

    final badgeBg = positive ? const Color(0xFFD7F5E0) : const Color(0xFFFADBDC);
    final badgeText = positive ? const Color(0xFF1B9C5C) : const Color(0xFFD23B3F);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
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
                color: const Color(0xFFF1F2F5),
                borderRadius: BorderRadius.circular(21),
              ),
              child: ClipOval(
                child: Image.network(
                  logoUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.show_chart,
                    size: 18,
                    color: TradixColors.teal,
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
                    symbol,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    companyName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8A8F98),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${close.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFFB9BDC6)),
          ],
        ),
      ),
    );
  }
}

class _NewsList extends StatelessWidget {
  const _NewsList();

  static const _news = [
    _NewsItem(
      title: 'Apple releases new product lineup',
      subtitle: 'Apple announced its latest product lineup with innovative features.',
      time: '2 hours ago',
      imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=200',
    ),
    _NewsItem(
      title: 'Q2 Earnings Beat Expectations Despite Market Headwinds',
      subtitle: 'Apple reported stronger than expected earnings.',
      time: '5 hours ago',
      imageUrl: 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=200',
    ),
    _NewsItem(
      title: 'Analysts Raise Price Target Following Product Launch',
      subtitle: 'Major investment firms increased their outlook.',
      time: '1 day ago',
      imageUrl: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200',
    ),
    _NewsItem(
      title: 'Q2 Earnings Beat Expectations Despite Market Headwinds',
      subtitle: 'Apple reported stronger than expected earnings.',
      time: '5 hours ago',
      imageUrl: 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=200',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _news.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _NewsCard(item: item),
        );
      }).toList(),
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
    return Container(
      height: 106,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFF5F9EA0),
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
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.white),
                    const SizedBox(width: 3),
                    Text(
                      item.time,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}