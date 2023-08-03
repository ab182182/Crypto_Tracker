import 'package:cripto_tracker/widgets/cryptoListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crypto_currency.dart';
import '../providers/market_provider.dart';

class Markets extends StatefulWidget {
  const Markets({Key? key}) : super(key: key);

  @override
  State<Markets> createState() => _MarketsState();
}

class _MarketsState extends State<Markets> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MarketProvider>(
      builder: (context, marketProvider, child) {
        if (marketProvider.isLoading == true) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (marketProvider.markets.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await marketProvider.fetchData();
              },
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: marketProvider.markets.length,
                  itemBuilder: (context, index) {
                    CryptoCurrency currentCrypto =
                        marketProvider.markets[index];
                    return CryptoListTile(currentCrypto: currentCrypto);
                  }),
            );
          } else {
            return const Text("Data not Found");
          }
        }
      },
    );
  }
}
