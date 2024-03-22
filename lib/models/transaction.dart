class Transaction {
  //atributos
  final String id;
  final String title;
  final double value;
  final DateTime date;

  Transaction(
      { //construtor
      required this.id,
      required this.title,
      required this.value,
      required this.date});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      value: json['value'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'date': date.toIso8601String(),
    };
  }
}
