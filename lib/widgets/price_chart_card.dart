import 'package:cripto_tracker/models/price_chart.dart';
import 'package:cripto_tracker/providers/market_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PriceChartCard extends StatefulWidget {
  final String coinId;

  const PriceChartCard({Key? key, required this.coinId}) : super(key: key);

  @override
  State<PriceChartCard> createState() => _PriceChartCardState();
}

class _PriceChartCardState extends State<PriceChartCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MarketProvider>(
      builder: (context, marketProvider, child) {
        final List<PriceChart> priceChange = marketProvider.priceChart;
        return Column(
          children: [
            const Text(
              "Change in price this week",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            SfCartesianChart(
            enableAxisAnimation: true,
              primaryXAxis: CategoryAxis(),
              palette: [marketProvider.priceChartLineColor],
              series: <ChartSeries>[
                LineSeries<PriceChart, String>(
                  dataSource: priceChange,
                  xValueMapper: (PriceChart price, _) => price.day,
                  yValueMapper: (PriceChart price, _) => price.price,
                  markerSettings: const MarkerSettings(isVisible: true),
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
