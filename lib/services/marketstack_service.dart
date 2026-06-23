import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MarketstackService {
  final String? _apiKey = dotenv.env['API_KEY'];
  final String _baseUrl = 'http://api.marketstack.com/v1';

  Future<List<String>> fetchActiveTickers({int limit = 10}) async {
    _ensureApiKey();

    final url = Uri.parse(
      '$_baseUrl/tickers?access_key=$_apiKey&limit=$limit',
    );

    final response = await http.get(url);
    final jsonResponse = _decodeResponse(response, 'tickers');

    final List<dynamic> data = jsonResponse['data'] ?? [];

    return data
        .map<String>((item) => item['symbol']?.toString() ?? '')
        .where((symbol) => symbol.isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> fetchStockData({
    required List<String> symbols,
    int limit = 30,
  }) async {
    _ensureApiKey();

    if (symbols.isEmpty) {
      return {'data': []};
    }

    final symbolsString = symbols.join(',');

    final url = Uri.parse(
      '$_baseUrl/eod?access_key=$_apiKey&symbols=$symbolsString&limit=$limit',
    );

    final response = await http.get(url);

    return _decodeResponse(response, 'stock data');
  }

  Future<Map<String, dynamic>> fetchStockHistory({
    required String symbol,
    int limit = 30,
  }) async {
    _ensureApiKey();

    final url = Uri.parse(
      '$_baseUrl/eod?access_key=$_apiKey&symbols=$symbol&limit=$limit',
    );

    final response = await http.get(url);

    return _decodeResponse(response, 'stock history');
  }

  void _ensureApiKey() {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('Marketstack API key is missing. Check your .env file.');
    }
  }

  Map<String, dynamic> _decodeResponse(http.Response response, String action) {
    if (response.statusCode != 200) {
      throw Exception("Couldn't load $action: ${response.body}");
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (jsonResponse['error'] != null) {
      final error = jsonResponse['error'];

      if (error is Map<String, dynamic>) {
        throw Exception(error['message'] ?? 'Marketstack API error');
      }

      throw Exception('Marketstack API error');
    }

    return jsonResponse;
  }
}