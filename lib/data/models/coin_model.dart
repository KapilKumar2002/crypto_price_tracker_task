class CoinModel {
  final String symbol;
  final double price;

  CoinModel({required this.symbol, required this.price});

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      symbol: json['symbol'],
      price: double.parse(json['price'].toString()),
    );
  }
}