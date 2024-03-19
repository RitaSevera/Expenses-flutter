import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  final _transaction = [
    Transaction(id: "t1", title: "Water bill", value: 27, date: DateTime.now()),
    Transaction(
        id: "t2", title: "Sneakers", value: 120.99, date: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 197, 153, 205),
        centerTitle: true,
        title: const Text("Personal Expenses"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Card(
            child: Text("Graphic"),
          ),
          Column(
            children: _transaction.map((tr) {
              return Card(
                child: Row(children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.lime,
                      width: 2,
                    )),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "${tr.value.toStringAsFixed(2)} €", //toString não era necessário, mas pus para aparecer 2 casas decimais
                      //"€" + tr.value.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromARGB(255, 173, 134, 239)),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat.yMMMMd().format(
                            tr.date), //só consigo fazer assim pq importei intl
                        style: const TextStyle(
                          color: Color.fromARGB(255, 128, 127, 127),
                        ),
                      ),
                    ],
                  )
                ]),
              );
            }).toList(),
          ),
          const Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Title",
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Value €"),
                  ),
                  OutlinedButton(
                    onPressed: null,
                    child: Text(
                      "New transaction",
                      style:
                          TextStyle(color: Color.fromARGB(255, 180, 122, 165)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
