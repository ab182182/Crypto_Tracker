import 'package:cripto_tracker/models/crypto_currency.dart';
import 'package:cripto_tracker/providers/market_provider.dart';
import 'package:cripto_tracker/widgets/cryptoListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MarketProvider>(builder: (context, marketProvider, child) {
      List<CryptoCurrency> favorites = marketProvider.markets
          .where((element) => element.isFavorite == true)
          .toList();
      return favorites.isNotEmpty
          ? RefreshIndicator(
        onRefresh: () async {
          await marketProvider.fetchData();
        },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  CryptoCurrency currentCrypto = favorites[index];
                  return CryptoListTile(
                    currentCrypto: currentCrypto,
                  );
                },
              ),
          )
          : const Center(
              child: Text(
                "No favorites yet...",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            );
    });
  }
}
