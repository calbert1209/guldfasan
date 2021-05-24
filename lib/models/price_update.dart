class PriceUpdate {
  PriceUpdate({this.btc, this.eth, this.error});

  final int? btc;
  final int? eth;
  final String? error;

  factory PriceUpdate.fromMap(Map<String, dynamic> map) {
    return PriceUpdate(
      btc: map['btc'] as int?,
      eth: map['eth'] as int?,
      error: map['error'] as String?,
    );
  }
}
