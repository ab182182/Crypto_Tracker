import 'package:cripto_tracker/models/crypto_currency.dart';
import 'package:cripto_tracker/providers/market_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/details_page.dart';

class CryptoListTile extends StatelessWidget {

  final CryptoCurrency currentCrypto;

  const CryptoListTile({Key? key, required this.currentCrypto}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    MarketProvider marketProvider = Provider.of<MarketProvider>(context, listen: false);

    return ListTile(
      onTap: () {
        marketProvider.fetchPriceChartData(currentCrypto.id!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              id: currentCrypto.id!,
            ),
          ),
        );
      },
      contentPadding: const EdgeInsets.all(0),
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(currentCrypto.image!),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              currentCrypto.name!,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              currentCrypto.isFavorite
                  ? marketProvider
                  .removeFavorites(currentCrypto)
                  : marketProvider.addFavorite(currentCrypto);
            },
            child: currentCrypto.isFavorite
                ? const Icon(
              CupertinoIcons.heart_fill,
              size: 20,
              color: Colors.red,
            )
                : const Icon(
              CupertinoIcons.heart,
              size: 20,
            ),
          ),
        ],
      ),
      subtitle: Text(currentCrypto.symbol!.toUpperCase()),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "₹ ${currentCrypto.currentPrice!.toStringAsFixed(4)}",
            style: const TextStyle(
              color: Color(0xff0395eb),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Builder(
            builder: (context) {
              double priceChange = currentCrypto.priceChange24!;
              double priceChangePercentage =
              currentCrypto.priceChangePercentage24!;
              if (priceChange < 0) {
                return Text(
                  "${priceChangePercentage.toStringAsFixed(2)}% (${priceChange.toStringAsFixed(4)})",
                  style: const TextStyle(color: Colors.red),
                );
              } else {
                return Text(
                  "+${priceChangePercentage.toStringAsFixed(2)}% (+${priceChange.toStringAsFixed(4)})",
                  style: const TextStyle(color: Colors.green),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
