import 'package:cripto_tracker/models/local_storage.dart';
import 'package:flutter/material.dart';
import '../models/api.dart';
import '../models/crypto_currency.dart';
import '../models/price_chart.dart';

class MarketProvider with ChangeNotifier {
  bool isLoading = true;
  List<CryptoCurrency> markets = [];
  List<PriceChart> priceChart = [];
  Color priceChartLineColor = Colors.black;

  MarketProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    List<dynamic> _markets = await API.getMarkets();
    List<String> favorites = await LocalStorage.fetchFavorites();

    List<CryptoCurrency> temp = [];
    for (var market in _markets) {
      CryptoCurrency newCrypto = CryptoCurrency.fromJSON(market);

      if(favorites.contains(newCrypto.id!)) {
        newCrypto.isFavorite = true;
      }

      temp.add(newCrypto);
    }

    markets = temp;
    isLoading = false;
    notifyListeners();

  }

  CryptoCurrency fetchCryptoById(String id) {
    CryptoCurrency crypto = markets.where((element) => element.id == id).toList()[0];
    return crypto;
  }

  void addFavorite(CryptoCurrency crypto) async {
    int indexOfCrypto = markets.indexOf(crypto);
    markets[indexOfCrypto].isFavorite = true;
    await LocalStorage.addFavorites(crypto.id!);
    notifyListeners();
  }

  void removeFavorites(CryptoCurrency crypto) async {
    int indexOfCrypto = markets.indexOf(crypto);
    markets[indexOfCrypto].isFavorite = false;
    await LocalStorage.removeFavorites(crypto.id!);
    notifyListeners();
  }

  Future<void> fetchPriceChartData(String coinId) async {
    final List data = await API.getPriceCharts(coinId);
    final List<PriceChart> result = [];

    for(List element in data) {
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(element[0]);
      final String day = convertToDayName(date.weekday);
      final double price = element[1];
      
      result.add(PriceChart(day: day, price: price));
    }

    priceChart = result;
    priceChartLineColor = getPriceChartLineColor(priceChart);
    notifyListeners();
  }

}

Color getPriceChartLineColor(List<PriceChart> priceChart) {
  final PriceChart latestPriceChange = priceChart.elementAt(priceChart.length - 1);
  final PriceChart yesterdayPriceChange = priceChart.elementAt(priceChart.length - 2);

  double priceDifference = latestPriceChange.price - yesterdayPriceChange.price;

  if(priceDifference > 0) {
    return Colors.green;
  } else if(priceDifference < 0) {
    return Colors.red;
  } else {
    return Colors.yellow;
  }
}

String convertToDayName(int day) {
  late String dayName;

  switch(day){
    case 1:
      dayName = "Mon";
      break;
    case 2:
      dayName = "Tue";
      break;
    case 3:
      dayName = "Wed";
      break;
    case 4:
      dayName = "Thu";
      break;
    case 5:
      dayName = "Fri";
      break;
    case 6:
      dayName = "Sat";
      break;
    case 7:
      dayName = "Sun";
      break;
    default:
  }
  return dayName;
}
