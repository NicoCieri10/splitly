class Debt {
  Debt({
    this.debtor,
    this.creditor,
    this.amount,
  });

  factory Debt.fromJson(Map<String, dynamic> json) => Debt(
        debtor: json['debtor'] as String?,
        creditor: json['creditor'] as String?,
        amount: json['amount'] as double?,
      );

  final String? debtor;
  final String? creditor;
  final double? amount;
}
