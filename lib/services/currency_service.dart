class CurrencyService {
  CurrencyService._();

  static const Map<String, double> ratesToUsd = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.78,
    'JPY': 157.0,
    'KZT': 480.0,
  };

  static double convertFromUsd(double usdPrice, String currencyCode) {
    final rate = ratesToUsd[currencyCode] ?? 1.0;
    return usdPrice * rate;
  }

  static String formatPrice(double usdPrice, String currencyCode) {
    final converted = convertFromUsd(usdPrice, currencyCode);

    if (currencyCode == 'JPY' || currencyCode == 'KZT') {
      return '$currencyCode ${converted.toStringAsFixed(0)}';
    }

    return '$currencyCode ${converted.toStringAsFixed(2)}';
  }
}