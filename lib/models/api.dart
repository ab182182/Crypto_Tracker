import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  static Future<List<dynamic>> getMarkets() async {
    try {
      final Uri url = Uri.parse(
          "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=50&page=1&sparkline=false");

      var response = await http.get(url);
      var decodedResponse = jsonDecode(response.body);

      List<dynamic> markets = decodedResponse;
      return markets;
    } catch (ex) {
      return [];
    }
  }

  static Future<List> getPriceCharts(String id) async {
    try {
      final Uri uri = Uri.parse(
          "https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=inr&days=7&interval=daily");

      var response = await http.get(uri);
      var decodedResponse = jsonDecode(response.body);

      List priceChart = decodedResponse['prices'];

      return priceChart;
    } catch (ex) {
      return [];
    }
  }
}
