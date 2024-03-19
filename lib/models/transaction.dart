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
}
